<#-- Custom object property statement view for faux property "part of bound collection" of http://id.loc.gov/ontologies/bibframe/Item. 
     See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<@showCustodialEvent statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showCustodialEvent statement>

    <a href="${profileUrl(statement.custodialEvent)}" title="${statement.eventLabel}">${statement.eventLabel}</a> ${statement.eventTypeLabel}
    <#if statement.location?? && statement.locationName??><a href="${profileUrl(statement.location)}" title="${statement.locationName}">${statement.locationName}</a></#if>
    <#if statement.date??>${statement.date}</#if>


</#macro>