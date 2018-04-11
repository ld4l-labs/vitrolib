/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.servlet; 

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import edu.cornell.mannlib.semservices.bo.Concept;
import edu.cornell.mannlib.semservices.bo.ConceptInfo;
import edu.cornell.mannlib.semservices.bo.SemanticServicesError;
import edu.cornell.mannlib.vitro.webapp.controller.VitroHttpServlet;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.utils.ConceptSearchService.ConceptSearchServiceUtils;

public class ReadNotificationServlet extends VitroHttpServlet {
    
    private static final long serialVersionUID = 1L;
    private static final Log log = LogFactory.getLog(ReadNotificationServlet.class);
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doGet(req, resp);
        VitroRequest vreq = new VitroRequest(req);

        try{
        	ServletContext ctx = vreq.getSession().getServletContext();
        
        	
        	String json = readInbox();
        	ObjectNode jsonNode = parseAndRead(json);
        	String jsonOutput = jsonNode.toString();
        	
        	//json = StringUtils.replaceChars(json, "\r\t\n", "");
            
        	PrintWriter writer = resp.getWriter();
            resp.setContentType("application/json");
            writer.write(jsonOutput);
            writer.close();
        	
        }catch(Exception ex){
            log.warn(ex,ex);            
        }        
    }
    
    private ObjectNode parseAndRead(String json) {
    	ObjectMapper objectMapper = new ObjectMapper();

    	ObjectNode returnNode = objectMapper.createObjectNode();
    	JsonNode jsonNode = null;
    	try {
    		jsonNode = objectMapper.readTree(json);
    		if(jsonNode.isArray()) {
    			//Get first element
    			JsonNode jNode = jsonNode.get(0);
    			String containsProperty = "http://www.w3.org/ns/ldp#contains";
    			if(jNode.has(containsProperty)) {
    				JsonNode containsList = jNode.get(containsProperty);
    				if(containsList.isArray()) {
    					for(JsonNode c: containsList) {
    						String id = c.path("@id").asText();
    						String notificationDetails = readFromInbox(id);
    						JsonNode notificationNode = objectMapper.readTree(notificationDetails);
    						returnNode.set(id, notificationNode);
    					}
    				}
    			}
    		}
    			
    	} catch(Exception ex) {
    		System.out.println("Error occurred in parsing json");
    		ex.printStackTrace();
    	}
    	return returnNode;
    	
    }
    
    private String readInbox() {
		 String urlToRead = "https://linkedresearch.org/inbox/ld4l/";

    	String resultString = readFromInbox(urlToRead);
		
		 return resultString;
	 }
    
    
    private String readFromInbox(String urlToRead) {
    	String resultString = "";
		 try {
		  StringBuilder result = new StringBuilder();
	      URL url = new URL(urlToRead);
	      HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	      conn.setRequestMethod("GET");
	      conn.setRequestProperty("Accept", "application/ld+json");
	      //conn.setRequestProperty("Accept", "text/turtle");
	      BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	      String line;
	      while ((line = rd.readLine()) != null) {
	         result.append(line);
	      }
	      rd.close();
	      resultString = result.toString();
		 } catch(Exception ex) {
			 System.out.println("Error occurred");
			 ex.printStackTrace();
		 }
		 return resultString;
    }
    
   


}