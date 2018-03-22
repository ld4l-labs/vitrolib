/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.servlet.setup;

import static edu.cornell.mannlib.vitro.webapp.modelaccess.ModelNames.DISPLAY;
import static edu.cornell.mannlib.vitro.webapp.modelaccess.ModelNames.DISPLAY_DISPLAY;
import static edu.cornell.mannlib.vitro.webapp.modelaccess.ModelNames.DISPLAY_TBOX;
import static edu.cornell.mannlib.vitro.webapp.modelaccess.ModelNames.USER_ACCOUNTS;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.jena.ontology.OntModel;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.rdf.model.ResourceFactory;
import org.apache.jena.vocabulary.RDF;

import edu.cornell.mannlib.vitro.webapp.modelaccess.ModelAccess;
import edu.cornell.mannlib.vitro.webapp.startup.StartupStatus;

/**
 * Set up the models that use the CONFIGURATION RDFService. They are all mapped
 * to memory-based models.
 */
public class NotificationSetup implements ServletContextListener {
	Timer timer;
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		ServletContext ctx = sce.getServletContext();
		StartupStatus ss = StartupStatus.getBean(ctx);
		System.out.println("**NOTIFICATION SETUP");
		try {
			int seconds = 10;
			 timer = new Timer();
			 Date d = new Date();
			 d.setTime(d.getTime() + 10000);
		     timer.scheduleAtFixedRate(new NotificationTask(), d, seconds*1000);
			
		} catch (Exception e) {
			ss.fatal(this, e.getMessage(), e.getCause());
		}
	}
	

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		// Nothing to tear down.
		timer.cancel();
	}
	
	 class NotificationTask extends TimerTask {
	        public void run() {
	            System.out.println("NOTIFY");
	            //readInFile();
	            readInbox();
	            //testPostToInbox();
	            timer.cancel(); //Terminate the timer thread
	            
	        }
	        
	    	private void testPostToInbox() {
	    		try {
	    		String url="http://url.com";
	    		URL object=new URL("https://linkedresearch.org/inbox/ld4l/");

	    		HttpURLConnection con = (HttpURLConnection) object.openConnection();
	    		con.setDoOutput(true);
	    		con.setDoInput(true);
	    		con.setRequestProperty("Content-Type", "application/ld+json");
	    		con.setRequestProperty("Accept", "application/ld+json");
	    		con.setRequestMethod("POST");
	    		
	    		
	    		Model m = ModelFactory.createDefaultModel();
	    		m.add(ResourceFactory.createResource("http://example.org"), RDF.type, ResourceFactory.createResource("http://ldnexampletest.org"));
	    		StringWriter s = new StringWriter();
	    		m.write(s, "JSON-LD");
	    		OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
	    		wr.write(s.toString());
	    		wr.flush();
	    		wr.close();
	    		  BufferedReader in = new BufferedReader(new InputStreamReader(
	    					con.getInputStream()));
	    			String inputLine;
	    			StringBuffer response = new StringBuffer();

	    			while ((inputLine = in.readLine()) != null) {
	    				response.append(inputLine);
	    			}
	    			in.close();

	    			// print result
	    			System.out.println(response.toString());
	    		
	    		
	    		con.disconnect();
	    		} catch(Exception ex) {
	    			System.out.println("Error occurred");
	    		}
	    	
	    	
				
			}

			private void readInFile() {
	    		String fileName = "C:/Users/hjk54/Documents/Ld4L/NotificationTest/NotificationTest.txt";
	    		
	    		try {      
	    			InputStream is = new FileInputStream(fileName);
	    			BufferedReader buf = new BufferedReader(new InputStreamReader(is));
	    			String line = buf.readLine();
	    			StringBuilder sb = new StringBuilder();
	    			        
	    			while(line != null){
	    			   sb.append(line).append("\n");
	    			   line = buf.readLine();
	    			}
	    			        
	    			String fileAsString = sb.toString();
	    			System.out.println(fileAsString);
	    		} catch(Exception ex) {
	    			System.out.println("Print out error");
	    		}


	    	}
	    }
	 
	 	//Read in notification
	 private void readInbox() {
		 try {
			 System.out.println("Read Inbox");
		 String urlToRead = "https://linkedresearch.org/inbox/ld4l/";
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
	      System.out.println(result.toString());
		 } catch(Exception ex) {
			 System.out.println("Error occurred");
			 ex.printStackTrace();
		 }
	 }

}
