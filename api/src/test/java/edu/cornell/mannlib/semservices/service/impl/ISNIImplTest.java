package edu.cornell.mannlib.semservices.service.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.ibm.icu.impl.Assert;

import edu.cornell.mannlib.semservices.bo.Concept;
import edu.cornell.mannlib.semservices.service.ExternalConceptService;

/**
 * Not really a unit test, this class exercises the code that accesses the external ISNI API in
 * order to look at the returned data outside of the web application.
 * 
 * @author dan179
 */
public class ISNIImplTest {
	
	private ExternalConceptService service;
	
	private final Log logger = LogFactory.getLog(getClass());

    public ISNIImplTest() {
    	service = new ISNIImpl();
    }

	public void testGetConcepts() {
		String term = "allen, woody";// "maloy, rebecca"; Keeshan, Robert; allen, woody
		try {
			List<Concept> concepts = service.getConcepts(term);
			for (Concept c : concepts) {
				logger.warn("Concept -- URI: " + c.getUri() + ", label: " + c.getLabel());
			}
		} catch (Exception e) {
			Assert.fail(e);
		}
	}
	
	public static void main(String[] args) {
		ISNIImplTest test = new ISNIImplTest();
		test.testGetConcepts();
	}

}
