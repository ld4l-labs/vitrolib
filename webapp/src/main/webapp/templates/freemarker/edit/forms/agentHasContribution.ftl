<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->
<#import "lib-vitro-form.ftl" as lvf>
<#--Retrieve certain edit configuration information-->
<#if editConfiguration.objectUri?has_content>
    <#assign editMode = "edit">
<#else>
    <#assign editMode = "add">
</#if>
<#assign requiredHint = "<span class='requiredHint'> *</span>" />
<#assign contributionTypeValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "contributionType") />
<#assign workLabelValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "workLabel") />
<#assign workValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "work") />

<#assign flagClearLabelForExisting = "flagClearLabelForExisting" />

<#--If edit submission exists, then retrieve validation errors if they exist-->
<#if editSubmission?has_content && editSubmission.submissionExists = true && editSubmission.validationErrors?has_content>
	<#assign submissionErrors = editSubmission.validationErrors/>
</#if>

<#if editMode == "edit">        
        <#assign titleVerb="${i18n().edit_capitalized}">        
        <#assign submitButtonText="${i18n().save_changes}">
        <#--  --assign disabledVal="disabled"-->
        <#assign disabledVal=""/>

<#else>
        <#assign titleVerb="${i18n().create_capitalized}">        
        <#assign submitButtonText="${i18n().create_entry}">
        <#assign disabledVal=""/>
</#if>

<h2>${titleVerb}&nbsp;${i18n().work_contribution}</h2>
    

<#if submissionErrors?has_content>
    <section id="error-alert" role="alert">
        <img src="${urls.images}/iconAlert.png" width="24" height="24" alert="${i18n().error_alert_icon}" />
        <p>
        <#--below shows examples of both printing out all error messages and checking the error message for a specific field-->
        <#list submissionErrors?keys as errorFieldName>
        	${errorFieldName} :  ${submissionErrors[errorFieldName]}
        </#list>
       
        
        </p>
    </section>
</#if>

<@lvf.unsupportedBrowser urls.base />

<div class="noIE67">

    
    

<section id="agentHasContribution" role="region">        
    
    <form id="agentHasContributionForm" class="customForm noIE67" action="${submitUrl}"  role="add/edit phone">

	<!-- autocomplete for work -->
	<p>
        <label for="relatedIndLabel">${i18n().work_label} ${requiredHint}</label>
        <input class="acSelector" size="50"  type="text" id="workLabel" acGroupName="work" name="workLabel" value="${workLabelValue}" />
    </p>

    <div class="acSelection" acGroupName="work">
        <p class="inline">
            <label>${i18n().selected_work}:</label>
            <span class="acSelectionInfo"></span>
            <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or} 
            <a href="#" class="changeSelection" id="changeSelection" title="${i18n().change_selection}">${i18n().change_selection})</a>
        </p>
        <input class="acUriReceiver" type="hidden" id="work" name="work" value="${workValue}" ${flagClearLabelForExisting}="true"/>
    </div>

    <br />


        
        <p class="inline">    
      <label for="contributionType">${i18n().contribution_type}<#if editMode != "edit"> ${requiredHint}<#else>:</#if></label>
      <#assign contributionTypeOpts = editConfiguration.pageData.contributionType />
     
        <select id="selector" name="contributionType"  ${disabledVal} >
            <option value="" selected="selected">${i18n().select_one}</option>                
            <#list contributionTypeOpts?keys as key>             
                <option value="${key}"  <#if contributionTypeValue = key>selected</#if>>${contributionTypeOpts[key]}</option>            
            </#list>
        </select>
      <input type="hidden" id="contributionLabel" name="contributionLabel" value = ""/>
    </p>

        <input type="hidden" id="editKey" name="editKey" value="${editKey}"/>

        <p class="submit">
            <input type="submit" id="submit" value="${submitButtonText}"/><span class="or"> ${i18n().or} </span>
            <a class="cancel" href="${cancelUrl}" title="${i18n().cancel_title}">${i18n().cancel_link}</a>
        </p>

        <p id="requiredLegend" class="requiredHint">* ${i18n().required_fields}</p>

    </form>

</section>

<#assign sparqlQueryUrl = "${urls.base}/ajax/sparqlQuery" >

    <script type="text/javascript">

    var customFormData  = {
        sparqlQueryUrl: '${sparqlQueryUrl}',
        acUrl: '${urls.base}/autocomplete?tokenize=true',
        acTypes: {work: 'http://bib.ld4l.org/ontology/Work'},
        editMode: '${editMode}',
        typeName: 'Work',
        defaultTypeName: 'work', // used in repair mode to generate button text
        baseHref: '${urls.base}/individual?uri=',
        flagClearLabelForExisting: '${flagClearLabelForExisting}'
    };
    var i18nStrings = {
        selectAnExisting: '${i18n().select_an_existing}',
        orCreateNewOne: '${i18n().or_create_new_one}',
        selectedString: '${i18n().selected}'
    };
    </script>
 
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customForm.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customFormWithAutocomplete.css" />')}

${scripts.add('<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>',
			'<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>',
             '<script type="text/javascript" src="${urls.base}/js/extensions/String.js"></script>',
             '<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>',
             '<script type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.bgiframe.pack.js"></script>',
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/customFormWithAutocomplete.js"></script>',
             '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/agentHasContribution.js"></script>')}