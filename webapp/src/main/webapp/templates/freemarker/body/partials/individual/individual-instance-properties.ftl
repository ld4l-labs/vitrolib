<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for property listing on individual profile page -->

		<#--  Go through list to see if properties have a faux property version - if faux property exists, hide the base property -->
		<#assign fauxHash = {} />
		<#list group.properties as prop>
			<#if prop.isFauxProperty == true && !fauxHash?keys?seq_contains(prop.uri) >
				<#assign fauxHash = fauxHash + {prop.uri:"true"} />
			</#if>
		</#list>


        <#list group.properties as property>
            <#assign rangeClass = "noRangeClass">
            <#if property.rangeUri?has_content && property.rangeUri?contains("#")>
                <#assign rangeClass = property.rangeUri?substring(property.rangeUri?last_index_of("#")+1)>
            <#elseif property.rangeUri?has_content >
                <#assign rangeClass = property.rangeUri?substring(property.rangeUri?last_index_of("/")+1)>
            </#if>
        
        	<#-- hardcoding removal of preferred title here, can put it back in when need be -->
        	<#if property.uri != "http://bibliotek-o.org/ontology/hasPreferredTitle">
        	<#--  If faux property OR regular property AND no faux property FOR that property on page -->
        	<#if (property.isFauxProperty == true) || (!property.isFauxProperty == true && !fauxHash?keys?seq_contains(property.uri))>
        
            <article class="property" role="article">
                <#-- Property display name -->
                <#if rangeClass == "Authorship" && individual.editable && (property.domainUri)?? && property.domainUri?contains("Person")>
                    <h3 id="${property.localName}-${rangeClass}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property /> 
                        <a id="managePubLink" class="manageLinks" href="${urls.base}/managePublications?subjectUri=${subjectUri[1]!}" title="${i18n().manage_publications_link}" <#if verbose>style="padding-top:10px"</#if> >
                            ${i18n().manage_publications_link}
                        </a>
                    </h3>
                <#elseif rangeClass == "ResearcherRole" && individual.editable  >
                    <h3 id="${property.localName}-${rangeClass}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property /> 
                        <a id="manageGrantLink" class="manageLinks" href="${urls.base}/manageGrants?subjectUri=${subjectUri[1]!}" title="${i18n().manage_grants_and_projects_link}" <#if verbose>style="padding-top:10px"</#if> >
                            ${i18n().manage_grants_and_projects_link}
                        </a>
                    </h3>
                <#elseif rangeClass == "Position" && individual.editable  >
                    <h3 id="${property.localName}-${rangeClass}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property /> 
                        <a id="managePeopleLink" class="manageLinks" href="${urls.base}/managePeople?subjectUri=${subjectUri[1]!}" title="${i18n().manage_affiliated_people}" <#if verbose>style="padding-top:10px"</#if> >
                            ${i18n().manage_affiliated_people_link}
                        </a>
                    </h3>
                <#elseif rangeClass == "Name" && property.statements?has_content && editable >
                    <h3 id="${property.localName}" title="${property.publicDescription!}">${property.name}  <@p.verboseDisplay property /> </h3>
                <#elseif rangeClass == "Title" && property.statements?has_content && editable >
                    <h3 id="${property.localName}" title="${property.publicDescription!}">${property.name}  <@p.verboseDisplay property /> </h3>
				<#elseif rangeClass == "Authorship" && !individual.editable && (property.domainUri)?? && property.domainUri?contains("Person")>
					<h3 id="${property.localName}-${rangeClass}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property /> </h3>
				<#elseif rangeClass == "ResearcherRole" && !individual.editable>
					<h3 id="${property.localName}-${rangeClass}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property /> </h3>
				<#else>
                    <h3 id="${property.localName}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property /> </h3>
                </#if>
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
            </#if> <!-- Not has preferred title-->
        </#list>
