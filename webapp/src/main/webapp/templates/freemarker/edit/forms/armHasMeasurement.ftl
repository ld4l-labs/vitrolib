<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Minimal template for use with JSON-LD and JSON configuration for custom forms -->

<#--  Common section -->
<#import "lib-vitro-form.ftl" as lvf>

<#--Retrieve certain edit configuration information-->
<#assign editMode = editConfiguration.pageData.editMode />
<#assign newUriSentinel = "" />
<#if editConfigurationConstants?has_content>
  <#assign newUriSentinel = editConfigurationConstants["NEW_URI_SENTINEL"] />
</#if>

<#--  --assign sparqlForAcFilter = editConfiguration.pageData.sparqlForAcFilter /-->

<#--assign htmlForElements = editConfiguration.pageData.htmlForElements ! {}/-->

<#--drop down options for a field are included in page data with that field name-->

<#--If edit submission exists, then retrieve validation errors if they exist-->
<#if editSubmission?has_content && editSubmission.submissionExists = true && editSubmission.validationErrors?has_content>
  <#assign submissionErrors = editSubmission.validationErrors/>
</#if>

<#--The blank sentinel indicates what value should be put in a URI when no autocomplete result has been selected.
If the blank value is non-null or non-empty, n3 editing for an existing object will remove the original relationship
if nothing is selected for that object -->
<#assign blankSentinel = "" />
<#if editConfigurationConstants?has_content && editConfigurationConstants?keys?seq_contains("BLANK_SENTINEL")>
  <#assign blankSentinel = editConfigurationConstants["BLANK_SENTINEL"] />
</#if>

<#-- This flag is for clearing the label field on submission for an existing object being selected from autocomplete.
Set this flag on the input acUriReceiver where you would like this behavior to occur. -->
<#assign flagClearLabelForExisting = "flagClearLabelForExisting" />
<#--  Common section -->




<#--  Get the configfile name and include below -->
<#assign configFile = editConfiguration.pageData.configFile />
<#assign configDisplayFile = editConfiguration.pageData.configDisplayFile>
<#if editMode == "edit">
        <#assign titleVerb="${i18n().edit_capitalized}">
        <#assign submitButtonText="${i18n().save_changes}">
        <#assign disabledVal="disabled">
<#else>
        <#assign titleVerb="${i18n().create_capitalized}">
        <#assign submitButtonText="${i18n().create_entry}">
        <#assign disabledVal=""/>
</#if>

<#--  What to replace publication entry for with? Display name of property-->
<h2>Measurement Group</h2>

<#if submissionErrors?has_content>
 
    <section id="error-alert" role="alert">
        <img src="${urls.images}/iconAlert.png" width="24" height="24" alert="${i18n().error_alert_icon}" />
        <p>
        <#--below shows examples of both printing out all error messages and checking the error message for a specific field-->
        <#if lvf.submissionErrorExists(editSubmission, "title")>
           ${i18n().select_existing_pub_or_enter_new}<br />
        <#else>
            <#list submissionErrors?keys as errorFieldName>
              ${submissionErrors[errorFieldName]} <br/>
            </#list>
        </#if>
        </p>
    </section>
</#if>


<#assign requiredHint = "<span class='requiredHint'> *</span>" />
<#assign yearHint     = "<span class='hint'>(${i18n().year_hint_format})</span>" />

<#if editMode = "error">
 <div>Error</div>
<#else>

<section id="hasLCSHSection" role="region">

<@lvf.unsupportedBrowser urls.base/>
<form id="hasLCSH" class="customForm noIE67" action="${submitUrl}"  role="add subject heading" >

    <div id="formcontent">

      <#--  Autocomplete field for Subject Headings using LOC SH field -->

     
      <ul id="existingMeasurements" style="display:none">
          	 <li class='conceptHeadings conceptsListContainer'>
             <div class='container'>
                 <div class='row'>
                     <div class='col-12'>
                         <div class='column conceptLabelInfo'>
                            <h4>Measurement Groups </h4>
                         </div>
                         
                         <div class='column conceptRemoval'>&nbsp;
                         </div>
                     </div>
                 </div>
             </div>
    	 	</li>
      </ul>
       

	<br/>

<#if editMode = "add">
    <form id="addConceptForm" class="customForm" action="${submitUrl}">
	<h4 class="services">Add Measurements</h4>
  
   
   <!--"groupDescription", "value1", "unit1", "dimension1"-->
    <!--Group Description-->
     <fieldset class="workform__fieldset">
        <legend class="workform__legend"><strong>Measurement 1</legend>
         <!-- Measurement 1-->
     	<p>
              <label for="value1">Numeric Value ${requiredHint}</label>
              <input size="60"  type="text" id="value1" name="value1" value=""/>
     	</p>
     	
     	<div>
      	<p>
	      <label for="unit1">Unit ${requiredHint}</label>
	           <select id="unit1" name="unit1" role="select" >
	
	              </select>
	        </p>
	      </div>
	     
	      <div>
      	<p>
	      <label for="dimension1">Dimension ${requiredHint}</label>
	           <select id="dimension1" name="dimension1" role="select" >
	
	              </select>
	        </p>
	      </div> 
	      
     </fieldset>
     
     <fieldset class="workform__fieldset">
        <legend class="workform__legend"><strong>Measurement 2</legend>
         <!-- Measurement 2-->
     	<p>
              <label for="value2">Numeric Value </label>
              <input size="60"  type="text" id="value2" name="value2" value=""/>
     	</p>
     	
     	<div>
      	<p>
	      <label for="unit2">Unit </label>
	           <select id="unit2" name="unit2" role="select" >
	
	              </select>
	        </p>
	      </div>
	     
	      <div>
      	<p>
	      <label for="dimension2">Dimension </label>
	           <select id="dimension2" name="dimension2" role="select" >
	
	              </select>
	        </p>
	      </div> 
	      
     </fieldset>
     
     <fieldset class="workform__fieldset">
        <legend class="workform__legend"><strong>Measurement 3</legend>
         <!-- Measurement 3-->
     	<p>
              <label for="value3">Numeric Value </label>
              <input size="60"  type="text" id="value3" name="value3" value=""/>
     	</p>
     	
     	<div>
      	<p>
	      <label for="unit3">Unit </label>
	           <select id="unit3" name="unit3" role="select" >
	
	              </select>
	        </p>
	      </div>
	     
	      <div>
      	<p>
	      <label for="dimension3">Dimension </label>
	           <select id="dimension3" name="dimension3" role="select" >
	
	              </select>
	        </p>
	      </div> 
	      
     </fieldset>
   
   


       <p class="submit">
            <input type="hidden" name = "editKey" value="${editKey}"/>
            <input type="hidden" name="configFile" value="${configFile}" />
            <input type="submit" id="submit" name="formSubmit" value="${i18n().save_button}"/><span class="or"> OR </span><a class="cancel" href="${cancelUrl}" title="${i18n().cancel_title}">${i18n().cancel_link}</a>
       </p>

       <p id="requiredLegend" class="requiredHint">* ${i18n().required_fields}</p>
    </form>

</#if>


<#assign sparqlQueryUrl = "${urls.base}/ajax/sparqlQuery" >
<#include "existingValuesScript.ftl" />

    <script type="text/javascript">
    //No uris or literals in scope here

  //TODO: Handle multiple autocompletes on the same page?
  //regular autocomplete url: acUrl: '${urls.base}/autocomplete?tokenize=true',
    var customFormData  = {
        sparqlQueryUrl: '${sparqlQueryUrl}',
        dataServiceUrl: '${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2FgenreForms',
        customFormAJAXUrl:'${urls.base}/ajax/customForm',
        editMode: '${editMode}',
        baseHref: '${urls.base}/individual?uri=',
        //blankSentinel: '${blankSentinel}',
        flagClearLabelForExisting: '${flagClearLabelForExisting}',
        defaultTypeName: 'entity', //REPLACE with type name for specific auto complete
        acTypes: {},
        configFileURL:"${urls.base}/templates/freemarker/edit/forms/js/jsonconfig/${configFile}",
        queryAJAXURL:"${urls.base}/ajax/sparqlQuery",
        subjectURI:"${editConfiguration.subjectUri}",
        predicateURI:"${editConfiguration.predicateUri}",
        primitiveEdit:"${urls.base}/edit/primitiveRdfEdit"
    };
    var i18nStrings = {
        selectAnExisting: '${i18n().select_an_existing}',
        orCreateNewOne: '${i18n().or_create_new_one}',
        selectedString: '${i18n().selected}',
        vocServiceUnavailable: '${i18n().vocabulary_service_unavailable}',
	    noResultsFound: '${i18n().no_serch_results_found}',
	    definitionString: '${i18n().definition_capitalized}',
	    bestMatchString: '${i18n().best_match}',
	    selectTermFromResults: '${i18n().select_term_from_results}',
	    confirmTermDelete: '${i18n().confirm_term_deletion}',
	    errorTernNotRemoved: '${i18n().error_term_not_deleted}',
	    displayMoreEllipsis: '${i18n().display_more_ellipsis}',
	    displayLess: '${i18n().display_less}',
	    showMoreContent: '${i18n().show_more_content}'
    };
    //Prevent custom form on load on document ready so these event listeners can be associated AFTER form is loaded
    preventLoadFlag = true;
    </script>


</section>
</#if>

<#-- Common section -->
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.12.1.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customForm.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customFormWithAutocomplete.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/lookupWithContext.css" />')}

${scripts.add('<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.12.1.min.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>',              
              '<script type="application/ld+json" id="configjsonscript" src="${urls.base}/templates/freemarker/edit/forms/js/jsonconfig/${configFile}"></script>', 
               '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/jsonconfig/${configDisplayFile}"></script>', 
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/minimalCustomTemplate.js"></script>',
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/armHasMeasurement.js"></script>')}
