<#-- Custom object property statement view for faux property "contributed to" of http://bib.ld4l.org/ontology/isAgentOf. 
     See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<@showContribution statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showContribution statement>

<#if statement.work?? && statement.workTitle??>
    <a href="${profileUrl(statement.uri("work"))}" title="${statement.workTitle}">${statement.workTitle}</a>
    <#if statement.subclassLabel??>
        (${statement.subclassLabel?replace(" contribution", "")})
    </#if>
</#if>

</#macro>
