/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.semservices.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import edu.cornell.mannlib.semservices.bo.Concept;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class LCNAFImpl extends QuestioningAuthority {

	protected final Log logger = LogFactory.getLog(getClass());
	protected final String schemeUri = "http://id.loc.gov/authorities/names";
	protected final String authority = "locnames_ld4l_cache";

	
	//Followed by id
	protected final String lcnafTerm = "https://elr37-dev.library.cornell.edu/qa/show/linked_data/loc_direct/names/";
	
	public String getAuthority() {
		return authority;
	}
	
	public String getSubAuthority() {
		return null;
	}


	private JSONObject getTermResult(JSONObject result) {
		if(result != null) {
			//What is returned is object 
			//Get the last part of the id
			String uri = result.getString("uri");
			//Get the local part
			String localName = getLocalName(uri);
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
		String prefixString = "http://id.loc.gov/authorities/names/";
		if(id.startsWith(prefixString)) {
			return id.substring(prefixString.length());
		}
		return null;
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
		HashMap<String, Object> additionalInfo = getRWOInfo(termResult);
		concept.setAdditionalInformation(additionalInfo);
		return concept;
	}


	private HashMap<String, Object> getRWOInfo(JSONObject termResult) {
		HashMap<String, Object> additionalInfo =new HashMap<String, Object>();
		if(termResult.containsKey("context")) {
			JSONObject context = termResult.getJSONObject("context");
			//Translate context to hashmap, if the value is an object, return string representation for now
			//This may need to change later and we may just want to return the entire context object as is
			if(context != null) {
				try {
					Set <String> keys = (Set<String>) context.keySet();
					for(String key: keys) {
						additionalInfo.put(key, context.get(key));
					} 
				} catch(Exception ex) {
					logger.error("Error occurred in retrieving contextual information for " + termResult.toString());
				}
				
			}
		}
		return additionalInfo;
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

		

}
