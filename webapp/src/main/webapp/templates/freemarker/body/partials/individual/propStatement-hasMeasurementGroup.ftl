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
        <#local unitLabel1 = getUnits(statement.value1, statement.unitLabel1)>
        - <a href="${profileUrl(statement.measurement1)}">${statement.dimensionLabel1?cap_first}: ${statement.value1} ${unitLabel1}</a><br/> 

        <#if statement.measurement2??>
            <#local unitLabel2 = getUnits(statement.value2, statement.unitLabel2)>
            - <a href="${profileUrl(statement.measurement2)}">${statement.dimensionLabel2?cap_first}: ${statement.value2} ${unitLabel2}</a><br/>   

            <#if statement.measurement3??>
                <#local unitLabel3 = getUnits(statement.value2, statement.unitLabel3)>
                - <a href="${profileUrl(statement.measurement3)}">${statement.dimensionLabel3?cap_first}: ${statement.value3} ${unitLabel3}</a><br/>    
            </#if>
        </#if>
    </#if>
</#if>

</#macro>

<#function getUnits value unitLabel>
    <#return getNumber(value, lowercase(unitLabel))>
</#function>

<#function getNumber value label>
    <#if value?number == 1>
        <#return label>
    </#if>

    <#switch label>
        <#case "foot">
            <#return "feet">
        <#case "inch">
            <#return "inches">
        <#case "mile US statute">
            <#return "miles US statute">
        <#case "ounce mass">
            <#return "ounces mass"> 
        <#case "pound mass">
            <#return "pounds mass"> 
        <#default>
            <#return label + "s"> 
    </#switch>
</#function>

<#function lowercase label>

    <#switch label>
         <#case "Mile US Statute">
            <#return "mile US statute">
        <#case "Metric Ton">
            <#return "metric ton">
        <#case "Ounce Mass">
            <#return "ounce mass">
        <#case "Pound Mass">
            <#return "pound mass"> 
        <#default>
            <#return label?lower_case>    
    </#switch>
</#function>
