package edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.generators;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import  org.apache.jena.vocabulary.XSD;

import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.dao.VitroVocabulary;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.ChildVClassesWithParent;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.ChildVClassesWithParentCustomLabels;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.FieldVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.preprocessors.NewResourcePreprocessor;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.preprocessors.WorkHasContributionPreprocessor;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.validators.AntiXssValidation;
import edu.cornell.mannlib.vitro.webapp.utils.FrontEndEditingUtils.EditMode;
import edu.cornell.mannlib.vitro.webapp.utils.generators.EditModeUtils;

/** DRAFT VERSION - DO NOT USE! **/

public class WorkHasContributorGenerator extends BaseEditConfigurationGenerator implements EditConfigurationGenerator {

    private Log log = LogFactory.getLog(WorkHasContributorGenerator.class);
    private static String template = "workHasContributor.ftl";
    final static String ld4l = "http://bib.ld4l.org/ontology/";
    final static String madsrdf = "http://www.loc.gov/mads/rdf/v1#";
    final static String prov = "http://www.w3.org/ns/prov#";
    final static String rdfs = "http://www.w3.org/2000/01/rdf-schema#";
    final static String foaf = "http://xmlns.com/foaf/0.1/";
    final static String contributionClass = ld4l + "Contribution";
    @Override
    public EditConfigurationVTwo getEditConfiguration(VitroRequest vreq,
            HttpSession session) throws Exception {
            
        EditConfigurationVTwo conf = new EditConfigurationVTwo();
                
        initBasics(conf, vreq);
        initPropertyParameters(vreq, session, conf);
        initObjectPropForm(conf, vreq);               
        
        conf.setTemplate(template);
        
        conf.setVarNameForSubject("work");
        conf.setVarNameForPredicate("predicate");
        conf.setVarNameForObject("contribution");
                
        conf.setN3Required( Arrays.asList( n3ForContribution, n3ForWorkToContribution, n3ForContributionToAgent ) );
        conf.setN3Optional(Arrays.asList(  n3ForNewAgent) );
        
        conf.addNewResource("contribution", DEFAULT_NS_FOR_NEW_RESOURCE);
        conf.addNewResource("work",DEFAULT_NS_FOR_NEW_RESOURCE);
        conf.addNewResource("agent", DEFAULT_NS_FOR_NEW_RESOURCE);

        // uris in scope: none   
        // literals in scope: none
        
        // Should include contribution type, but ignoring for now
        //There could be an existing WORK URI but would need to create new contribution URI for that
        //
        conf.setUrisOnform( Arrays.asList( "work", "contributionType", "contribution", "agentType", "agent"));  
        conf.setLiteralsOnForm( Arrays.asList("contributionLabel",  "agentName"));
        //contribution available as object uri
        conf.addSparqlForExistingLiteral("contributionLabel", contributionLabelQuery);
        conf.addSparqlForExistingUris("contributionType", existingContributionTypeQuery);
        conf.addSparqlForExistingUris("agent", existingAgentQuery);
        conf.addSparqlForExistingUris("agentType", existingAgentTypeQuery);
        conf.addSparqlForExistingLiteral("agentName", existingAgentNameQuery);
        
        //conf.addSparqlForExistingUris("contributorRoleType", existingContributorRoleTypeQuery);

       //I don't think we need an existing title, do we ?
                
        //Add fields
       
        //Existing contribution relationship will put uri within the field
        conf.addField(new FieldVTwo().setName("contribution"));
        conf.addField( new FieldVTwo().
                setName("contributionLabel").
                setRangeDatatypeUri(XSD.xstring.toString() )); //This should be a hidden field, based on type selected from drop-down
        
        conf.addField( new FieldVTwo().                        
                setName("contributionType").
                setValidators( list("nonempty") ).
                setOptions( new ChildVClassesWithParentCustomLabels(contributionClass, vreq.getCollator()))
                );
        //Agent URI
        conf.addField( new FieldVTwo().                        
                setName("agent").
                setValidators( list("nonempty") )
                );
        //Agent name
        conf.addField( new FieldVTwo().                        
                setName("agentName")
                );
        //Agent type
        conf.addField( new FieldVTwo().                        
                setName("agentType").
                setOptions(new ChildVClassesWithParent(foaf + "Agent"))
                );
        // Future: select field for contribution type

        // Add validator
        conf.addValidator(new AntiXssValidation());
        
        conf.addModelChangePreprocessor(new WorkHasContributionPreprocessor());
        //Force these URIs to be minted first in case the form doesn't have a value for them
        //even in editing mode, i.e. 
        List<String> forceNewURIs = new ArrayList<String>();
        forceNewURIs.add("agent");
        conf.addEditSubmissionPreprocessor(new NewResourcePreprocessor(conf, forceNewURIs));
        // Adding additional data, specifically edit mode
        addFormSpecificData(conf, vreq);
        prepare(vreq, conf);
        return conf;
    }
    
    /* N3 assertions for adding a work contribution to an agent */
    
    /* New contribution always created, even for existing work */
    final static String n3ForContribution =       
        "@prefix ld4l: <"+ ld4l +"> .\n" +
        "@prefix rdfs: <"+ rdfs +">  . \n"+
        "?contribution  a ld4l:Contribution .\n" +
        "?contribution  a ?contributionType .\n" +
        "?contribution rdfs:label ?contributionLabel . \n" ;

    //Work and contribution relationships that will always be created
    //Since a new contribution is always generated
    final static String n3ForWorkToContribution  =      
        "@prefix ld4l: <"+ ld4l +"> .\n" +
        "@prefix rdfs: <"+ rdfs +">  . \n"+
        "?work ld4l:hasContribution ?contribution . \n" + 
        "?contribution ld4l:contributedTo ?work .\n " ;
    
    final static String n3ForContributionToAgent  =      
            "@prefix ld4l: <"+ ld4l +"> .\n" +
            "@prefix rdfs: <"+ rdfs +">  . \n"+
            "@prefix prov: <"+ prov +">  . \n"+
            "?contribution prov:agent ?agent .\n " +
            "?agent ld4l:isAgentOf ?contribution .\n ";
    
    //If new work is being created
    final static String n3ForNewAgent =
	   "@prefix ld4l: <"+ ld4l +"> .\n" +
        "@prefix rdfs: <"+ rdfs +">  . \n"+
        "@prefix foaf:<" + foaf + "> . \n" +  
        "?agent a ?agentType. \n" +
        "?agent rdfs:label  ?agentName. \n" +
        "?agent foaf:name ?agentName .";
    

    final static String contributionLabelAssertion  =      
        "@prefix rdfs: <"+ rdfs +">  . \n"+
        "?contribution rdfs:label ?contributionLabel" +
        " ";                
    
            
    
    /* Queries for editing an existing work contribution */

//Don't need existing contribution query because that will be supplied by object uri              

    final static String contributionLabelQuery  =      
        "PREFIX rdfs: <"+ rdfs +">   \n"+
        "PREFIX ld4l: <" + ld4l +">\n" +
        "SELECT ?existingContributionLabel WHERE {\n"+
        "?contribution rdfs:label ?existingContributionLabel .\n" +
        " }";  
    final static String existingContributionTypeQuery =    
            "PREFIX ld4l: <" + ld4l +">\n" +
            "PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#> \n" +
            "SELECT ?existingContributionType WHERE {\n"+
            "?contribution vitro:mostSpecificType ?existingContributionType .\n" +
            " }"; 
    
    final static String existingAgentQuery  =      
        "PREFIX ld4l: <"+ ld4l +">\n" +
        "PREFIX prov: <" + prov + "> \n" + 
        "SELECT ?existingAgent WHERE {\n"+
        "?contribution prov:agent ?existingAgent ." + 
        " }";    

    final static String existingAgentTypeQuery  =      
            "PREFIX ld4l: <"+ ld4l +">\n" +
            "PREFIX prov: <" + prov + "> \n" + 
            "PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#> \n" +
            "SELECT ?existingAgentType WHERE {\n"+
            "?contribution prov:agent ?agent ." + 
            "?agent vitro:mostSpecificType ?existingAgentType . " + 
            " }";  
    
    final static String existingAgentNameQuery  =      
            "PREFIX ld4l: <"+ ld4l +">\n" +
            "PREFIX prov: <" + prov + "> \n" + 
            "PREFIX rdfs: <"+ rdfs +">   \n"+
            "PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#> \n" +
            "SELECT ?existingAgentName WHERE {\n"+
            "?contribution prov:agent ?agent ." + 
            "?agent rdfs:label ?existingAgentName . " + 
            " }"; 
    
    // Adding form specific data such as edit mode
    public void addFormSpecificData(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
        HashMap<String, Object> formSpecificData = new HashMap<String, Object>();
        formSpecificData.put("editMode", getEditMode(vreq).name().toLowerCase());
		//Work could use the same person already in another contribution
      
        //formSpecificData.put("sparqlForAcFilter", getSparqlForAcFilter(vreq));

        editConfiguration.setFormSpecificData(formSpecificData);
    }
    
    public EditMode getEditMode(VitroRequest vreq) {
        List<String> predicates = new ArrayList<String>();
        predicates.add(ld4l + "isAgentOf");
        return EditModeUtils.getEditMode(vreq, predicates);
    }
    
	public String getSparqlForAcFilter(VitroRequest vreq) {
		String subject = EditConfigurationUtils.getSubjectUri(vreq);			
		String query = "PREFIX ld4l:<" + ld4l + "> " + 
		"PREFIX prov:<" + prov + "> " +   
		"SELECT ?agent WHERE { " + 
			"<" + subject + "> ld4l:hasContribution ?contribution ." + 
				"?contribution prov:agent ?agent ." + 
			"?agent  <" + VitroVocabulary.RDF_TYPE + "> <" + foaf + "Agent> . }";
		return query;
	}
}
