/* $This file is distributed under the terms of the license in /doc/license.txt$ */
//We already have a working version of LCSH but this is tying into the central service
//fueling QA.  For now, just using this for one of the autocomplete fields

package edu.cornell.mannlib.semservices.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import edu.cornell.mannlib.semservices.bo.Concept;
import edu.cornell.mannlib.semservices.service.ExternalConceptService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class LCSHQAImpl implements ExternalConceptService {

	protected final Log logger = LogFactory.getLog(getClass());
	private final String schemeUri = "http://id.loc.gov/authorities/subjects";
	
	//Followed by ?q=whatever term
	//protected final String lcnafQuery = "http://elr37-dev.library.cornell.edu/qa/search/loc/names";
	protected final String lcshQuery = "http://elr37-dev.library.cornell.edu/qa/search/linked_data/locsubjects_ld4l_cache";
	//Subauthorities include /locjena/personal_name, corporate_name, and title
	//http://elr37-dev.library.cornell.edu/qa/show/linked_data/locjena/names/n82045653


	@Override
	public List<Concept> getConcepts(String term) throws Exception {
		List<Concept> conceptList = new ArrayList<Concept>();
		
		
		JSONArray queryResults = getQueryResults(term);
		if(queryResults != null) {
			int queryResultsNumber = queryResults.size();
			int q;
			for (q = 0; q < queryResultsNumber; q++) {
				JSONObject result = queryResults.getJSONObject(q);
				
				if(result != null) {
					conceptList.add(createConcept(result));
				}
				
			}
		}

		return conceptList;
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
			String serviceURL = lcshQuery + "?q=" + encodedTerm;
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
		concept.setType(null);
		concept.setLabel(getLabel(termResult));
		concept.setAltLabelList(null);
		//Add real world object information
		HashMap<String, String> additionalInfo = getAdditionalInfo(termResult);
		concept.setAdditionalInformation(additionalInfo);
		return concept;
	}


	private HashMap<String, String> getAdditionalInfo(JSONObject termResult) {
		HashMap<String, String> additionalInfo = new HashMap<String, String>();
		if(termResult.containsKey("predicates")) {
			JSONObject predicates = termResult.getJSONObject("predicates");
			if (predicates.containsKey("http://www.loc.gov/mads/rdf/v1#identifiesRWO")) {
				JSONArray predicatesInfo = predicates.getJSONArray("http://www.loc.gov/mads/rdf/v1#identifiesRWO");
				//Not expecting multiple objects here? Is that possible?
				if(predicatesInfo.size() > 0) {
					additionalInfo.put("RWO", predicatesInfo.getString(0));
				}
			}
		}
		return additionalInfo;
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
		if(termResult.containsKey("altlabel")) {
			JSONArray labels = termResult.getJSONArray("altlabel");
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
