<#-- Custom object property statement view for faux property "contributed to" of http://bib.ld4l.org/ontology/isAgentOf. 
     See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<@showActivity statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showActivity statement>

<#if statement.citation??>
<a href="${profileUrl(statement.uri("citation"))}" title="${statement.citation}">
<#if statement.entryValue??>
   Entry: ${statement.entryValue} &nbsp;
</#if>
<#if statement.citationNoteValue??>
    Note: ${statement.citationNoteValue} &nbsp;
</#if>
</a>

<#if statement.entryLocationInstance?? && statement.instanceTitle??>
<a href="${profileUrl(statement.uri("entryLocationInstance"))}" title="${statement.instanceTitle}">Instance: ${statement.instanceTitle}</a>&nbsp;
</#if>

<#if statement.entryLocationPage?? && statement.pageValue??>
<a href="${profileUrl(statement.uri("entryLocationPage"))}" title="${statement.pageValue}">Page: ${statement.pageValue}</a>&nbsp;
</#if>

<#if statement.entryLocationVolume?? && statement.entryLocationVolumeValue??>
<a href="${profileUrl(statement.uri("entryLocationVolume"))}" title="${statement.entryLocationVolumeValue}">Volume: ${statement.entryLocationVolumeValue}</a>
</#if>

</#if>
</#macro>
