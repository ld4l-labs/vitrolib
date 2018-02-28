/* $This file is distributed under the terms of the license in /doc/license.txt$ */
//We already have a working version of LCSH but this is tying into the central service
//fueling QA.  For now, just using this for one of the autocomplete fields

package edu.cornell.mannlib.semservices.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import edu.cornell.mannlib.semservices.bo.Concept;
import edu.cornell.mannlib.semservices.bo.RelatedTermInfo;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class LCGFImpl extends QuestioningAuthority {

	protected final Log logger = LogFactory.getLog(getClass());
	private final String schemeUri =  "http://id.loc.gov/authorities/names/";
	protected final String authority = "locgenres_ld4l_cache";
	
	public String getAuthority() {
		return authority;
	}
	
	public String getSubAuthority() {
		return null;
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
			if(jsonObject.containsKey(key) && (jsonObject.get(key) instanceof JSONArray)) {
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
			if(jsonObject.containsKey(key) && (jsonObject.get(key) instanceof JSONArray)) {
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
