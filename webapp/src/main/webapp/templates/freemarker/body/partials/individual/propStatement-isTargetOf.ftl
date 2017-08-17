<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Default object property statement template. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

Value:${statement.bodyValue!""}, Motivation: ${statement.motivationLabel!""}, Selector Text: ${statement.selectorText!""}
<br/>
<#if statement.sourceUri?has_content>
Source: <a href="${profileUrl(statement.uri("sourceUri"))}" title="source">${statement.sourceLabel!"source"}</a> 
</#if>