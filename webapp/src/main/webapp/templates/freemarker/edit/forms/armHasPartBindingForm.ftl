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
     <ul id="existingCitations" style="display:none">
          	 <li class='conceptHeadings conceptsListContainer'>
             <div class='container'>
                 <div class='row'>
                     <div class='col-12'>
                         <div class='column conceptLabelInfo'>
                            <h4>Bindings </h4>
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

    
    
		<div>
      		<p>
      		<label for="bindingType">Binding Type</label>
           	<select id="bindingType" name="bindingType" role="select">

           	</select>
        	</p>
      	</div>
      	
      	<div>
      		<p>
      		<label for="bindingComponent">Binding Component</label>
           	<select id="bindingComponent" name="bindingComponent" role="select">

           	</select>
        	</p>
      	</div>
	<br/>
	
	<h4 class="services">Add Note</h4>
 		
 		<fieldset class="workform__fieldset">
 		<div>
      		<p>
      		<label for="noteType">Note Type</label>
           	<select id="noteType" name="noteType" role="select">

           	</select>
        	</p>
      	</div>
		<div>
      	<p>
              <label for="noteValue">Note</label>
              <input size="60"  type="text" id="noteValue" name="noteValue" value="" />
     	</p>
     	</div>
  		</fieldset>
	
	
		<h4 class="services">Add activity/role</h4>
 		
 		<fieldset class="workform__fieldset">
		<div> 
		
			<div>
	      		<p>
	      		<label for="activityType">Activity Type</label>
	           	<select id="activityType" name="activityType" role="select">
	
	           	</select>
	        	</p>
      		</div>
		
			<div id="actionTypeOptions">
				<input checked="checked" type="radio" name="actionType"  value="lookup">Lookup agent
				<input type="radio" name="actionType"  value="create">Create new agent
			</div>
			<br/>
			
			<div id="vocabSource">
				<input checked="checked" type="radio" lookupType="http://id.loc.gov/ontologies/bibframe/Agent" name="selectAcUrl"  value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Fperson"> LOC Person
				<input type="radio" lookupType="http://id.loc.gov/ontologies/bibframe/Agent" name="selectAcUrl"  value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Forganization"> LOC Organization
			</div>
			
			
	  		
	        <p>
	            <label for="agent"> Person or Organization${requiredHint}</label>
	            <input class="acSelector" size="60"  type="text" id="agentName" name="agentName" acGroupName="agent"  value="" acUrl="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Fperson"/>
	        </p>
	
		
	        <div class="acSelection" acGroupName="agent">
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
              <label for="activityDate">Date</label>
              <input size="60"  type="text" id="activityDate" name="activityDate" value="" />
     	</p>
     	</div>
 		
 		
 		
  		
  
  		<div> 
	        <p>
	            <label for="location"> Location</label>
	            <input class="acSelector" size="60"  type="text" id="locationName" name="locationName" acGroupName="location"  value="" acUrl="${urls.base}/conceptSearchService?source=http%3A%2F%2Fgeonames.org"/>
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
  		</fieldset>


	<h4 class="services">Add Marking</h4>
 		
 		<fieldset class="workform__fieldset">
 		<div>
      	<p>
              <label for="markingValue">Marking Value</label>
              <input size="60"  type="text" id="markingValue" name="markingValue" value="" />
     	</p>
     	</div>
      	<div>
      		<p>
      		<label for="markingType">Marking Type ${requiredHint}</label>
           	<select id="markingType" name="markingType" role="select">

           	</select>
        	</p>
      	</div>
		<div> 
			<div id="actionTypeOptions">
				<input checked="checked" type="radio" name="markingActionType"  value="lookup">Lookup agent
				<input type="radio" name="markingActionType"  value="create">Create new agent
			</div>
			<br/>
			
			<div id="vocabSource">
				<input checked="checked" type="radio" lookupType="http://id.loc.gov/ontologies/bibframe/Agent" name="selectMarkingAcUrl"  value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Fperson"> LOC Person
				<input type="radio" lookupType="http://id.loc.gov/ontologies/bibframe/Agent" name="selectMarkingAcUrl"  value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Forganization"> LOC Organization
			</div>
			
			
	  		
	        <p>
	            <label for="agent"> Person or Organization${requiredHint}</label>
	            <input class="acSelector" size="60"  type="text" id="markingAgentName" name="markingAgentName" acGroupName="markingAgent"  value="" acUrl="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Fperson"/>
	        </p>
	
		
	        <div class="acSelection" acGroupName="markingAgent">
	            <p class="inline">
	                <label>${i18n().selected}:</label>
	                <span class="acSelectionInfo"></span>
	                <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or} 
	                <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
	            </p>
	            <input class="acUriReceiver" type="hidden" id="markingAgent" name="markingAgent" value=""  />
	        </div>
	        
	        <div>
		      	<p>
		              <label for="markingActivityDate">Date</label>
		              <input size="60"  type="text" id="markingActivityDate" name="markingActivityDate" value="" />
		     	</p>
	     	</div>
 		
	        
	        <div> 
		        <p>
		            <label for="markingLocation"> Location</label>
		            <input class="acSelector" size="60"  type="text" id="markingLocationName" name="markingLocationName" acGroupName="markingLocation"  value="" acUrl="${urls.base}/conceptSearchService?source=http%3A%2F%2Fgeonames.org"/>
		        </p>
		
			
		        <div class="acSelection" acGroupName="markingLocation">
		            <p class="inline">
		                <label>${i18n().selected}:</label>
		                <span class="acSelectionInfo"></span>
		                <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or} 
		                <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
		            </p>
		            <input class="acUriReceiver" type="hidden" id="markingLocation" name="markingLocation" value=""  />
		        </div>
	  		</div>
  		</div>
 		
 		
 		
 		
  		</fieldset>
  
  		
  
  
  		<input name="markingActivityLabel" id="markingActivityLabel" type="hidden" value="" />
    
    <div id="errors" name="errors"></div>
    
   


       <p class="submit">
            <input type="hidden" name = "editKey" value="${editKey}"/>
            <input type="hidden" name="configFile" value="${configFile}" />
            <input type="submit" id="submit" name="formSubmit" value="${i18n().save_button}"/><span class="or"> OR </span><a class="cancel" href="${cancelUrl}" title="${i18n().cancel_title}">${i18n().cancel_link}</a>
       </p>

       <p id="requiredLegend" class="requiredHint">* ${i18n().required_fields}</p>
        </#if> <#--  End form addition -->
        <#if editMode = "edit">
	  	</div> <#-- End formcontent div above -->
	  </#if>
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
        defaultNamespace:"${defaultNamespace}",
        eraseLabelsForFields:["locationName", "agentName"],
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
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/customFormWithAutocompleteAuthority.js"></script>',
              '<script type="application/ld+json" id="configjsonscript" src="${urls.base}/templates/freemarker/edit/forms/js/jsonconfig/${configFile}"></script>', 
               '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/jsonconfig/${configDisplayFile}"></script>', 
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/minimalCustomTemplate.js"></script>',
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/armHasPartBinding.js"></script>')}
