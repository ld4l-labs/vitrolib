/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.preprocessors;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.apache.jena.query.Query;
import org.apache.jena.query.QueryExecution;
import org.apache.jena.query.QueryExecutionFactory;
import org.apache.jena.query.QueryFactory;
import org.apache.jena.query.QuerySolution;
import org.apache.jena.query.QuerySolutionMap;
import org.apache.jena.query.ResultSet;
import org.apache.jena.query.Syntax;
import org.apache.jena.rdf.model.Literal;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.rdf.model.Property;
import org.apache.jena.rdf.model.RDFNode;
import org.apache.jena.rdf.model.ResIterator;
import org.apache.jena.rdf.model.Resource;
import org.apache.jena.rdf.model.ResourceFactory;
import org.apache.jena.rdf.model.Statement;
import org.apache.jena.shared.Lock;
import org.apache.jena.vocabulary.RDF;
import org.apache.jena.vocabulary.RDFS;

import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.dao.VitroVocabulary;

public class AuthorityHackPreprocessor implements ModelChangePreprocessor {

	private Log log = LogFactory.getLog(AuthorityHackPreprocessor.class);
	private static String defaultNamespace = null;
	
	public AuthorityHackPreprocessor() {
	}

	@Override
	public void preprocess(Model retractionsModel, Model additionsModel,
			HttpServletRequest request) {
		//remove label/type declarations for specific namespaces 
		VitroRequest vreq = new VitroRequest(request);
		this.defaultNamespace = vreq.getWebappDaoFactory().getDefaultNamespace();
		
		removeExternalProperties(retractionsModel); 
	}
	
	private void removeExternalProperties(Model retractionsModel) {
		// TODO Auto-generated method stub
		Model removeFromRetractions = ModelFactory.createDefaultModel();
		ResIterator ri = retractionsModel.listSubjects();
		while(ri.hasNext()) {
			Resource subject = ri.nextResource();
			if(isExternalNamespace(subject)) {
				removeFromRetractions.add(retractionsModel.listStatements(subject, RDF.type, (RDFNode) null));
				removeFromRetractions.add(retractionsModel.listStatements(subject, RDFS.label, (RDFNode) null));
			}
		}
		
		if(removeFromRetractions.size() > 0) {
			retractionsModel.remove(removeFromRetractions);
		}
		
	}

	private boolean isExternalNamespace(Resource subject) {
		//Hardcoding here but definitely better way to get namespace?
		String externalNamespace = subject.getNameSpace();
		return !externalNamespace.equals(defaultNamespace);
	}



}
