<#-- Custom object property statement view for faux property "contributed to" of http://bib.ld4l.org/ontology/isAgentOf. 
     See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<@showActivity statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showActivity statement>

<#if statement.instance?? && statement.instanceTitle??>
    <a href="${profileUrl(statement.uri("instance"))}" title="${statement.instanceTitle}">${statement.instanceTitle} <#if statement.mostSpecificTypeLabel??> (${statement.mostSpecificTypeLabel}) </#if></a>
   <#if statement.publicationAgentName??>
   	Publisher: ${statement.publicationAgentName}
   </#if>
 	<#if statement.publicationDate??>
    , ${statement.publicationDate}
   </#if>
   <#if statement.publicationLocationName??>
   , ${statement.publicationLocationName}
   </#if>
   <#if statement.identifierValue??>
   , Audio Issue Number: ${statement.identifierValue}
   </#if>
</#if>

</#macro>
