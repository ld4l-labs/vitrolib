/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.utils.ConceptSearchService;

import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import edu.cornell.mannlib.semservices.bo.Concept;
import edu.cornell.mannlib.semservices.service.ExternalConceptService;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
/**
 * Utilities for search    
 */
public class ConceptSearchServiceUtils {
    private static final Log log = LogFactory.getLog(ConceptSearchServiceUtils.class);
    //Get the appropriate search service class
    //TODO: Change this so retrieved from the system instead using a query
    private static final String UMLSVocabSource = "http://link.informatics.stonybrook.edu/umls";
    private static final String AgrovocVocabSource = "http://aims.fao.org/aos/agrovoc/agrovocScheme";
    private static final String GemetVocabSource = "http://www.eionet.europa.eu/gemet/gemetThesaurus";
    private static final String ISNIVocabSource = "http://isni.oclc.nl/sru";
    //QA sources
    private static final String LCSHVocabSource = "http://id.loc.gov/authorities/subjects";
    private static final String LCSHQAVocabSource = "http://id.loc.gov/authorities/subjects";
    private static final String LCGFVocabSource = "http://id.loc.gov/authorities/genreForms";
    private static final String LCNAFVocabSource = "http://id.loc.gov/authorities/names";
    private static final String LCNAFPersonVocabSource = "http://id.loc.gov/authorities/names/person";
    private static final String LCNAFOrganizationVocabSource = "http://id.loc.gov/authorities/names/organization";
    private static final String GeonamesVocabSource = "http://geonames.org";
    private static final String FASTVocabSource = "http://id.worldcat.org/fast";
    private static final String FASTEventVocabSource = "http://id.worldcat.org/fast/event_name";


    //Get the class that corresponds to the appropriate search
	public static String getConceptSearchServiceClassName(String searchServiceName) {
		System.out.println("VITROLIB Get Concept Search Service Class Name " + searchServiceName);
		HashMap<String, String> map = getMapping();
		if(map.containsKey(searchServiceName)) {
			return map.get(searchServiceName);
		}
		return null;
	}
	
	//Get the URLS for the different services
	//URL to label
	public static HashMap<String, VocabSourceDescription> getVocabSources() {
		HashMap<String, VocabSourceDescription> map = new HashMap<String, VocabSourceDescription>();
    	map.put(UMLSVocabSource, new VocabSourceDescription("UMLS", UMLSVocabSource, "http://www.nlm.nih.gov/research/umls/", "Unified Medical Language System"));
    	//Commenting out agrovoc for now until implementation is updated
    	map.put(AgrovocVocabSource, new VocabSourceDescription("AGROVOC", AgrovocVocabSource, "http://www.fao.org/agrovoc/", "Agricultural Vocabulary"));
    	map.put(GemetVocabSource, new VocabSourceDescription("GEMET", GemetVocabSource, "http://www.eionet.europa.eu/gemet", "GEneral Multilingual Environmental Thesaurus"));
    	map.put(ISNIVocabSource, new VocabSourceDescription("ISNI", ISNIVocabSource, "http://isni.oclc.nl/sru/", "International Standard Name Identifier"));
    	//QA sources
    	map.put(LCNAFVocabSource, new VocabSourceDescription("LCNAF", LCNAFVocabSource, "http://id.loc.gov/authorities/names/", "Library of Congress Names Authorities"));
    	map.put(LCNAFPersonVocabSource, new VocabSourceDescription("LCNAF Person", LCNAFPersonVocabSource, "http://id.loc.gov/authorities/names/person", "Library of Congress Names Authorities Persons"));
    	map.put(LCNAFOrganizationVocabSource, new VocabSourceDescription("LCNAF Organization", LCNAFOrganizationVocabSource, "http://id.loc.gov/authorities/names/organization", "Library of Congress Names Authorities Organizations"));
    	map.put(LCSHQAVocabSource, new VocabSourceDescription("LCSH", LCSHQAVocabSource, "http://id.loc.gov/authorities/subjects/", "Library of Congress Subject Headings"));
    	map.put(LCGFVocabSource, new VocabSourceDescription("LCGF", LCGFVocabSource, "http://id.loc.gov/authorities/genreForms/", "Library of Congress Genre Forms"));
    	map.put(GeonamesVocabSource, new VocabSourceDescription("GeoNames", GeonamesVocabSource, "http://geonames.org", "GeoNames"));
    	map.put(FASTVocabSource, new VocabSourceDescription("FAST", FASTVocabSource, "http://id.worldcat.org/fast", "FAST"));
    	map.put(FASTEventVocabSource, new VocabSourceDescription("FAST Event", FASTEventVocabSource, "http://id.worldcat.org/fast/event", "FAST Events"));

    	return map;
	}
	
	//Get additional vocab source info
	
    
    //Get the hashmap mapping service name to Service class
    private static HashMap<String, String> getMapping() {
    	HashMap<String, String> map = new HashMap<String, String>();
    	map.put(UMLSVocabSource, "edu.cornell.mannlib.semservices.service.impl.UMLSService");
    	map.put(AgrovocVocabSource, "edu.cornell.mannlib.semservices.service.impl.AgrovocService");
    	map.put(GemetVocabSource, "edu.cornell.mannlib.semservices.service.impl.GemetService");
    	map.put(ISNIVocabSource, "edu.cornell.mannlib.semservices.service.impl.ISNIImpl");
    	//QA sources
    	map.put(LCNAFVocabSource, "edu.cornell.mannlib.semservices.service.impl.LCNAFImpl");
    	map.put(LCNAFPersonVocabSource, "edu.cornell.mannlib.semservices.service.impl.LCNAFPersonImpl");
    	map.put(LCNAFOrganizationVocabSource, "edu.cornell.mannlib.semservices.service.impl.LCNAFOrganizationImpl");
    	map.put(LCSHQAVocabSource, "edu.cornell.mannlib.semservices.service.impl.LCSHQAImpl");
    	map.put(LCGFVocabSource, "edu.cornell.mannlib.semservices.service.impl.LCGFImpl");
    	map.put(GeonamesVocabSource, "edu.cornell.mannlib.semservices.service.impl.GeonamesImpl");
    	map.put(FASTVocabSource, "edu.cornell.mannlib.semservices.service.impl.FASTImpl");
    	map.put(FASTEventVocabSource, "edu.cornell.mannlib.semservices.service.impl.FASTEventImpl");

    	return map;
    }
    
    public static List<Concept> getSearchResults(ServletContext context, VitroRequest vreq) throws Exception {
    	String searchServiceName = getSearchServiceUri(vreq);
    	String searchServiceClassName = getConceptSearchServiceClassName(searchServiceName);
    
    	ExternalConceptService conceptServiceClass = null;
	
	    Object object = null;
	    try {
	        Class<?> classDefinition = Class.forName(searchServiceClassName);
	        object = classDefinition.newInstance();
	        conceptServiceClass = (ExternalConceptService) object;
	    } catch (InstantiationException e) {
	        System.out.println(e);
	    } catch (IllegalAccessException e) {
	        System.out.println(e);
	    } catch (ClassNotFoundException e) {
	        System.out.println(e);
	    }    	
    
	    if(conceptServiceClass == null){
	    	log.error("could not find Concept Search Class for " + searchServiceName);
	    	return null;
	    } 
	    
	    //Get search
	    String searchTerm = getSearchTerm(vreq);
	    List<Concept> conceptResults =  conceptServiceClass.getConcepts(searchTerm);
	    return conceptResults;
    }


	private static String getSearchServiceUri(VitroRequest vreq) {
		return vreq.getParameter("source");
	}

	private static String getSearchTerm(VitroRequest vreq) {
		return vreq.getParameter("searchTerm");
	}
	

}

