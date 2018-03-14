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
        ${statement.dimensionLabel1}}: ${statement.measurementValue1} ${statement.unitLabel1}
    </#if>
    <#if statement.measurement2??>
        ${statement.dimensionLabel2}}: ${statement.measurementValue2} ${statement.unitLabel2}
    </#if>
    <#if statement.measurement3??>
        ${statement.dimensionLabel3}}: ${statement.measurementValue3} ${statement.unitLabel3}
    </#if>
</#if>

</#macro>
