/* $This file is distributed under the terms of the license in /doc/license.txt$ */
package edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields;

import java.text.Collator;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

//import com.hp.hpl.jena.vocabulary.OWL;

import edu.cornell.mannlib.vitro.webapp.beans.VClass;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.dao.VClassDao;
import edu.cornell.mannlib.vitro.webapp.dao.WebappDaoFactory;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;

public class ChildVClassesWithParentCustomLabels extends ChildVClassesWithParent   {

    private static final String LEFT_BLANK = "";
    private Collator collator = null;
    public ChildVClassesWithParentCustomLabels(String classUri,  Collator collator) throws Exception {
        super(classUri);
        this.collator = collator;
    }
   
    public ChildVClassesWithParentCustomLabels setDefaultOption(String label){
        this.defaultOptionLabel = label;
        return this;
    }
    
   
    public Comparator<String[]> getCustomComparator() {
    	return new SuperClassAndChildrenComparator(collator, this.classUri);
    }
    
    //Sorts by the value of the 2nd element in each of the arrays except in the case of the super class
    //which appears first
    private static class SuperClassAndChildrenComparator implements Comparator<String[]> {
        
        private Collator collator;
        private String classURI;
        public SuperClassAndChildrenComparator(Collator collator, String classURI) {
            this.collator = collator;
            this.classURI = classURI;
        }
        public int compare (String[] s1, String[] s2) {
            if (s2 == null) {
                return 1;
            } else if (s1 == null) {
                return -1;
            } else {
            	if ("".equals(s1[0])) {
            		return -1;
            	} else if ("".equals(s2[0])) {
            		return 1;
            	}
                if (s2[1]==null) {
                    return 1;
                } else if (s1[1] == null){
                    return -1;
                } else {
                	//if s1[1] == the class uri, then always make this the first item
                	if(s1[1].equals(this.classURI)) 
                		return -1;
                    return collator.compare(s1[1],s2[1]);
                }
            }
        }
    }   

}
