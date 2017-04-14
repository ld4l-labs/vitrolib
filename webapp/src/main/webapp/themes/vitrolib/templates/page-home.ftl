<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<@widget name="login" include="assets" />
<#import "lib-home-page.ftl" as lh>

<!DOCTYPE html>
<html lang="en">
    <head>
        <#include "head.ftl">
    </head>
    
    <body class="${bodyClasses!}">
        <#include "identity.ftl">
        
        <#include "menu.ftl">
        
            <section id="intro" role="region">
            
            <section id="catalogNew" role="region">
            <#-- Show this WHEN logged in, otherwise show VitroLib information -->
              <h2>${i18n().catalog_new_resource} <sup><a href="#">${i18n().overview_model}</a></sup></h2>
              <div class="row">
              <div class="column">
              <form id="addNewWork" action="${urls.base}/editRequestDispatch" method="get">
	            <input type="hidden" name="editForm" value="edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.generators.MinimalEditConfigurationGenerator" role="input" />
	            <input type="hidden" name="classURI" value="http://id.loc.gov/ontologies/bibframe/Work"/>
	            <input type="submit" id="submit" value="${i18n().work}" role="button" />
        	</form>
              </div>
              <div class="column">
              <form id="addNewInstance" action="${urls.base}/editRequestDispatch" method="get">
	            <input type="hidden" name="editForm" value="edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.generators.MinimalEditConfigurationGenerator" role="input" />
	            <input type="hidden" name="classURI" value="http://id.loc.gov/ontologies/bibframe/Instance"/>
	            <input type="submit" id="submit" value="${i18n().instance}" role="button" />
        	</form>
        	</div>
        	</div>
              
              </section>
                <section id="search-home" role="region">
                    <h3>${i18n().search_vitro} <span class="search-filter-selected">filteredSearch</span></h3>
                    
                    <fieldset>
                        <legend>${i18n().search_form}</legend>
                        <form id="search-homepage" action="${urls.search}" name="search-home" role="search" method="post" > 
                            <div id="search-home-field">
                                <input type="text" name="querytext" class="search-homepage" value="${querytext!}" autocapitalize="off" />
                                <input type="submit" value="${i18n().search_button}" class="search" />
                                <input type="hidden" name="classgroup" class="search-homepage" value="" autocapitalize="off" />
                            </div>
                            
                            <a class="filter-search filter-default" href="#" title="${i18n().filter_search}"><span class="displace">${i18n().filter_search}</span></a>
                            
                            <ul id="filter-search-nav">
                                <li><a class="active" href="">${i18n().all_capitalized}</a></li>
                                <@lh.allClassGroupNames vClassGroups! />
                            </ul>
                        </form>
                    </fieldset>
                </section> <!-- #search-home -->
                
            </section> <!-- #intro -->
            
            
            
            <@widget name="login" />
                        
            <!-- Statistical information relating to property groups and their classes; displayed horizontally, not vertically-->
            <@lh.allClassGroups vClassGroups! />
        
        <#include "footer.ftl">
        <script>
            // this will ensure that the hidden classgroup input is cleared if the back button is used
            // to return to the home page from the search results. Not in vitroUtils.js because that
            // gets loaded on every page.
            $(document).ready(function(){
                $('input[name="classgroup"]').val("");    
            });
        </script>
    </body>
</html>