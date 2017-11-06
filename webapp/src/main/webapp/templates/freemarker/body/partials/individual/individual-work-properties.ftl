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
		{"baseUri":"http://rdaregistry.info/Elements/u/P60242", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Audio"}

		
		] />
		
		<#--  
		{"baseUri":"http://bibliotek-o.org/ontology/isTargetOf", "rangeUri":"http://www.w3.org/ns/oa#Annotation","domainUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://bibliotek-o.org/1.1/ontology/covers", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Temporal"},
{"baseUri":"http://bibliotek-o.org/1.1/ontology/covers", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://www.w3.org/ns/prov#Location"},
{"baseUri":"http://bibliotek-o.org/1.1/ontology/hasPreferredTitle", "domainUri":"http://id.loc.gov/ontologies/bibframe/Work", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Title"},
{"baseUri":"http://bibliotek-o.org/1.1/ontology/isSubjectOf", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/accompaniedBy", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/accompanies", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/contentAccessibility", "rangeUri":"http://id.loc.gov/ontologies/bibframe/ContentAccessibility"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/dataSource", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Dataset"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/hasExpression", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/referencedBy", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://id.loc.gov/ontologies/bibframe/references", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://purl.org/dc/terms/isPartOf", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60088", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60102", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60104", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60106", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Text"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60110", "rangeUri":"http://id.loc.gov/ontologies/bibframe/MovingImage"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60138", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Text"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60177", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Audio"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60178", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Text"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60180", "rangeUri":"http://id.loc.gov/ontologies/bibframe/NotetatedMovement"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60185", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Text"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60188", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Text"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60189", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60199", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60203", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60205", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60214", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60216", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60220", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60224", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60225", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60238", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60241", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60242", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Audio"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60243", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60244", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60245", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60246", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60247", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60248", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60250", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60260", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60274", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Audio"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60275", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60276", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60277", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60278", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60279", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60280", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60289", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60293", "rangeUri":"http://id.loc.gov/ontologies/bibframe/NotatedMovement"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60295", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60296", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60303", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60305", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60306", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60308", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60309", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60310", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60311", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60312", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60354", "rangeUri":"http://id.loc.gov/ontologies/bibframe/MovingImage"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60361", "rangeUri":"http://id.loc.gov/ontologies/bibframe/MovingImage"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60480", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60503", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60504", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60505", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60574", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60575", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60576", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60577", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60743", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60831", "rangeUri":"http://id.loc.gov/ontologies/bibframe/NotatedMusic"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60832", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"},
{"baseUri":"http://rdaregistry.info/Elements/u/P60833", "rangeUri":"http://id.loc.gov/ontologies/bibframe/Work"}
		] />
		-->
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
