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
        <#assign unitLabel1 = getUnits(statement.value1, statement.unitLabel1)>
        <a href="${profileUrl(statement.measurement1)}">${statement.dimensionLabel1}: ${statement.value1} ${unitLabel1}</a><br/> 

        <#if statement.measurement2??>
            <#assign unitLabel2 = getUnits(statement.value2, statement.unitLabel2)>
            <a href="${profileUrl(statement.measurement2)}">${statement.dimensionLabel2}: ${statement.value2} ${unitLabel2}</a><br/>   

            <#if statement.measurement3??>
                <#assign unitLabel3 = getUnits(statement.value2, statement.unitLabel3)>
                <a href="${profileUrl(statement.measurement3)}">${statement.dimensionLabel3}: ${statement.value3} ${unitLabel3}</a><br/>    
            </#if>
        </#if>
    </#if>
</#if>

</#macro>

<#function getUnits value unitLabel>

    <#if value?number == 1>
        <#return unitLabel>
    </#if>

    <#switch unitLabel>
        <#case "Foot">
            <#return "Feet">
        <#case "Inch">
            <#return "Inches">
        <#case "Mile US Statute">
            <#return "Miles US Statute">
        <#case "Ounce Mass">
            <#return "Ounces Mass"> 
        <#case "Pound Mass">
            <#return "Pounds Mass"> 
        <#default>
            <#return unitLabel + "s"> 
    </#switch>


</#function>
