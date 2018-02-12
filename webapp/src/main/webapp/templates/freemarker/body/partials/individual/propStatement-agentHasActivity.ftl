<#-- Custom object property statement view for faux property "contributed to" of http://bib.ld4l.org/ontology/isAgentOf. 
     See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<@showTitle statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showTitle statement>

<#if statement.titleIndividual?? && statement.title??>
    <a href="${profileUrl(statement.uri("titleIndividual"))}" title="${statement.title}">${statement.title}</a>
</#if>

<#if statement.titleElement?? && statement.titleElementType?? && statement.titleElementValue?? && statement.titleElementTypeLabel??>
    <a href="${profileUrl(statement.uri("titleElement"))}" title="${statement.titleElementValue}">${statement.titleElementValue} (${statement.titleElementTypeLabel}</a>
</#if>
</#macro>
