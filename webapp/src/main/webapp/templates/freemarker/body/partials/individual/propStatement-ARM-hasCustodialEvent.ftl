<#-- Custom object property statement view for faux property "contributed to" of http://bib.ld4l.org/ontology/isAgentOf. 
     See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<@showCustodialEvent statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showCustodialEvent statement>

    <#local eventLabel>${eventType}<#if statement.eventLabel>: ${statement.eventName}</#if></#local>
    <a href="${profileUrl(statement.uri("custodialEvent"))}" title="${eventLabel}">${eventLabel}</a>
    <#if statement.eventLocation>
        <#local eventLocationLabel>${statement.eventLocationName!statement.eventLocation}</#local>
        <a href="${profileUrl(statement.uri("eventLocation"))}" title="${eventLocationLabel}">${eventLocationLabel}</a>
    </#if>
    <#if statement.eventDate>${eventDate}</#if>

</#macro>
