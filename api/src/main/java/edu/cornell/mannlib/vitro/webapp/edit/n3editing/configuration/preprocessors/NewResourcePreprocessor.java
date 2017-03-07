/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.preprocessors;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.BaseEditSubmissionPreprocessorVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.MultiValueEditSubmission;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.EditConfigurationConstants;
public class NewResourcePreprocessor extends
		BaseEditSubmissionPreprocessorVTwo {

	protected static final Log log = LogFactory
			.getLog(NewResourcePreprocessor.class.getName());

	
	private static MultiValueEditSubmission submission = null;
	private static EditConfigurationVTwo editConfiguration = null;
	private static Map<String, List<String>> urisFromForm = null;
	private static List<String> forceNewURIsList = null;
	public NewResourcePreprocessor(EditConfigurationVTwo editConfig, List<String> forceNewURIs) {
		super(editConfig);
		editConfiguration = editConfig;
		forceNewURIsList = forceNewURIs;
	}

	public void preprocess(MultiValueEditSubmission inputSubmission, VitroRequest vreq) {
		submission = inputSubmission;
		// Get the input elements for concept node and concept label as well
		// as vocab uri (which is based on thge
		// For query parameters, check whether CUI
		copySubmissionValues();
		//If items in list are empty and this is an edit, then replace with new uri sentinel
		replaceNewURIs();

	}
	
	//Since we will change the uris and literals from form, we should make copies
	//of the original values and store them, this will also make iterations
	//and updates to the submission independent from accessing the values
	private void copySubmissionValues() {
		
		urisFromForm = copyMap(submission.getUrisFromForm());
	}

	private Map<String, List<String>> copyMap(
			Map<String, List<String>> originalMap) {
		Map<String, List<String>> copyMap = new HashMap<String, List<String>>();
		copyMap.putAll(originalMap);
		return copyMap;
	}
	
	private void replaceNewURIs() {
		 if(editConfiguration.isUpdate()) {
			 List<String> urisOnForm = editConfiguration.getUrisOnform();
			 HashSet<String> configUrisOnForm = new HashSet<String>();
			 configUrisOnForm.addAll(urisOnForm);
			 for(String varName: forceNewURIsList) {
				 //No value submitted for uri, so new resource needs to be created
				 //and old one should not be used
				 if(configUrisOnForm.contains(varName) &&
						 !urisFromForm.containsKey(varName)) {
					 submission.addUriToForm(editConfiguration, varName, new String[]{EditConfigurationConstants.NEW_URI_SENTINEL});
				 }
			}
		 }
	}

	

	





	
	


}
