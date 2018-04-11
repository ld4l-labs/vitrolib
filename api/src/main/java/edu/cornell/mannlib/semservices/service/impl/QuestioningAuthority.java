/* $This file is distributed under the terms of the license in /doc/license.txt$ */

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

/*
 * Questioning Authority interface for QA options.  
 */
public abstract class QuestioningAuthority implements ExternalConceptService {

	
	private final String queryTerm = "q";
	private final String qaURL = "http://elr37-dev.library.cornell.edu/qa/search/linked_data/";
	protected final Log logger = LogFactory.getLog(getClass());

	public abstract String getAuthority();
	public abstract String getSubAuthority();
	
	public List<Concept> processResults(String term) throws Exception {
		return getConcepts(term);
	}
	
	public abstract Concept createConcept(JSONObject termResult);
	
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
	
	//Do query with term and retrieve results
	
	protected JSONArray getQueryResults(String term) {
		try {
			String encodedTerm = URLEncoder.encode(term, "UTF-8");
			String authority = getAuthority();
			String subauthority = getSubAuthority();
			String serviceURL = qaURL + authority;
			if(StringUtils.isNotEmpty(subauthority)) {
				serviceURL += "/" + subauthority;
			}
			serviceURL += "?q=" + encodedTerm;
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

	protected String retrieveFromURL(String url) throws Exception {
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


	
	protected String getLabel(JSONObject result) {
		if(result != null) {
			String label = result.getString("label");
			return label;
		}
		return null;
	}
	
	@Override
	public List<Concept> getConceptsByURIWithSparql(String uri) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

		

}
