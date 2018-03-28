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

<#assign actionText=""/>
<#if editMode = "add">
	<#assign actionText="Add "/>
<#else>
	<#assign actionText="Edit "/>
</#if>
<#--  What to replace publication entry for with? Display name of property-->
<h2>${actionText} Content Listing</h2>

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

<section id="addNewWork" role="region">

<@lvf.unsupportedBrowser urls.base/>
<form id="workHasPart" class="customForm noIE67" action="${submitUrl}"  role="add work" >
<#if editMode = "edit">
	     <p>
              <label for=""> Click to edit work </label>
              <a href="${profileUrl(editConfiguration.objectUri)}"><input  size="60"  type="button" id="title" name="title" acGroupName="localwork"  value="" ></a>
              
          </p>
</#if>
<#if editMode = "add">
	<div id="workActionTypeOptions">
		<input name="workActionType" type="radio" checked="checked" value="lookupLocalWork"/>Lookup local work
		<input name="workActionType" type="radio" value="createNewWork"/>Create new work
	</div>

	<div id="lookupLocalWork">
          <p>
              <label for="title"> Existing Work </label>
              <input class="acSelector" size="60"  type="text" id="existingTitle" name="title" acGroupName="localwork"  value="" acUrl="${urls.base}/autocomplete?tokenize=true"/>
          </p>


          <div class="acSelection" acGroupName="localwork">
              <p class="inline">
                  <label>${i18n().selected}:</label>
                  <span class="acSelectionInfo"></span>
                  <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or}
                  <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
              </p>
              <input class="acUriReceiver" type="hidden" id="objectVar" name="objectVar" value=""  ${flagClearLabelForExisting}="true" />
          </div>
    </div>


<div id="formcontent">
    <#--  New Work fields -->
      <#--  Title -->
      <!-- New work should just utilize the same title field as above -->
     <p>
              <label for="title">Title ${requiredHint}</label>
              <input size="60"  type="text" id="newTitle" name="title" value="" disabled="disabled"/>
     </p>

     <#--  Type: Subclasses of WORK Class - or classes within classgroup? -->
     <div>
      <p>
      <label for="workType">Type ${requiredHint}</label>
           <select id="workType" name="workType" role="select" disabled="disabled">

              </select>
        </p>
      </div>
      
     
    <#--  Autocomplete field for AUTHOR using LOC NAF field -->

      <div>
      		<p>
      		  <label for="agentName"> Agent Activity or Role${requiredHint}</label>
              <select name="activityType" id="activityType" role="select" disabled="disabled">
	              <option value="http://bibliotek-o.org/ontology/ComposerActivity">Composer</option>
					<option value="http://bibliotek-o.org/ontology/ArrangerActivity">Arranger</option>
					<option value="http://bibliotek-o.org/ontology/LibrettistActivity">Librettist</option>
					<option value="http://bibliotek-o.org/ontology/LyricistActivity">Lyricist</option>
					<option value="http://bibliotek-o.org/ontology/PerformerActivity">Performer</option>
					<option value="http://bibliotek-o.org/ontology/ConductorActivity">Conductor</option>
					<option value="http://bibliotek-o.org/ontology/MusicianActivity">Musician</option>
					<option value="http://bibliotek-o.org/ontology/SingerActivity">Singer</option>
					<option value="http://bibliotek-o.org/ontology/InstrumentalistActivity">Instrumentalist</option>
					<option value="http://bibliotek-o.org/ontology/NarratorActivity">Narrator</option>
					<option value="http://bibliotek-o.org/ontology/CommentatorActivity">Commentator</option>
					<option value="http://bibliotek-o.org/ontology/ProducerActivity">Producer</option>
					<option value="http://bibliotek-o.org/ontology/MusicalDirectorActivity">Musical director</option>
					<option value="http://bibliotek-o.org/ontology/SoundDesignerActivity">Sound designer</option>
					<option value="http://bibliotek-o.org/ontology/RecordistActivity">Recordist</option>
					<option value="http://bibliotek-o.org/ontology/BroadcasterActivity">Broadcaster</option>
              </select>
      		</p>
      		
      		<fieldset>
      		<div> 
				<div id="vocabSource">
					<input checked="checked" type="radio" lookupType="http://xmlns.com/foaf/0.1/Person" name="selectAcUrl"  value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Fperson" disabled="disabled"> LOC Person
					<input type="radio" lookupType="http://xmlns.com/foaf/0.1/Organization" name="selectAcUrl"  value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Forganization" disabled="disabled"> LOC Organization
					<input type="radio" lookupType="http://xmlns.com/foaf/0.1/Agent" name="selectAcUrl"  value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fisni.oclc.nl%2Fsru" disabled="disabled"> ISNI
				</div>
				
		        <p>
		            <label for="agent"> Person or Organization${requiredHint}</label>
		            <input class="acSelector" size="60"  type="text" id="agentName" name="agentName" acGroupName="agent"  value="" acUrl="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Fperson" disabled="disabled"/>
		        </p>
		
			
		        <div class="acSelection" acGroupName="agent">
		            <p class="inline">
		                <label>${i18n().selected}:</label>
		                <span class="acSelectionInfo"></span>
		                <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or} 
		                <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
		            </p>
		            <input class="acUriReceiver" type="hidden" id="agent" name="agent" value=""  disabled="disabled"/>
		        </div>
  			</div>
  			</fieldset>
  			
			<div>
				<!-- Duration -->
				<div>
					 <p>
			              <label for="duration">Duration:</label>
			              <input size"60"  type="text" id="duration" name="duration" value="" disabled="disabled"/>
	          		</p>
			     </div>
		      		<!-- Hardcoding in genre forms -->
		             
		          <p>
		    		<label for="lgftTerm">LC Genreform</label>
		              <input class="acSelector" size="60"  type="text" id="lgftTerm" name="lgftTerm" acGroupName="lgftGroup"  value="" acUrl="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2FgenreForms" disabled="disabled"/>
		          </p>
		
		
		          <div class="acSelection" acGroupName="lgftGroup" >
		              <p class="inline">
		                  <label>${i18n().selected} Genreform:</label>
		                  <span class="acSelectionInfo"></span>
		                  <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or}
		                  <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
		              </p>
		              <input class="acUriReceiver" type="hidden" id="lgft" name="lgft" value=""  disabled="disabled"/>
		              <#--  $ {flagClearLabelForExisting}="true"  -->
		          </div>
          
      		</div>
      	</div>
</div>


       <p class="submit">
            <input type="hidden" name = "editKey" value="${editKey}"/>
            <input type="hidden" name="configFile" value="${configFile}" />
            <input type="submit" id="submit" value="${i18n().save_button}"/><span class="or"> ${i18n().or} </span><a class="cancel" href="${cancelUrl}" title="${i18n().cancel_title}">${i18n().cancel_link}</a>
       </p>

       <p id="requiredLegend" class="requiredHint">* ${i18n().required_fields}</p>
       </#if>
    </form>



   
<#include "existingValuesScript.ftl" />

<#assign sparqlQueryUrl = "${urls.base}/ajax/sparqlQuery" >

    <script type="text/javascript">
    //No uris or literals in scope here

  //TODO: Handle multiple autocompletes on the same page?
  //regular autocomplete url: acUrl: '${urls.base}/autocomplete?tokenize=true',
    var customFormData  = {
        sparqlQueryUrl: '${sparqlQueryUrl}',
        acUrl: '${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames',
        customFormAJAXUrl:'${urls.base}/ajax/customForm',
        editMode: '${editMode}',
        baseHref: '${urls.base}/individual?uri=',
        //blankSentinel: '${blankSentinel}',
        flagClearLabelForExisting: '${flagClearLabelForExisting}',
        defaultTypeName: 'entity', //REPLACE with type name for specific auto complete
        acTypes: {"localwork":"http://id.loc.gov/ontologies/bibframe/Audio"},
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
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/addNewWorkSpecific.js"></script>',
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/workHasPart.js"></script>')}
