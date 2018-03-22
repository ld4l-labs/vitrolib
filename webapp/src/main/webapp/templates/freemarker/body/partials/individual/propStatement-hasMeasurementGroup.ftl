<#-- Custom object property statement view for property http://measurement.example.org/hasMeasurementGroup. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<@showMeasurementGroup statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showMeasurementGroup statement>

<#if statement.measurementGroup??>
    Measurements:
    <#if statement.measurement1??>
        <a href="${profileUrl(statement.uri("measurement1"))}" title="${i18n().name}">${statement.dimensionLabel1}: ${statement.value1} ${statement.unitLabel1}</a>     
    </#if>
    <#if statement.measurement2??>
        <a href="${profileUrl(statement.uri("measurement2"))}" title="${i18n().name}">${statement.dimensionLabel2}: ${statement.value2} ${statement.unitLabel2}</a>   
    </#if>
    <#if statement.measurement3??>
        <a href="${profileUrl(statement.uri("measurement3"))}" title="${i18n().name}">${statement.dimensionLabel3}: ${statement.value3} ${statement.unitLabel3}</a>   
    </#if>
</#if>

</#macro>
