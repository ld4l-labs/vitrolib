<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Default object property statement template. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->
<#if statement.marking??>
	<#assign displayHTML = ""/>
	<#if statement.markingValue??>
		<#assign displayHTML = statement.markingValue />
	</#if>
	<#if statement.markingMostSpecificTypeLabel??>
		<#assign displayHTML = displayHTML + " (" + statement.markingMostSpecificTypeLabel + ")"/>
	</#if>
<a href="${profileUrl(statement.uri("marking"))}" title="${i18n().name}">${displayHTML!}</a> 
</#if>