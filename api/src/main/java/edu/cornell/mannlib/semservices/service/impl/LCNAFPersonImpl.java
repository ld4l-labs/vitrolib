/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.semservices.service.impl;

public class LCNAFPersonImpl extends LCNAFImpl {

	protected final String schemeUri = "http://id.loc.gov/authorities/names/person";
	protected final String subauthority = "person";
	
	//Followed by id
	protected final String lcnafTerm = "https://elr37-dev.library.cornell.edu/qa/show/linked_data/loc_direct/names/";
	
	public String getAuthority() {
		return authority;
	}
	
	public String getSubAuthority() {
		return subauthority;
	}
}
