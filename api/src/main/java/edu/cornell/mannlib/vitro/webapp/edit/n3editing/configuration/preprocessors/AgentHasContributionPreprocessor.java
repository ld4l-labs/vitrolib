/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.preprocessors;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.hp.hpl.jena.query.Query;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.QueryFactory;
import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.QuerySolutionMap;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.query.Syntax;
import com.hp.hpl.jena.rdf.model.Literal;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.Property;
import com.hp.hpl.jena.rdf.model.RDFNode;
import com.hp.hpl.jena.rdf.model.ResIterator;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.ResourceFactory;
import com.hp.hpl.jena.rdf.model.Statement;
import com.hp.hpl.jena.shared.Lock;
import com.hp.hpl.jena.vocabulary.RDF;
import com.hp.hpl.jena.vocabulary.RDFS;

import edu.cornell.mannlib.vitro.webapp.dao.VitroVocabulary;

public class AgentHasContributionPreprocessor implements ModelChangePreprocessor {

    private static final String FOAF = "http://xmlns.com/foaf/0.1/";
	private Log log = LogFactory.getLog(AgentHasContributionPreprocessor.class);
    final static String ld4l = "http://bib.ld4l.org/ontology/";
    final static String rdfs = "http://www.w3.org/2000/01/rdf-schema#";
    final static String foaf = "http://xmlns.com/foaf/0.1/";
    final static String rdf = "";
	@Override
	public void preprocess(Model retractionsModel, Model additionsModel,
			HttpServletRequest request) {
		Model retractionsToRemove = getRetractionsToRemove(retractionsModel, additionsModel);
		retractionsModel.remove(retractionsToRemove);
	}
	
	//When editing and changing which agent is selected as contributor, ensure that the label, type, foaf:name properties
	//do not get deleted
	private Model getRetractionsToRemove(Model retractionsModel, Model additionsModel) {
		// TODO Auto-generated method stub
		Model retractionsToRemove = ModelFactory.createDefaultModel();
		
		if(!retractionsModel.isEmpty()) {
			HashSet<String> additionsWorkURIs = new HashSet<String>();
			HashSet<String> preserveRetractionsWorkURIs = new HashSet<String>();
			String queryStr = getSparqlQuery();
			Query query = null;
	        QueryExecution qe = null;

	        additionsModel.getLock().enterCriticalSection(Lock.READ);
	        try {
	            query = QueryFactory.create(queryStr);
	            qe = QueryExecutionFactory.create(
	                    query, additionsModel);
	            ResultSet res = qe.execSelect();
	            
	            while( res.hasNext() ){
	            	QuerySolution qs = res.nextSolution();
	            	additionsWorkURIs.add(qs.getResource("work").getURI());
	            }
	        } catch(Exception ex) {
	        	log.error("Exception occurred in querying additions model for agent ", ex);
	        }
	        
	        retractionsModel.getLock().enterCriticalSection(Lock.READ);
	        try {
	            query = QueryFactory.create(queryStr);
	            qe = QueryExecutionFactory.create(
	                    query, retractionsModel);
	            ResultSet res = qe.execSelect();
	            
	            while( res.hasNext() ){
	            	QuerySolution qs = res.nextSolution();
	            	String workURI = qs.getResource("work").getURI();
	            	//if this uri is not in the additoins, then the agent is being removed from the property and we want to ensure
	            	//that type, rdfs:label, and foaf:name are not added to the retractions
	            	if(!additionsWorkURIs.contains(workURI)) {
	            		preserveRetractionsWorkURIs.add(workURI);
	            	}
	            }
	        } catch(Exception ex) {
	        	log.error("Exception occurred in querying additions model for agent ", ex);
	        }
	        
	        //Now, with the agent uris to be preserved
	        for(String uri: preserveRetractionsWorkURIs) {
	        	Resource workURI = ResourceFactory.createResource(uri);
	        	Property foafNameProperty = ResourceFactory.createProperty(foaf + "name");
	        	retractionsToRemove.add(retractionsModel.listStatements(workURI, RDF.type, (RDFNode) null));
	        	retractionsToRemove.add(retractionsModel.listStatements(workURI, foafNameProperty, (RDFNode) null));
	        	retractionsToRemove.add(retractionsModel.listStatements(workURI, RDFS.label, (RDFNode) null));

	        }
		}
		
		return retractionsToRemove;
	}

	private String getSparqlQuery() {
		String queryStr = "SELECT DISTINCT ?work WHERE {?work <" + ld4l + "hasContribution> ?contribution ." + 
				"}";
		return queryStr;
	}
	
	

}
