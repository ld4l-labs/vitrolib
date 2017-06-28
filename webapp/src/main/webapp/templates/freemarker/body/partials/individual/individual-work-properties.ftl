<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for property listing on individual profile page -->

		<#--  Go through list to see if properties have a faux property version - if faux property exists, hide the base property -->
		<#assign fauxHash = {} />
			<#--  List of hash objects to enable faux property display as well -->
		<#assign propertyInfoList = [ {"baseUri":"http://bibliotek-o.org/ontology/hasActivity", "rangeUri":"http://bibliotek-o.org/ontology/Activity"}] />
       <#assign propertiesList = []/>
		<#list group.properties as prop>
			<#if prop.isFauxProperty == true && !fauxHash?keys?seq_contains(prop.uri) >
				<#assign fauxHash = fauxHash + {prop.uri:"true"} />
				<#list propertyInfoList as propertyInfo>
					<#if propertyInfo.baseUri == prop.uri && propertyInfo.rangeUri == prop.rangeUri>
						<#assign propertiesList = propertiesList + [prop] />
					</#if>
				</#list>
				
			</#if>
			
		</#list>
		<#--  List of hash objects to enable faux property display as well -->
		<#assign propertyInfoList = [ {"baseUri":"http://bibliotek-o.org/ontology/hasActivity", "rangeUri":"http://bibliotek-o.org/ontology/Activity"}] />
        <#--  --list group.properties as property-->
        <#list propertiesList as property>
			
            <#assign rangeClass = "noRangeClass">
            <#if property.rangeUri?has_content && property.rangeUri?contains("#")>
                <#assign rangeClass = property.rangeUri?substring(property.rangeUri?last_index_of("#")+1)>
            <#elseif property.rangeUri?has_content >
                <#assign rangeClass = property.rangeUri?substring(property.rangeUri?last_index_of("/")+1)>
            </#if>
        
        	
        	<#--  If faux property OR regular property AND no faux property FOR that property on page -->
        	<#if (property.isFauxProperty == true) || (!property.isFauxProperty == true && !fauxHash?keys?seq_contains(property.uri))>
        
            <article class="property" role="article">
                <#-- Property display name -->
              
                    <h3 id="${property.localName}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property /> </h3>
                
                <#-- List the statements for each property -->
					<#assign limit = property.getDisplayLimit()!5 />
					<#if limit == -1 || limit == 0 >
						<#assign limit = 5 />
					</#if>
                <ul class="property-list" role="list" id="${property.localName}-${rangeClass}-List" displayLimit="${limit}">
                	<#-- Only display if the URI doesn't already have a faux property we want to show on the same page -->
                	
	                    <#-- data property -->
                    <#if property.type == "data">
                        <@p.dataPropertyList property editable />
                    <#-- object property -->
                    <#else>
                        <@p.objectProperty property editable /> 
                    </#if>
                    
                </ul>
            </article> <!-- end property -->
            </#if>
        </#list>
