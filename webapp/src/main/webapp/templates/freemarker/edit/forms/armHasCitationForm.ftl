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



<#--  --assign pubTypeLiteralOptions = editConfiguration.pageData.pubType /-->
<#-- In case of submission error, may already have publication type or title - although latter not likely, but storing values to be on safe side -->
<#--  --assign publicationTypeValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "pubType") /-->
<#assign titleValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "title") />


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
<h2>Has Bibliographic Citation </h2>

<#if submissionErrors?has_content>
  <#--  Some custom handling -->
    <#--  --if collectionDisplayValue?has_content >
        <#assign collectionValue = collectionDisplayValue />
    </#if>
    <#if bookDisplayValue?has_content >
        <#assign bookValue = bookDisplayValue />
    </#if>
    <#if conferenceDisplayValue?has_content >
        <#assign conferenceValue = conferenceDisplayValue />
    </#if>
    <#if eventDisplayValue?has_content >
        <#assign eventValue = eventDisplayValue />
    </#if>
    <#if editorDisplayValue?has_content >
        <#assign editorValue = editorDisplayValue />
    </#if>
    <#if publisherDisplayValue?has_content >
        <#assign publisherValue = publisherDisplayValue />
    </#if-->

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

<section id="addCitationSection" role="region">

<@lvf.unsupportedBrowser urls.base/>
<form id="addCitation" class="customForm noIE67" action="${submitUrl}"  role="add work" >

    <div id="formcontent">
	     <#--  at location -->
      <#--  Autocomplete field for Subject Headings using LOC SH field -->

      <div>
      
      	 <div id="actionTypeOptions">
				<input checked="checked" type="radio" name="actionType"  value="lookup">Lookup Page, Volume, or Text
				<input type="radio" name="actionType"  value="create">Create new Page, Volume, or Text
			</div>
			<br/>
			
		
			<div id="createNewLocation" style="display:none">
				<div id="locationTypeSection" role="locationTypeSection">
			  		<p>
			  		<label for="locationType">Location Type </label>
	  			   <select id="locationType" name="locationType" role="select">
	  			   	    <option value="">Select event source type</option>
	               		<option value="https://w3id.org/arm/core/ontology/0.1/Page">Page</option>
						<option value="https://w3id.org/arm/core/ontology/0.1/Volume">Volume</option>
						<option value="http://id.loc.gov/ontologies/bibframe/Instance">Instance</option>
	            	</select>
			        </p>
		  		</div>
				 
				 <p id="locationValueSection" style="display:none">
	              <label for="locationValue">Value</label>
	              <input size="60"  type="text" id="locationValue" name="locationValue" value="" />
	    		 </p>
	    		 
	    		  <p id="locationTitleSection" style="display:none">
	              <label for="locationPreferredTitle">Preferred Title</label>
	              <input size="60"  type="text" id="locationPreferredTitle" name="locationPreferredTitle" value="" />
	    		 </p>
	    	</div>
	    		 
	    		 
	   		<div id="lookupLocation">
	      
	          <p templateId="inputAcSelector">
	    		<label for="location">Entry source</label>
	              <input type="hidden"  name="locationLabel" id="locationLabel"/>
	              <input class="acSelector" size="60"  type="text" id="locationName" name="locationName" acGroupName="location"  value="" acUrl="${urls.base}/autocomplete?tokenize=true"/>
	          </p>
	
	
	          <div class="acSelection" acGroupName="location" >
	              <p class="inline">
	                  <label>${i18n().selected} source:</label>
	                  <span class="acSelectionInfo"></span>
	                  <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or}
	                  <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
	              </p>
	              <input class="acUriReceiver" type="hidden" id="location" name="location" value=""  />
	              <#--  $ {flagClearLabelForExisting}="true"  -->
	          </div>
          </div>
      </div>
      
     <#--  Source value -->
     <p>
              <label for="entryValue">Bibliographic citation entry/source value</label>
              <input size="60"  type="text" id="entryValue" name="entryValue" value="" />
     </p>

   
      <#--  Note value -->
     <p>
              <label for="noteValue">Bibliographic citation note</label>
              <input size="60"  type="text" id="noteValue" name="noteValue" value="" />
     </p>
     
     
     

    
      
    </div>


       <p class="submit">
            <input type="hidden" name = "editKey" value="${editKey}"/>
            <input type="hidden" name="configFile" value="${configFile}" />
            <input type="submit" id="submit" value="${i18n().save_button}"/><span class="or"> ${i18n().or} </span><a class="cancel" href="${cancelUrl}" title="${i18n().cancel_title}">${i18n().cancel_link}</a>
       </p>

       <p id="requiredLegend" class="requiredHint">* ${i18n().required_fields}</p>
    </form>


  

<#assign sparqlQueryUrl = "${urls.base}/ajax/sparqlQuery" >

    <script type="text/javascript">
    //No uris or literals in scope here

  //TODO: Handle multiple autocompletes on the same page?
  //regular autocomplete url: acUrl: '${urls.base}/autocomplete?tokenize=true',
    var customFormData  = {
        sparqlQueryUrl: '${sparqlQueryUrl}',
        acUrl: 'acUrl="${urls.base}/autocomplete?tokenize=true"',
        customFormAJAXUrl:'${urls.base}/ajax/customForm',
        editMode: '${editMode}',
        baseHref: '${urls.base}/individual?uri=',
        //blankSentinel: '${blankSentinel}',
        flagClearLabelForExisting: '${flagClearLabelForExisting}',
        defaultTypeName: 'entity', //REPLACE with type name for specific auto complete
        acMultipleTypes: 'true',
        acTypes: {location: 'https://w3id.org/arm/core/ontology/0.1/Page,https://w3id.org/arm/core/ontology/0.1/Volume,http://id.loc.gov/ontologies/bibframe/Text'},
        configFileURL:"${urls.base}/templates/freemarker/edit/forms/js/jsonconfig/${configFile}",
       	defaultNamespace:"${defaultNamespace}"
    };
    var i18nStrings = {
        selectAnExisting: '${i18n().select_an_existing}',
        orCreateNewOne: '${i18n().or_create_new_one}',
        selectedString: '${i18n().selected}'
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

${scripts.add('<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.12.1.min.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>',              
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/customFormWithAutocompleteAuthority.js"></script>',
              '<script type="application/ld+json" id="configjsonscript" src="${urls.base}/templates/freemarker/edit/forms/js/jsonconfig/${configFile}"></script>', 
               '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/jsonconfig/${configDisplayFile}"></script>', 
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/minimalCustomTemplate.js"></script>',
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/armHasCitation.js"></script>')}
