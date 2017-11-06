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

    <div>
      <#-- Show this WHEN logged in, otherwise show VitroLib information -->
      <h2>${i18n().catalog_new_resource} <sup><a href="#" title="${i18n().overview_model}"><i class="fa fa-question-circle-o"></i></a></sup></h2>
	
		<#-- Commenting out for test purposes and including link to html form for now -->
      <a class="blue button workform-button" href="${urls.base}/editRequestDispatch?editForm=edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.generators.MinimalEditConfigurationGenerator&classURI=http%3A%2F%2Fid.loc.gov%2Fontologies%2Fbibframe%2FWork"">${i18n().work} <i class="fa fa-plus workform-button__icon"></i></a>

      <#-- a class="blue button workform-button" href="${urls.base}/editRequestDispatch?editForm=edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.generators.MinimalEditConfigurationGenerator&classURI=http%3A%2F%2Fid.loc.gov%2Fontologies%2Fbibframe%2FInstance"">${i18n().instance} <i class="fa fa-plus workform-button__icon"></i></a-->
       <#-- a class="blue button workform-button" href="${urls.base}/templates/freemarker/edit/forms/addNewWorkTest.html">${i18n().work}  <i class="fa fa-plus workform-button__icon"></i></a>

      
    </div>

    <section id="intro" role="region">
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
