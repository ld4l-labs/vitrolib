/* $This file is distributed under the terms of the license in /doc/license.txt$ */
//We already have a working version of LCSH but this is tying into the central service
//fueling QA.  For now, just using this for one of the autocomplete fields

package edu.cornell.mannlib.semservices.service.impl;

import edu.cornell.mannlib.semservices.bo.Concept;
import net.sf.json.JSONObject;

public class FASTImpl extends QuestioningAuthority {

	protected final String schemeUri = "http://id.worldcat.org/fast/";
	//protected final String authority = "oclcfast_ld4l_cache";
	protected final String authority = "oclcfast_direct";

	public String getAuthority() {
		return authority;
	}
	
	public String getSubAuthority() {
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
		//Don't know if we have any real workld object info?
		return concept;
	}

	//We don't need this right now

	
	
		

}
