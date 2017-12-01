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
import java.util.ListIterator;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import edu.cornell.mannlib.semservices.bo.Concept;
import edu.cornell.mannlib.semservices.bo.RelatedTermInfo;

import edu.cornell.mannlib.semservices.service.ExternalConceptService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class LCGFImpl implements ExternalConceptService {

	protected final Log logger = LogFactory.getLog(getClass());
	private final String schemeUri =  "http://id.loc.gov/authorities/genreForms";
	
	//Followed by ?q=whatever term

	protected final String lcgfQuery = "http://elr37-dev.library.cornell.edu/qa/search/linked_data/locgenres_ld4l_cache";



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
			String serviceURL = lcgfQuery + "?q=" + encodedTerm;
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

	
	/*
	 * Example result from lookup:
	 * {"uri":"http://id.loc.gov/authorities/genreForms/gf2011026577",
	 * "id":"http://id.loc.gov/authorities/genreForms/gf2011026577",
	 * "label":"Singing cowboy films",
	 * "context":{"Alternate Label":[],
	 * "Broader":["http://id.loc.gov/authorities/genreForms/gf2011026735"],
	 * "Narrower":[],
	 * "Exact Match":[],
	 * "Note":["This heading is used as a genre/form heading for films that feature a non-violent, singing cowboy hero."]}}
	 */
	public Concept createConcept(JSONObject termResult) {
		Concept concept = new Concept();
		concept.setUri(termResult.getString("uri"));		
		concept.setConceptId(termResult.getString("id"));
		//concept.setBestMatch("true"); //not sure about best matches here
		concept.setDefinedBy(schemeUri);
		concept.setSchemeURI(this.schemeUri);
		concept.setType(null);
		concept.setLabel(getLabel(termResult));
		concept.setAltLabelList(getAlternateLabels(termResult));
		concept.setBroaderURIList(getBroaderURIList(termResult));
		concept.setNarrowerURIList(getNarrowerURIList(termResult));
		concept.setExactMatchURIList(getExactMatchURIList(termResult));
		concept.setDefinition(getDefinition(termResult));
		return concept;
	}

	private JSONObject getContextObject(JSONObject termResult) {
		if(termResult.containsKey("context")) {
			return termResult.getJSONObject("context");
		}
		return null;
	}

	private String getDefinition(JSONObject termResult) {
		JSONObject context = getContextObject(termResult);
		List<String> notesArray = getListForKey("Note", context);
		return StringUtils.join(notesArray, " ");
	}

	private List<RelatedTermInfo> getExactMatchURIList(JSONObject termResult) {
		JSONObject context = getContextObject(termResult);
		List<RelatedTermInfo> exactMatchURIs = getTermListForKey("Exact Match", context);
		return exactMatchURIs;
	}

	private List<RelatedTermInfo> getNarrowerURIList(JSONObject termResult) {
		JSONObject context = getContextObject(termResult);
		List<RelatedTermInfo> narrowerURIs = getTermListForKey("Narrower", context);
		return narrowerURIs;
	}

	private List<RelatedTermInfo> getBroaderURIList(JSONObject termResult) {
		JSONObject context = getContextObject(termResult);
		List<RelatedTermInfo> broaderURIs = getTermListForKey("Broader", context);
		return broaderURIs;

	}

	private List<String> getAlternateLabels(JSONObject termResult) {
		JSONObject context = getContextObject(termResult);
		List<String> altLabels = getListForKey("Alternate Label", context);
		return altLabels;
	}
	
	//JSON Object has key that returns array which needs to be converted to List<String>
	private List<String> getListForKey(String key, JSONObject jsonObject) {
		List<String> array = new ArrayList<String>();
		if(jsonObject != null) {
			if(jsonObject.containsKey(key)) {
				JSONArray jsonArray = jsonObject.getJSONArray(key);
				array = convertJSONArrayToList(jsonArray);
			}
		}
		return array;
	}
	
	//JSON Object has key that returns array which needs to be converted to List<String>
	private List<RelatedTermInfo> getTermListForKey(String key, JSONObject jsonObject) {
		List<RelatedTermInfo> array = new ArrayList<RelatedTermInfo>();
		if(jsonObject != null) {
			if(jsonObject.containsKey(key)) {
				JSONArray jsonArray = jsonObject.getJSONArray(key);
				array = convertJSONArrayToTermList(jsonArray);
			}
		}
		return array;
	}

	private List<String> convertJSONArrayToList(JSONArray jsonArray) {
		List<String> listArray = new ArrayList<String>();

		for(Object o: jsonArray) {
			listArray.add(o.toString());
		}
		return listArray;
	}
	
	private List<RelatedTermInfo> convertJSONArrayToTermList(JSONArray jsonArray) {
		List<RelatedTermInfo> listArray = new ArrayList<RelatedTermInfo>();
		int len = jsonArray.size();
		int l;
		for(l = 0; l < len; l++) {
			JSONObject jObject = jsonArray.getJSONObject(l);
			listArray.add(new RelatedTermInfo( jObject.getString("label"), jObject.getString("uri") ));

		}
		return listArray;
	}


	@Override
	public List<Concept> getConceptsByURIWithSparql(String uri) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	
		

}
