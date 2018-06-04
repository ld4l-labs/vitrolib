<#-- Custom object property statement view for faux property "part of bound collection" of http://id.loc.gov/ontologies/bibframe/Item. 
     See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<@showBoundCollection statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showBoundCollection statement>

    <#if statement.titleValue??>
        <a href="${profileUrl(statement.uri("preferredTitle"))}" title="${statement.titleValue}">${statement.titleValue}</a>  
    <#else>
        ${statement.label}
    </#if>

</#macro>