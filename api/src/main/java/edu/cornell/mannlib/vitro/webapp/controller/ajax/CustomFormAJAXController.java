/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.controller.ajax;

import static edu.cornell.mannlib.vitro.webapp.modelaccess.ModelNames.USER_ACCOUNTS;
import static javax.servlet.http.HttpServletResponse.SC_NOT_FOUND;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.jena.ontology.OntModel;
import org.apache.jena.query.Query;
import org.apache.jena.rdf.model.Literal;
import org.apache.jena.rdf.model.Model;

import edu.cornell.mannlib.vitro.webapp.auth.permissions.SimplePermission;
import edu.cornell.mannlib.vitro.webapp.auth.requestedAction.AuthorizationRequest;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.controller.ajax.SparqlUtils.AjaxControllerException;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditN3GeneratorVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.SparqlEvaluateVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.ChildVClassesWithParent;
import edu.cornell.mannlib.vitro.webapp.modelaccess.ModelAccess;
import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

/**
 * Handle an AJAX request for a SPARQL query. On entry, the "query" parameter
 * contains the query string.
 * 
 * The result is delivered in JSON format.
 */
public class CustomFormAJAXController extends VitroAjaxController {
	private static final Log log = LogFactory
			.getLog(CustomFormAJAXController.class);

	public static final String CONFIG_PARAMETER = "configComponent";
	public static final String FIELD_NAME_PARAMETER = "fieldName";
	public static final String RESPONSE_MIME_TYPE = "application/javascript";
	public static final String EXISTING_VALUES_COMPONENT_PARAMETER="configComponentsExistingValues";
	public static final String URIS_IN_SCOPE_PARAMETER="urisInScope";
	public static final String LITERALS_IN_SCOPE_PARAMETER="literalsInScope";
	public static final String ACTION_PARAMETER = "action";

	@Override
	protected AuthorizationRequest requiredActions(VitroRequest vreq) {
		//TODO: Check which permission
		return SimplePermission.QUERY_FULL_MODEL.ACTION;
		
	}

	@Override
	protected void doRequest(VitroRequest vreq, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			
			String action = vreq.getParameter(ACTION_PARAMETER);
			if(StringUtils.isNotEmpty(action)) {
				if(isDropdownRequest(action)) {
					handleDropdownRequest(vreq, response);
				} else if(isExistingValuesRequest(action)) {
					handleExistingValuesRequest(vreq, response);
				}
			}
			
		
			
			
		} catch (Exception e) {
			log.error(e.getMessage());
			//response.sendError(e.getStatusCode());
		}
	}
	
	//Existing literal and URI values - using SPARQL
	private void handleExistingValuesRequest(VitroRequest vreq, HttpServletResponse response) {
		//Can we bundle all the existing values together
		String existingValues = vreq.getParameter(EXISTING_VALUES_COMPONENT_PARAMETER);
		//Parse as JSON Array
		JSONArray jsonArray = (JSONArray) JSONSerializer.toJSON(existingValues);
		int length = jsonArray.size();
		List<String> returnValues = new ArrayList<String>();
		//URIs in scope
		HashMap<String, List<String>> uriScope = getURIsInScope(vreq);
		//This will be empty for now - as it is in the 
		HashMap<String, List<Literal>> literalScope = getLiteralsInScope(vreq);
		int i;
		for(i = 0; i < length; i++) {
			JSONObject configComponent = jsonArray.getJSONObject(i);
			String sparqlQuery = configComponent.getString( "customform:queryForExistingValue");
			//How to execute the code
			//Check if URI or Literal
	        OntModel queryModel = ModelAccess.on(vreq).getOntModel();
	        SparqlEvaluateVTwo sparqlEvaluate = new SparqlEvaluateVTwo(queryModel);
	        //The query needs URIs substituted
	        EditN3GeneratorVTwo editN3Generator = new EditN3GeneratorVTwo();
	        if(isURIField(configComponent)) {
	            List<String> uriFromQuery = sparqlEvaluate.sparqlEvaluateForURIQuery(editN3Generator, uriScope, literalScope, sparqlQuery);
	            if(uriFromQuery != null && uriFromQuery.size() > 0) {
	            	returnValues = uriFromQuery;
	            }

	        }
	        else if(isLiteralField(configComponent)) {
	        	List<Literal> literalVars = sparqlEvaluate.sparqlEvaluateForLiteralQuery(editN3Generator, uriScope, literalScope, sparqlQuery);
	        	if(literalVars != null && literalVars.size() > 0) {
		        	for(Literal literal: literalVars) {
		        		returnValues.add(literal.getString());
		        	}
	        	}
	        }

		}
		//Output return values as json
		JSONArray jArray = new JSONArray();
		jArray.addAll(returnValues);
		writeOutput(jArray.toString(), response);
	}

	private HashMap<String, List<Literal>> getLiteralsInScope(VitroRequest vreq) {
		HashMap<String, List<Literal>> literalsInScope = new HashMap<String, List<Literal>>();
		String literals = vreq.getParameter(LITERALS_IN_SCOPE_PARAMETER);
		if(StringUtils.isNotEmpty(literals)) {
			//This is a stringified hashmap
			JSONObject literalsObj = (JSONObject) JSONSerializer.toJSON(literals);
			Set<String> keys = literalsObj.keySet();
			for(String key:keys) {
				//Don't know if this conversion will work
				List<Literal> ls = (List<Literal>)literalsObj.get(key);
				literalsInScope.put(key, ls);
			}
		}
		return literalsInScope;
	}

	private HashMap<String, List<String>> getURIsInScope(VitroRequest vreq) {
		
		HashMap<String, List<String>> urisInScope = new HashMap<String, List<String>>();
		String uris = vreq.getParameter(URIS_IN_SCOPE_PARAMETER);
		if(StringUtils.isNotEmpty(uris)) {
			//This is a stringified hashmap
			JSONObject urisObj = (JSONObject) JSONSerializer.toJSON(uris);
			Set<String> keys = urisObj.keySet();
			for(String key:keys) {
				//Don't know if this conversion will work
				List<String> urisArray = new ArrayList<String>();
				JSONArray jArray = urisObj.getJSONArray(key);
				int length = jArray.size();
				int l;
				for(l = 0; l < length; l++) {
					urisArray.add(jArray.getString(l));
				}
				urisInScope.put(key, urisArray);
			}
			
		}
		return urisInScope;
	}

	private boolean isDropdownRequest(String action) {
		return action.equals("dropdown");
	}
	
	private boolean isExistingValuesRequest(String action) {
		return action.equals("existingValues");
	}
	
	//TODO: Don't just put exception there but type
	private void handleDropdownRequest(VitroRequest vreq, HttpServletResponse response) throws Exception {
		//Get the object for config component, this is a stringifed representation of the JSON object
		String parameterValue = vreq.getParameter(CONFIG_PARAMETER);
		String fieldNameValue = vreq.getParameter(FIELD_NAME_PARAMETER);
		if(StringUtils.isNotEmpty(parameterValue)) {
			//create a json object from parameter value
			JSONObject json = (JSONObject) JSONSerializer.toJSON(parameterValue);				
			//Get type
			String outputJSON = generateDropDown(json, fieldNameValue, vreq);
			String output = outputJSON.toString();				
			writeOutput(output, response);
		}
	}

	private void writeOutput(String output, HttpServletResponse response) {
		try {		
			PrintWriter writer = response.getWriter();
	        response.setContentType("application/json");
	        writer.write(output);
	        writer.close(); 
        }
		catch(Exception ex) {
			log.error("Error occurred with writing output", ex);
		}
	}
	
	private String generateDropDown(JSONObject json, String fieldNameValue, VitroRequest vreq) {
		JSONArray types = json.getJSONArray("@type");
		JSON optionsAsJSON = null;
		//A switch statement would be better for readability - how would we do that?
		//NOT assuming multiple types, so just get rid of 
		//We don't need this type if it exists, this is a generic type
		types.remove("forms:FieldOptions");
		String JavaClassNamePrefix = "edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.";
		if(types.size() > 0) {
			String type = types.getString(0);
			String JAVAClassName = getJAVAClassName(type);
			//Get the JAVA Class name for this
			try {
			switch(JAVAClassName) {
				case "ChildVClassesWithParent":
					JSONObject classJSON = json.getJSONObject("customform:classUri");
					String classURI = classJSON.getString("@id");
					//Could use class for name, but why bother?
					ChildVClassesWithParent cvp = new ChildVClassesWithParent(classURI);
					//Get the options
					Map<String, String> options = cvp.getOptions(null, fieldNameValue, vreq.getWebappDaoFactory());
					optionsAsJSON = JSONSerializer.toJSON(options);
					
				break;
				case "":
				break;
				default:
			
			}
				
			} catch(Exception ex) {
				log.error("An error occurred in getting the FieldOptions class", ex);
			}
			
			
			
		}
		return (optionsAsJSON == null)? null: optionsAsJSON.toString();
	}

	private String getJAVAClassName(String type) {
		if(StringUtils.isNotEmpty(type)) {
			if(type.startsWith("forms:")) {
				return type.substring("forms:".length());
			}
		}
		return null;
	}
	
	private boolean isURIField(JSONObject configComponent) {
		JSONArray types = configComponent.getJSONArray("@type");
		
		return types.contains("forms:UriField");
		
	}
	
	private boolean isLiteralField(JSONObject configComponent) {
		JSONArray types = configComponent.getJSONArray("@type");
		
		return types.contains("forms:LiteralField");
	}


	
}
