/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.controller.ajax;

import static edu.cornell.mannlib.vitro.webapp.modelaccess.ModelNames.USER_ACCOUNTS;
import static javax.servlet.http.HttpServletResponse.SC_NOT_FOUND;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Constructor;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.apache.jena.query.Query;
import org.apache.jena.rdf.model.Model;

import edu.cornell.mannlib.vitro.webapp.auth.permissions.SimplePermission;
import edu.cornell.mannlib.vitro.webapp.auth.requestedAction.AuthorizationRequest;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.controller.ajax.SparqlUtils.AjaxControllerException;
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

	

	@Override
	protected AuthorizationRequest requiredActions(VitroRequest vreq) {
		//TODO: Check which permission
		return SimplePermission.QUERY_FULL_MODEL.ACTION;
		
	}

	@Override
	protected void doRequest(VitroRequest vreq, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			
			//Get the object for config component, this is a stringifed representation of the JSON object
			String parameterValue = vreq.getParameter(CONFIG_PARAMETER);
			String fieldNameValue = vreq.getParameter(FIELD_NAME_PARAMETER);
			if(StringUtils.isNotEmpty(parameterValue)) {
				//create a json object from parameter value
				JSONObject json = (JSONObject) JSONSerializer.toJSON(parameterValue);				
				//Get type
				String outputJSON = generateDropDown(json, fieldNameValue, vreq);
				String output = outputJSON.toString();				
				PrintWriter writer = response.getWriter();
	            response.setContentType("application/json");
	            writer.write(output);
	            writer.close();
			}
			
			
		} catch (Exception e) {
			log.error(e.getMessage());
			//response.sendError(e.getStatusCode());
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
					JSONObject classJSON = json.getJSONObject("http://vitro.mannlib.cornell.edu/ns/vitro/CustomFormConfiguration#classUri");
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


	
}
