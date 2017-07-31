<#-- Custom object property statement view for property http://bib.ld4l.org/ontology/hasContribution. See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<@showWork statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showWork statement>

<#if statement.work??>
    <#local workTitle = statement.agentTitle!statement.workLabel>
    <a href="${profileUrl(statement.uri("work"))}" title="${workTitle}">${workTitle}</a>
    
<#-- If there is no agent, still show activity -->
<#else>    
	<#if statement.work??>
		    <a href="${profileUrl(statement.uri("work"))}" title="${statement.work}">${statement.work}</a>

	</#if>
</#if>

</#macro>
