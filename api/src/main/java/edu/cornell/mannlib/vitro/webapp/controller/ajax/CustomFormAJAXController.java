/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.controller.ajax;

import static edu.cornell.mannlib.vitro.webapp.modelaccess.ModelNames.USER_ACCOUNTS;
import static javax.servlet.http.HttpServletResponse.SC_NOT_FOUND;

import java.io.IOException;

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
import edu.cornell.mannlib.vitro.webapp.modelaccess.ModelAccess;

/**
 * Handle an AJAX request for a SPARQL query. On entry, the "query" parameter
 * contains the query string.
 * 
 * The result is delivered in JSON format.
 */
public class CustomFormAJAXController extends VitroAjaxController {
	private static final Log log = LogFactory
			.getLog(CustomFormAJAXController.class);

	public static final String PARAMETER_QUERY = "configComponent";
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
			
			//Get the object for config component
			String parameterValue = vreq.getParameter(PARAMETER_QUERY);
			if(StringUtils.isNotEmpty(parameterValue)) {
				//create a json object from parameter value
			}
			
			
		} catch (Exception e) {
			log.error(e.getMessage());
			//response.sendError(e.getStatusCode());
		}
	}


	
}
