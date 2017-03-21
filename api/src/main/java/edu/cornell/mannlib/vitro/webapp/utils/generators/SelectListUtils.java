/* $This file is distributed under the terms of the license in /doc/license.txt$ */
/*
 * These methods can be used by an AJAX servlet which is used to retrieve the drop-down based on 
 * the type of field options specified within the JSON config file for a custom form framework. 
 */
package edu.cornell.mannlib.vitro.webapp.utils.generators;

import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import edu.cornell.mannlib.vitro.webapp.beans.Individual;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.dao.WebappDaoFactory;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.SelectListGeneratorVTwo;
import edu.cornell.mannlib.vitro.webapp.utils.FrontEndEditingUtils;
import edu.cornell.mannlib.vitro.webapp.utils.FrontEndEditingUtils.EditMode;

public class SelectListUtils {
	private static Log log = LogFactory.getLog(SelectListUtils.class);
	
	//Get options using the field name
	public static Map<String,String> getOptions(
            String fieldName, 
            WebappDaoFactory wDaoFact){
		HashMap<String, String> fieldOptions = new HashMap<String, String>();
		return fieldOptions;
	}
	
	 public static Map<String,String> getSortedMap(Map<String,String> hmap, 
	            Comparator<String[]> comparator, VitroRequest vreq){
		 return SelectListGeneratorVTwo.getSortedMap(hmap, comparator, vreq);
  
}
}
