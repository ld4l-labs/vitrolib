<#-- Custom object property statement view for property http://measurement.bibliotek-o.org/hasMeasurementGroup. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->


<@showMeasurementGroup statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showMeasurementGroup statement>

<#if statement.measurementGroup??>
    <a href="${profileUrl(statement.measurementGroup)}">Measurements:</a><br/>

    <#if statement.measurement1??>
        <a href="${profileUrl(statement.measurement1)}">${statement.dimensionLabel1}: ${statement.value1} ${statement.unitLabel1}</a><br/> 

        <#if statement.measurement2??>
            <a href="${profileUrl(statement.measurement2)}">${statement.dimensionLabel2}: ${statement.value2} ${statement.unitLabel2}</a><br/>   

            <#if statement.measurement3??>
                <a href="${profileUrl(statement.measurement3)}">${statement.dimensionLabel3}: ${statement.value3} ${statement.unitLabel3}</a><br/>    
            </#if>
        </#if>
    </#if>
</#if>

</#macro>
