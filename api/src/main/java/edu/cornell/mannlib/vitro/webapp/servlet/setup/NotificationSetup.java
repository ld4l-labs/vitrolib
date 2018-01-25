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
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.jena.ontology.OntModel;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;

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
	}
	
	 class NotificationTask extends TimerTask {
	        public void run() {
	            System.out.println("NOTIFY");
	            readInFile();
	            //timer.cancel(); //Terminate the timer thread
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

}
