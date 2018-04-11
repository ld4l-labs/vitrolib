<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Minimal template for use with JSON-LD and JSON configuration for custom forms -->

<#--  Common section -->
<#import "lib-vitro-form.ftl" as lvf>

<#--Retrieve certain edit configuration information-->
<#assign defaultNamespace = editConfiguration.defaultNamespace />
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
<form id="hasActivity" class="customForm noIE67" action="${submitUrl}"  role="add activity" >

    <div id="formcontent">

      <#--  Autocomplete field for Subject Headings using LOC SH field -->

     
      <ul id="existingActivities" style="display:none">
          	 <li class='conceptHeadings conceptsListContainer'>
             <div class='container'>
                 <div class='row'>
                     <div class='col-12'>
                         <div class='column conceptLabelInfo'>
                            <h4>Activity </h4>
                         </div>
                         
                         <div class='column conceptRemoval'>&nbsp;
                         </div>
                     </div>
                 </div>
             </div>
    	 	</li>
      </ul>
       

	<br/>


	<h4 class="services">Recorded At</h4>
	<div> Lookup event </div>
  
  	<div> Create new event
  		<p>
  		<label for="eventType">Event Type</label>
  			   <select id="activityType" name="activityType" role="select">
                
            	</select>
        </p>
  		</div>
  
 
 		
 		
		<div> 
			<div id="vocabSource">
				<input checked="checked" type="radio" name="selectAcUrl"  value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Fperson"> LOC Person
				<input type="radio" name="selectAcUrl"  value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Forganization"> LOC Organization
				<input type="radio" name="selectAcUrl"  value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fisni.oclc.nl%2Fsru"> ISNI

			</div>
	        <p>
	            <label for="agent"> Person or Organization${requiredHint}</label>
	            <input class="acSelector" size="60"  type="text" id="agentName" name="agentName" acGroupName="group"  value="" acUrl="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Fperson"/>
	        </p>
	
		
	        <div class="acSelection" acGroupName="group">
	            <p class="inline">
	                <label>${i18n().selected}:</label>
	                <span class="acSelectionInfo"></span>
	                <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or} 
	                <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
	            </p>
	            <input class="acUriReceiver" type="hidden" id="agent" name="agent" value=""  />
	        </div>
  		</div>
 		
 		
 		
 		<div>
  		<p>
  		<label for="agentType">Agent Type </label>
  			   <select id="agentType" name="agentType" role="select">
                
            	</select>
        </p>
  		</div>
  
  		<div> 
	        <p>
	            <label for="location"> Location</label>
	            <input class="acSelector" size="60"  type="text" id="locationName" name="locationName" acGroupName="group"  value="" acUrl="${urls.base}/conceptSearchService?source=http%3A%2F%2Fgeonames.org"/>
	        </p>
	
		
	        <div class="acSelection" acGroupName="location">
	            <p class="inline">
	                <label>${i18n().selected}:</label>
	                <span class="acSelectionInfo"></span>
	                <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or} 
	                <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
	            </p>
	            <input class="acUriReceiver" type="hidden" id="location" name="location" value=""  />
	        </div>
  		</div>
  
  
  		<input name="activityLabel" id="activityLabel" type="hidden" value="" />
    
    <div id="errors" name="errors"></div>
    
   


       <p class="submit">
            <input type="hidden" name = "editKey" value="${editKey}"/>
            <input type="hidden" name="configFile" value="${configFile}" />
            <input type="submit" id="submit" name="formSubmit" value="${i18n().save_button}"/><span class="or"> OR </span><a class="cancel" href="${cancelUrl}" title="${i18n().cancel_title}">${i18n().cancel_link}</a>
       </p>

       <p id="requiredLegend" class="requiredHint">* ${i18n().required_fields}</p>
    </form>




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
        primitiveEdit:"${urls.base}/edit/primitiveRdfEdit",
        defaultNamespace:"${defaultNamespace}"
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
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/customFormWithAutocompleteAuthority.js"></script>',
              '<script type="application/ld+json" id="configjsonscript" src="${urls.base}/templates/freemarker/edit/forms/js/jsonconfig/${configFile}"></script>', 
               '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/jsonconfig/${configDisplayFile}"></script>', 
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/minimalCustomTemplate.js"></script>',
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/hasActivity.js"></script>')}
