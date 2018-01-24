/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.semservices.service.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import edu.cornell.mannlib.semservices.bo.Concept;
import edu.cornell.mannlib.semservices.service.ExternalConceptService;

public class ISNIImpl implements ExternalConceptService {

    private static DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();

// full query example	
//	private final String isniQuery = "http://isni.oclc.nl/sru/DB=1.2/?query=pica.nw+%3D+%22maloy,%20rebecca%22&operation=searchRetrieve&recordSchema=isni-b";
	private final static String isniQuery = "http://isni.oclc.nl/sru/DB=1.2/?query=pica.nw+%3D+%22";
	private final static String maxRecordsToReturn = "10";
	private final static String isniQuerySuffix = "%22&operation=searchRetrieve&recordSchema=isni-b&maximumRecords=" + maxRecordsToReturn;
	private final static String isniSortKey = "&sortKeys=RLV%2Cpica%2C0%2C%2C"; // this should be 'relevance' order but doesn't appear to make a difference in returned data.
	
	private static final Log logger = LogFactory.getLog(ISNIImpl.class);

	static {
		factory = DocumentBuilderFactory.newInstance();
	}
	
	public ISNIImpl() {}

	@Override
	public List<Concept> processResults(String term) throws Exception {
		return getConcepts(term);
	}
	
	// TODO: allow for search based on person, organization or both
	// Currently, using "personOrFiction" just gets person, not organization.

	@Override
	public List<Concept> getConcepts(String term) throws Exception {

		List<Concept> conceptList = new ArrayList<Concept>();
		
		Document queryResultsDoc = getQueryResults(term);
		Element root = queryResultsDoc.getDocumentElement();
		NodeList nodes = root.getElementsByTagName("responseRecord");
		logger.debug("srw:record size: " + nodes.getLength());
		
		for (int i = 0; i < nodes.getLength(); i++) {
			Element responseRecordElem = (Element)nodes.item(i);
			if (getFirstChildElement(responseRecordElem, "personOrFiction") != null) {
				// Just in case, make sure 'null' not returned.
				Concept concept = createConcept(responseRecordElem);
				if (concept != null) {
					conceptList.add( concept );
				}
			}
			
		}

		return conceptList;
	}

	//We don't need this right now
	@Override
	public List<Concept> getConceptsByURIWithSparql(String uri) throws Exception {
		return null;
	}
	
	private Concept createConcept(Element responseRecordElement) {
		
		Concept concept = null;
		Element personOrFictionElement = getFirstChildElement(responseRecordElement, "personOrFiction");
		if (personOrFictionElement != null) {
			
			concept = new Concept();
			concept.setUri( getFirstChildElementTextContent(responseRecordElement, "isniURI") );

			StringBuilder labelBuilder = new StringBuilder();
			// get name and date
			labelBuilder.append( getNameAndDate(personOrFictionElement) );
			
			// get roles
			Element creativeActivityElem = getFirstChildElement(responseRecordElement, "creativeActivity");
			labelBuilder.append( getCreationRoles(creativeActivityElem) );

			// get works
			labelBuilder.append( getTitleOfWorks(creativeActivityElem) );
			concept.setLabel(labelBuilder.toString());
			
			logger.debug("Found personOrFiction to create Concept. URI: " + concept.getUri() + ", label: " + concept.getLabel());
		}
		return concept;
	}
	
	private String getNameAndDate(Element personOrFictionElement) {
		StringBuilder sb = new StringBuilder();
		
		Element preferredPersonalNameElem = null;
		String marcDate = null;
		
		// we want personalName that contains a <source> of "LC"
		boolean foundLC = false;
		NodeList personalNameElemList = personOrFictionElement.getElementsByTagName("personalName");
		for (int i = 0; i < personalNameElemList.getLength() && (!foundLC || marcDate == null); i++) {
			// get next element
			Element personalNameElem = (Element)personalNameElemList.item(i);
			// by default take the first element
			if (i == 0) {
				preferredPersonalNameElem = personalNameElem;
				// save date if it exists
				if (preferredPersonalNameElem.getElementsByTagName("marcDate").getLength() > 0) {
					marcDate = getFirstChildElementTextContent(preferredPersonalNameElem, "marcDate");
				}
			}
			
			// if element has "LC" as a source sub-element then this is the preferred personalName
			// otherwise we'll just use first element
			NodeList sources = personalNameElem.getElementsByTagName("source");
			for (int j = 0; j < sources.getLength() && !foundLC; j++) {
				Element sourceElem = (Element)sources.item(j);
				if ("LC".equalsIgnoreCase(sourceElem.getTextContent())) {
					foundLC = true;
					preferredPersonalNameElem = personalNameElem;
					
					// we also want to know if this "LC" element has a date element
					// since it is the preferred value
					if (personalNameElem.getElementsByTagName("marcDate").getLength() > 0) {
						marcDate = getFirstChildElementTextContent(preferredPersonalNameElem, "marcDate");
					}
				}
			}
			
			// we want either the date from an element with a "LC" source
			// or the first one we can fine
			if (marcDate == null) {
				marcDate = getFirstChildElementTextContent(personalNameElem, "marcDate");
			}
		}
		
		// now pull the name out of the selected element
		if (preferredPersonalNameElem != null) {
			sb.append( extractName(preferredPersonalNameElem) );
			if (marcDate != null) {
				sb.append(": ");
				sb.append(marcDate);
			}
		}
		
		return sb.toString();
	}
	
	private String extractName(Element personalName) {
		
		String surname = getFirstChildElementTextContent(personalName, "surname");
		String forename = getFirstChildElementTextContent(personalName, "forename");
		
		StringBuilder nameBuilder = new StringBuilder();
		if (StringUtils.isNotEmpty(surname)) {
			nameBuilder.append(surname);
			if (StringUtils.isNotEmpty(forename)) {
				nameBuilder.append(", ");
			}
		}
		if (StringUtils.isNotEmpty(forename)) {
			nameBuilder.append(forename);
		}
		
		return nameBuilder.toString();
	}
	
	// will return up to 3 concatenated create roles
	private String getCreationRoles(Element creativeActivity) {
		
		StringBuilder sb = new StringBuilder();
		NodeList list = creativeActivity.getElementsByTagName("creationRole");
		Element elem = null;
		if (list.getLength() > 0) {
			sb.append(", ");
		}
		boolean first = true;
		for (int i = 0; i < list.getLength() && i < 3; i++) {
			elem = (Element)list.item(i);
			if (first) {
				first = false;
			} else {
				sb.append('/');
			}
			sb.append(elem.getTextContent());
		}
		
		return sb.toString();
	}
	
	// will return up to 3 concatenated work titles
	private String getTitleOfWorks(Element creativeActivity) {
		
		StringBuilder sb = new StringBuilder();
		NodeList list = creativeActivity.getElementsByTagName("titleOfWork");
		Element elem = null;
		for (int i = 0; i < list.getLength() && i < 3; i++) {
			elem = (Element)list.item(i);
			sb.append(", ");
			String title = elem.getTextContent();
			if (title.indexOf('@') == 0 && title.length() > 1) {
				title = title.substring(1);
			}
			sb.append(title);
		}
		
		return sb.toString();
	}
	
	private String getFirstChildElementTextContent(Node node, String name) {
		String textContent = null;
		Element elem = getFirstChildElement(node, name);
		if (elem != null) {
			textContent = elem.getTextContent();
		}
		return textContent;
	}
	
	private Element getFirstChildElement(Node node, String name) {
		Element elem = null;
		NodeList list = ((Element)node).getElementsByTagName(name);
		if (list.getLength() > 0) {
			elem = (Element)list.item(0);
		}
		return elem;
	}

	//Do query with term and retrieve results
	private Document getQueryResults(String term) {
		try {
			String encodedTerm = URLEncoder.encode(term, "UTF-8");
			String serviceURL = isniQuery + encodedTerm + isniQuerySuffix + isniSortKey;
			logger.debug("Query:\n" + serviceURL);
			String results = retrieveFromURL(serviceURL);
			logger.debug("Result:\n" + results);
			Document doc = convertStringToDocument(results);			
			
			return doc;
		} catch(Exception ex) {
			logger.error("Error retrieving query results for term ", ex);
		}
		
		return null;
	}

	// accesses the external ISNI web service
	private String retrieveFromURL(String url) throws Exception {
		String results = new String();

		try {

	         StringWriter sw = new StringWriter();
	         URL serviceUrl = new URL(url);

	         BufferedReader in = new BufferedReader(new InputStreamReader(serviceUrl.openStream()));
	         String inputLine;
	         while ((inputLine = in.readLine()) != null) {
	            sw.write(inputLine);
	         }
	         in.close();

	         results = sw.toString();

	      } catch (Exception ex) {
	         logger.error("error occurred in servlet", ex);
	         ex.printStackTrace();
	         throw ex;
	      }
	      return results;
	}

    private Document convertStringToDocument(String xmlStr) throws ParserConfigurationException, SAXException, IOException {
    	
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse( new InputSource( new StringReader( xmlStr ) ) );

        return doc;
    }

}
