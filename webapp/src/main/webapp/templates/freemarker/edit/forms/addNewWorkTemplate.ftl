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
<h2>New Work</h2>

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
<form id="addNewWork" class="customForm noIE67" action="${submitUrl}"  role="add work" >

    <div id="formcontent">
    <#--  New Work fields -->
      <#--  Title -->
     <p>
              <label for="title">Title ${requiredHint}</label>
              <input size="60"  type="text" id="title" name="title" value="" />
     </p>

     <#--  Type: Subclasses of WORK Class - or classes within classgroup? -->
     <div>
      <p>
      <label for="workType">Type ${requiredHint}</label>
           <select id="workType" name="workType" role="select">

              </select>
        </p>
      </div>
      
      <#-- Language -->
      
        <div>
      <p>
      <label for="language">Language ${requiredHint}</label>
           <select id="language" name="language" role="select">

              </select>
        </p>
      </div>
    <#--  Autocomplete field for AUTHOR using LOC NAF field -->

      <div>
      		<p>
      		  <label for="agentName">Role${requiredHint}</label>
              <select name="activityType" id="activityType" role="select">
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
      		<input type="hidden" name="agentType" id="agentType" value=""/>
      		
      		<div> 
				<div id="vocabSource">
					<input checked="checked" type="radio" name="selectAcUrl" lookupType="http://xmlns.com/foaf/0.1/Person" value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Fperson"> LOC Person
					<input type="radio" name="selectAcUrl" lookupType="http://xmlns.com/foaf/0.1/Organization" value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames%2Forganization"> LOC Organization
					<input type="radio" name="selectAcUrl" lookupType="http://xmlns.com/foaf/0.1/Agent"  value="${urls.base}/conceptSearchService?source=http%3A%2F%2Fisni.oclc.nl%2Fsru"> ISNI
	
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
      		
      		
    
      </div>
      
      <#--  Autocomplete field for Subject Headings using LOC SH field -->

      <div>
      	
      		  
             
          <p templateId="inputAcSelector">
    		<label for="lcshTerm">LC Subject Heading</label>
              <input type="hidden"  name="lcshLabel" id="lcshLabel"/>
              <input class="acSelector" size="60"  type="text" id="lcshTerm" name="lcshTerm" acGroupName="lcshGroup"  value="" acUrl="${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fsubjects"/>
          </p>


          <div class="acSelection" acGroupName="lcshGroup" templateId="literalSelection">
              <p class="inline">
                  <label>${i18n().selected} Subject:</label>
                  <span class="acSelectionInfo"></span>
                  <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or}
                  <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
              </p>
              <input class="acUriReceiver" type="hidden" id="lcsh" name="lcsh" value=""  />
              <#--  $ {flagClearLabelForExisting}="true"  -->
          </div>
      </div>
      
      
      <#-- '${urls.base}/conceptSearchService?source=http%3A%2F%2Fid.loc.gov%2Fauthorities%2Fnames' -->

      <#--  Instance fields are in their own field set -->
      <fieldset class="workform__fieldset">
        <legend class="workform__legend"><strong>Has Instance</strong> (RDA Manifestation) </legend>

        <div>
          <p>
            <label for="instanceTitle">Title</label>
            <input size="60"  type="text" id="instanceTitle" name="instanceTitle" value="" />
          </p>
        </div>
        
        <div>
          <p>
            <label for="statementResponsibility">Statement of Responsibility</label>
            <input size="60"  type="text" id="statementResponsibility" name="statementResponsibility" value="" />
          </p>
        </div>

		<#-- Instance Type -->
	<div>
      <p><#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->


      		<label for="instanceType">Type</label>
           <select id="instanceType" name="instanceType" role="select">

              </select>
        </p>
      </div>
      
      <div>
          <p>
            <label for="issueNumber">Issue Number</label>
            <input size="60"  type="text" id="issueNumber" name="issueNumber" value="" />
          </p>
        </div>
      
         <div>
          <p>
            <label for="issueNumber">Matrix Number</label>
            <input size="60"  type="text" id="matrixNumber" name="matrixNumber" value="" />
          </p>
        </div>
        
       <div>
          <p>
            <label for="issueNumber">UPC</label>
            <input size="60"  type="text" id="upc" name="upc" value="" />
          </p>
        </div>

       <div>
          <p>
            <label for="issueNumber">EAN</label>
            <input size="60"  type="text" id="ean" name="ean" value="" />
          </p>
        </div>


        <div>
          <p>
            <label for="publisherAgentName"> Publisher</label>
            <input class="acSelector" size="60"  type="text" id="publisherAgentName" name="publisherAgentName" acGroupName="publisherGroup"  value="" />
          </p>

          <div class="acSelection" acGroupName="publisherGroup" templateId="literalSelection">
            <p class="inline">
                <label>${i18n().selected}:</label>
                <span class="acSelectionInfo"></span>
                <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or}
                <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
            </p>
            <input class="acUriReceiver" type="hidden" id="publisherAgent" name="publisherAgent" value=""  />
          </div>
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
        
        <div>
          <p>
            <label for="instanceTitle">Date of Publication</label>
            <input size="60"  type="text" id="publicationDate" name="publicationDate" value="" />
          </p>
        </div>
       <input type="hidden" name="publicationActivityLabel" id="publicationActivityLabel" value=""/> 
       <input type="hidden" name="publicationActivity" id="publicationActivity" value=""/> 
      </fieldset>
    </div>


       <p class="submit">
            <input type="hidden" name = "editKey" value="${editKey}"/>
            <input type="hidden" name="configFile" value="${configFile}" />
            <input type="submit" id="submit" value="${i18n().save_button}"/><span class="or"> ${i18n().or} </span><a class="cancel" href="${cancelUrl}" title="${i18n().cancel_title}">${i18n().cancel_link}</a>
       </p>

       <p id="requiredLegend" class="requiredHint">* ${i18n().required_fields}</p>
    </form>


    <#--  Form field option, Simple literal -->
    <#--  Need to handle required vs. non-required, also put these in their own templates -->
      <div templateId="literalTemplate" style="display:none" >
          <p>
              <label for=""></label>
              <input size="60"  type="text" id="" name="" value="" />
          </p>



      </div>

      <#--  Autocomplete literal template -->

    <div templateId="autocompleteLiteralTemplate" style="display:none">
          <p templateId="inputAcSelector">
              <label for=""> ${requiredHint}</label>
              <input class="acSelector" size="60"  type="text" id="" name="" acGroupName="group"  value="" />
          </p>


          <div class="acSelection" acGroupName="group" templateId="literalSelection">
              <p class="inline">
                  <label>${i18n().selected}:</label>
                  <span class="acSelectionInfo"></span>
                  <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or}
                  <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
              </p>
              <input class="acUriReceiver" type="hidden" id="" name="" value=""  ${flagClearLabelForExisting}="true" />
          </div>
      </div>

      <div templateId="selectDropdownTemplate" style="display:none">
      <p>
      <label for=""> </label>
           <select id="" name="" role="select">

              </select>
        </p>
      </div>

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
        acTypes: {},
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
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/addNewWorkSpecific.js"></script>')}
