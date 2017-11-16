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
		
		return concept;
	}







	//We don't need this right now

	@Override
	public List<Concept> getConceptsByURIWithSparql(String uri) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	
		

}
