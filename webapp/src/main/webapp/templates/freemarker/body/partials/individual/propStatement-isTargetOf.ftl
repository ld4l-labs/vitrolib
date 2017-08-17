<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Default object property statement template. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

${statement.bodyValue!""} ${statement.motivationLabel!""} ${statement.selectorText!""}
<#if statement.sourceUri?has_content>
<a href="${profileUrl(statement.uri("sourceUri"))}" title="source">${statement.sourceLabel!"source"}</a> 
</#if>
<a href="${profileUrl(statement.uri("termuri"))}" title="${i18n().name}">${statement.termlabel!statement.localName!}</a> 
