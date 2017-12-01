<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for property listing on individual profile page -->

		<#--  Go through list to see if properties have a faux property version - if faux property exists, hide the base property -->
		<#assign fauxHash = {} />
			<#--  List of hash objects to enable faux property display as well -->
			<#--  -
		<#assign propertyInfoList = [ {"baseUri":"http://bibliotek-o.org/ontology/hasActivity", "rangeUri":"http://bibliotek-o.org/ontology/Activity"},
		{"baseUri":"http://id.loc.gov/ontologies/bibframe/hasInstance"},
		{"baseUri":"http://purl.org/dc/terms/subject", "rangeUri":"http://www.w3.org/2002/07/owl#Thing", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work"},
		{"baseUri":"http://id.loc.gov/ontologies/bibframe/genreForm", "rangeUri":"http://id.loc.gov/ontologies/bibframe/GenreForm", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work"},
		{"baseUri":"http://purl.org/dc/terms/hasPart", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work","domainUri":"http://id.loc.gov/ontologies/bibframe/Work"},
		{"baseUri":"http://bibliotek-o.org/ontology/isTargetOf", "rangeUri":"http://www.w3.org/ns/oa#Annotation","domainUri":"http://id.loc.gov/ontologies/bibframe/Work"}
		] />
		-->
		
		<#assign propertyInfoList = [
		{"baseUri":"http://bibliotek-o.org/ontology/hasActivity", "rangeUri":"http://bibliotek-o.org/ontology/Activity"},
		{"baseUri":"http://id.loc.gov/ontologies/bibframe/hasInstance"},
		{"baseUri":"http://purl.org/dc/terms/subject", "rangeUri":"http://www.w3.org/2002/07/owl#Thing", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work"},
		{"baseUri":"http://id.loc.gov/ontologies/bibframe/genreForm", "rangeUri":"http://id.loc.gov/ontologies/bibframe/GenreForm", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work"},
		{"baseUri":"http://purl.org/dc/terms/hasPart", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work","domainUri":"http://id.loc.gov/ontologies/bibframe/Work"},
		{"baseUri":"http://rdaregistry.info/Elements/u/P60242", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Audio"},
		{"baseUri":"http://bibliotek-o.org/ontology/covers", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Temporal"},
{"baseUri":"http://bibliotek-o.org/ontology/covers", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://www.w3.org/ns/prov#Location"},
{"baseUri":"http://bibliotek-o.org/ontology/hasPreferredTitle", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Title"},
{"baseUri":"http://bibliotek-o.org/ontology/isSubjectOf", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/accompaniedBy", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/accompanies", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/contentAccessibility", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/ContentAccessibility"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/dataSource", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Dataset"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/genreForm", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://www.w3.org/2004/02/skos/core#Concept"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/hasExpression", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/referencedBy", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/references", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://purl.org/dc/terms/hasPart", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://purl.org/dc/terms/isPartOf", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://purl.org/dc/terms/subject", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://www.w3.org/2002/07/owl#Thing"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60088", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60102", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60104", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60106", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Text"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60110", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/MovingImage"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60138", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Text"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60177", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Audio"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60178", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Text"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60180", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/NotetatedMovement"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60185", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Text"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60188", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Text"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60189", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60199", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60203", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60205", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60214", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60216", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60220", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60224", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60225", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60238", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60241", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60242", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Audio"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60243", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60244", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60245", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60246", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60247", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60248", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60250", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60260", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60274", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Audio"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60275", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60276", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60277", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60278", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60279", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60280", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60289", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60293", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/NotatedMovement"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60295", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60296", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60303", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60305", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60306", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60308", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60309", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60310", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60311", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60312", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60354", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/MovingImage"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60361", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/MovingImage"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60480", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60503", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60504", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60505", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60574", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60575", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60576", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60577", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60743", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60831", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/NotatedMusic"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60832", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60833", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://schema.org/recordedAt", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://www.w3.org/2002/07/owl#Thing"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/title", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Title"}
		

		
		] />
		

		<#-- 		{"baseUri":"http://purl.org/dc/terms/hasPart", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work","domainUri":"http://id.loc.gov/ontologies/bibframe/Work"},
 -->
       <#assign propertiesList = []/>
		<#list group.properties as prop>
			<#if prop.isFauxProperty == true && !fauxHash?keys?seq_contains(prop.uri) >
				<#assign fauxHash = fauxHash + {prop.uri:"true"} />
			</#if>
		</#list>
			<#--Create properties list-->
		<#list propertyInfoList as propertyInfo>
			<#list group.properties as prop>
				<#if prop.isFauxProperty == true && !fauxHash?keys?seq_contains(prop.uri) >
					<#if propertyInfo.baseUri == prop.uri && propertyInfo.rangeUri == prop.rangeUri>
						<#assign propertiesList = propertiesList + [prop] />
					</#if>
				<#else>
					<#if propertyInfo.baseUri == prop.uri>
						<#assign propertiesList = propertiesList + [prop] />
					</#if>
				</#if>
			</#list>
		</#list>	
			
		<#--  List of hash objects to enable faux property display as well -->
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
