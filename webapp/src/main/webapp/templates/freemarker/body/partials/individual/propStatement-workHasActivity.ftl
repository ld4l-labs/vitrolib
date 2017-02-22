<#-- Custom object property statement view for property http://bib.ld4l.org/ontology/hasContribution. See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<@showActivity statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showActivity statement>

<#if statement.agent??>
    <#local agentName = statement.agentName!statement.agentLabel>
    <a href="${profileUrl(statement.uri("agent"))}" title="${agentName}">${agentName}</a>
    <#if statement.subclassLabel??>
        (${statement.subclassLabel?replace(" contribution", "")})
    </#if>
</#if>

</#macro>
