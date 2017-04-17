/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.semservices.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import edu.cornell.mannlib.semservices.bo.Concept;
import edu.cornell.mannlib.semservices.service.ExternalConceptService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class LCNAFImpl implements ExternalConceptService {

	protected final Log logger = LogFactory.getLog(getClass());
	private final String schemeUri = "http://id.loc.gov/authorities/names";
	
	//Followed by ?q=whatever term
	protected final String lcnafQuery = "http://elr37-dev.library.cornell.edu/qa/search/loc/names";
	//Followed by id
	protected final String lcnafTerm = "https://elr37-dev.library.cornell.edu/qa/show/linked_data/loc/names/";
	@Override
	public List<Concept> getConcepts(String term) throws Exception {
		List<Concept> conceptList = new ArrayList<Concept>();
		
		
		JSONArray queryResults = getQueryResults(term);
		if(queryResults != null) {
			int queryResultsNumber = queryResults.size();
			int q;
			for (q = 0; q < queryResultsNumber; q++) {
				JSONObject result = queryResults.getJSONObject(q);
				String label = getLabel(result);
				//Get individual term information to retrieve the URI
				JSONObject termResult = getTermResult(result);
				if(termResult != null) {
					conceptList.add(createConcept(termResult));
				}
			}
		}

		return conceptList;
	}



	


	private JSONObject getTermResult(JSONObject result) {
		if(result != null) {
			//What is returned is object 
			//Get the last part of the id
			String id = result.getString("id");
			//Get the local part
			String localName = getLocalName(id);
			String linkedDataURL = lcnafTerm + localName; 
			try {
				String linkedDataResult = retrieveFromURL(linkedDataURL);
				if(StringUtils.isNotEmpty(linkedDataResult)) {
					JSONObject termResult = (JSONObject) JSONSerializer.toJSON(linkedDataResult);
					return termResult;
				}
			} catch(Exception ex) {
				
			}
		}
		return null;
	}






	private String getLocalName(String id) {
		String prefixString = "info:lc/authorities/names/";
		if(id.startsWith(prefixString)) {
			return id.substring(prefixString.length());
		}
		return null;
	}






	private String getLabel(JSONObject result) {
		if(result != null) {
			String label = result.getString("label");
			return label;
		}
		return null;
	}





	//Do query with term and retrieve results
	private JSONArray getQueryResults(String term) {
		try {
			String encodedTerm = URLEncoder.encode(term, "UTF-8");
			String serviceURL = lcnafQuery + "?q=" + encodedTerm;
			String results = retrieveFromURL(serviceURL);
			if(StringUtils.isNotEmpty(results)) {
				JSONArray queryResults = (JSONArray) JSONSerializer.toJSON(results);
				return queryResults;
			}
		} catch(Exception ex) {
			logger.error("Error retrieving query results for term ", ex);
		}
		
		return null;
	}






	private String retrieveFromURL(String url) throws Exception {
		String results = new String();
	      //System.out.println("url: "+url);
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






	public List<Concept> processResults(String term) throws Exception {
		return getConcepts(term);
	}

	public Concept createConcept(JSONObject termResult) {

		Concept concept = new Concept();
		concept.setUri(termResult.getString("uri"));
		
		concept.setConceptId(termResult.getString("id"));
		//concept.setBestMatch("true"); //not sure about best matches here
		concept.setDefinedBy(schemeUri);
		concept.setSchemeURI(this.schemeUri);
		concept.setType(getType(termResult));
		concept.setLabel(getLabelFromLinkedDataRequest(termResult));
		concept.setAltLabelList(getAltLabelsFromLinkedDataRequest(termResult));
		return concept;
	}


	//Just return the first one right now
	private String getLabelFromLinkedDataRequest(JSONObject termResult) {
		if(termResult.containsKey("label")) {
		JSONArray labels = termResult.getJSONArray("label");
			if(labels.size() > 0) {
				return labels.getString(0);
			}
		}
		return null;
	}


	private List<String> getAltLabelsFromLinkedDataRequest(JSONObject termResult) {
		List<String> altLabels = new ArrayList<String>();
		if(termResult.containsKey("altLabel")) {
			JSONArray labels = termResult.getJSONArray("altLabel");
			int length = labels.size();
			int l;
			for(l = 0; l < length; l++) {
				altLabels.add(labels.getString(l));
			}
		}
		return altLabels;
	}



	//These are name authorities, and we want to know whether corporate or personal
	private String getType(JSONObject termResult) {
		if(termResult.containsKey("predicates")) {
			JSONObject predicates = termResult.getJSONObject("predicates");
			if(predicates.containsKey("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")) {
				JSONArray types = predicates.getJSONArray("http://www.w3.org/1999/02/22-rdf-syntax-ns#type");
				if(types.contains("http://www.loc.gov/mads/rdf/v1#CorporateName")) {
					return "corporate";
				} else if(types.contains("http://www.loc.gov/mads/rdf/v1#PersonalName")) {
					return "personal";
				}
			}
		}
		return null;
	}






	//We don't need this right now

	@Override
	public List<Concept> getConceptsByURIWithSparql(String uri) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	
		

}
