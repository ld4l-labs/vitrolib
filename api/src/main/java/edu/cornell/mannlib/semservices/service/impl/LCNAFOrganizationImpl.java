/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.semservices.service.impl;

public class LCNAFOrganizationImpl extends LCNAFImpl {

	protected final String schemeUri = "http://id.loc.gov/authorities/names/organization";
	protected final String subauthority = "organization";
	public String getAuthority() {
		return authority;
	}
	
	public String getSubAuthority() {
		return subauthority;
	}


}
