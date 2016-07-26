<#-- Custom object property statement view for faux property "same as instance" of owl:sameAs. 
     See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<@showInstance statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showInstance statement>

<#local label = statement.label!statement.localName!>
<a href="${statement.uri("object")}" title="${i18n().label}">${label}</a> 

</#macro>


