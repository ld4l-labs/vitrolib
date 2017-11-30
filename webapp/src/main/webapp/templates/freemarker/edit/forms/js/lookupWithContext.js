/* $This file is distributed under the terms of the license in /doc/license.txt$ */

//In this particular case, we are using this JavaScript in the case where we are employing an external template
//And NOT generating fields
//For now, we are only using this when creating an entirely new object, but later will incorporate editing functionality as well

var lookupWithContext = {
		  onLoad: function() {
	    	 	this.mixIn();  
	    	 	this.initObjects();
	    	 	this.initPage();
	    	 	this.bindEventListeners();
	            
	        },
	        mixIn: function() {

	            // Get the custom form data from the page
	            $.extend(this, customFormData);
	            $.extend(this, i18nStrings);
	        },
	        
	        initObjects:function() {
	        	this.searchSubmit = $("#searchButton");
	        	 this.searchTerm = $('#searchTerm');
	        	 this.maxNumberAlternateLabels = 4;
	        	 this.showHideSearchResults = $("#showHideResults");
	        },

	        // Initial page setup. Called only at page load.
	        initPage: function() {
	        	
	                           
	        },
	      
	        bindEventListeners:function() {
	        	this.searchSubmit.click(function() {
	        		//lookupWithContext.clearErrors();
	                lookupWithContext.submitSearchTerm();
	                return false;
	        	});
	        },
	        submitSearchTerm: function() {
	        	//Get value of search term
	        	var searchValue = this.searchTerm.val();
	        	var dataServiceUrl = lookupWithContext.dataServiceUrl + "&searchTerm=" + encodeURIComponent(searchValue);
	            //Show the loading icon until the results appear
	        	//lookupWithContext.loadingIndicator.removeClass("hidden");
	        	//remove the old search results if there are any
	        	//$("#selectedConcept").empty();
	        	//Hide and reset the show more button
	        	//lookupWithContext.resetShowHideMultipleSearchResults();
	        	//This should return an object including the concept list or any errors if there are any
	        	$.getJSON(dataServiceUrl, function(results) {
	                var htmlAdd = "";
	                var vocabUnavailable = "<p>" + lookupWithContext.vocServiceUnavailable + "</p>";
	                if ( results== null  || results.semanticServicesError != null || results.conceptList == null) {
	                	htmlAdd = vocabUnavailable;
	                }
	                else {
	                	//array is an array of objects representing concept information
	                	//loop through and find all the best matches
	                	var allResults = [];
	                	if("conceptList" in results) {
	                		allResults = results.conceptList;
	                	}
	                	var numberTotalMatches = allResults.length;
	                	  if(numberTotalMatches > 0) {
		                    	htmlAdd = "<div class='container'><ul class='dd' id='concepts' name='concepts'>";
		                    	htmlAdd+= lookupWithContext.addResultsHeader();
		                    	//No division between "best" and "alternate" such as in VIVO so loop through all results
		    	                for(i = 0; i < numberTotalMatches; i++) {
		    	                	var conceptResult = allResults[i];
		    	                	htmlAdd+= lookupWithContext.displayConceptSearchResult(conceptResult);
		    	                }
		    	               
		    	                htmlAdd+= "</ul></div>";
		                    } else {
		                    	htmlAdd+= "<p>No Results Found</p>";
		                    }
	                	
	                
	                }
	                
	                if(htmlAdd.length) {
	                	//hide the loading icon again
	                	//lookupWithContext.loadingIndicator.addClass("hidden");
	                	$('#selectedConcept').html(htmlAdd);
	                	if (htmlAdd.indexOf("No search results") >= 0) {
	                		//lookupWithContext.showHiddenElements(hasResults);
	                	}
	                	else {
	                	   hasResults = true;
	                	   $('#selectedConcept').show();
	                	   //lookupWithContext.showHiddenElements(hasResults);
	                       //Here, tweak the display based on the number of results
	                	   //lookupWithContext.displayUptoMaxResults();
	                	   //lookupWithContext.showHideSearchResults.show();
	                    }
	                }
	                
	                
	              });
	              
	            return true;
	        },
	        
	        addResultsHeader:function() {
	        	var htmlAdd = "<li class='concepts'><div class='row'><div class='col-12'><span class='column conceptLabel'>" +
	        	"Genre Form" + " </span><span class='column conceptDefinition'>Definition</span><span class='column additionalInfo'>Additional Info</span></div></div></li>";
	        	return htmlAdd;
	    },
	    displayConceptSearchResult:function(conceptResult) {
	    	var conceptId = conceptResult.conceptId;
	    	var label = conceptResult.label;
	    	var definition = conceptResult.definition;
	    	var definedBy = conceptResult.definedBy;
	    	var type = conceptResult.type;
	    	var uri = conceptResult.uri;
	    	//also adding broader and narrower uris wherever they exist
	    	var broaderUris = conceptResult.broaderURIList;
	    	var narrowerUris = conceptResult.narrowerURIList;
	    	var exactMatchUris = conceptResult.exactMatchURIList;
	    	//this will be null if there are no alternate labels
	    	var altLabels = conceptResult.altLabelList;
	    	return lookupWithContext.generateIndividualConceptDisplay(uri, label, altLabels, definition, type, definedBy, broaderUris, narrowerUris, exactMatchUris);
	},
	 generateIndividualConceptDisplay: function(cuiURI, label, altLabels, definition, type, definedBy, broaderUris, narrowerUris, exactMatchUris) {
	    	var htmlAdd = "<li class='concepts'>" + 
	    	"<div class='row'>" +
	        "<div class='col-12'>" +
	    	"<div class='column conceptLabel'>" +
	    	lookupWithContext.generateIndividualCUIInput(cuiURI, label, type, definedBy, broaderUris, narrowerUris) +  
	    	lookupWithContext.generateIndividualLabelsDisplay(label, altLabels) + lookupWithContext.generateIndividualTypeDisplay(type) + "</div>" + 
	    	lookupWithContext.generateIndividualDefinitionDisplay(definition) +
	    	lookupWithContext.generateIndividualAdditionalInfoDisplay(broaderUris, narrowerUris, exactMatchUris) +
	    	"</div>" +
	        "</div>" +
	        "</li>";
	    	return htmlAdd;
	    }, 
	    generateIndividualCUIInput:function(cuiURI, label, type, definedBy, broaderUris, narrowerUris) {
	    	return 	"<input type='checkbox'  name='CUI' value='" + cuiURI + "' label='" + 
	    		label + "' conceptType='" + type + "' conceptDefinedBy='" + definedBy + "' " +
	    		"broaderUris='" + broaderUris + "' narrowerUris='" + narrowerUris + "'/>";
	    },
	    //In case there are multiple labels display those
	    generateIndividualLabelsDisplay:function(label, altLabels) {
	    	var labelDisplay = label;
	    	var displayAltLabels = altLabels;
	    	if(altLabels != null && altLabels.length > 0) {
	    		//Certain vocabulary services might return a long list of alternate labels, in which case we will show fewer 
	    		//display only upto a certain number of alternate labels and use an ellipsis to signify there
	    		//are additional terms
	    		if(altLabels.length > lookupWithContext.maxNumberAlternateLabels) {
	    			displayAltLabels = altLabels.slice(0, lookupWithContext.maxNumberAlternateLabels) + ",...";
	    		}
	    		labelDisplay += "<br> (" + displayAltLabels + ")";
	    	}
	    	return labelDisplay;
	    },
	    generateIndividualTypeDisplay:function(type) {
	    	if(type != null && type.length > 0) {
	    		return " (" + type + ")";
	    	}
	    	return "";
	    },
	    generateIndividualDefinitionDisplay:function(definition) {
	    	//The definition in some cases may be an empty string, so to prevent the div
	    	//from not appearing, we are replacing with 
	    	if(definition == null || definition.length == 0) {
	    		//definition = "&nbsp;";
	    		definition = "No definition provided.";
	    	}
	    	return "<div class='column conceptDefinition'>" + definition + "</div>";
	},
	generateIndividualAdditionalInfoDisplay:function(broaderUris, narrowerUris, exactMatchUris) {
		var htmlAdditionalInfo = "";
		if(broaderUris != null && broaderUris.length > 0) {
    		var b;
    		htmlAdditionalInfo = "<b>Broader:</b> <br/>";
    		htmlAdditionalInfo += lookupWithContext.generateRelatedURIsDisplay(broaderUris);
    	}
		if(narrowerUris != null && narrowerUris.length > 0) {
    		var b;
    		htmlAdditionalInfo = "<b>Narrower:</b> <br/>";
    		htmlAdditionalInfo += lookupWithContext.generateRelatedURIsDisplay(narrowerUris);
    	}
		if(exactMatchUris != null && exactMatchUris.length > 0) {
    		var b;
    		htmlAdditionalInfo = "Exact Match: <br/>";
    		htmlAdditionalInfo += lookupWithContext.generateRelatedURIsDisplay(exactMatchUris);
    	}
    	return "<div class='column additionalInfo'>" + htmlAdditionalInfo + "</div>";
		
	},
	
	//relatedURIs are of the format [ {uri: , id: , label: }]
	generateRelatedURIsDisplay:function(relatedURIs) {
		var htmlAdd = "";
		var len = relatedURIs.length;
		var i;
		for(i = 0; i < len; i++) {
			var uriInfo = relatedURIs[i];
			var label = uriInfo["label"];
			var uri = uriInfo["uri"];
			if(i != 0) {
				htmlAdd += "<br/>";
			}
			htmlAdd += "<a href='" + uri + "'>" + label + "</a>";
		}
		return htmlAdd;
	}
	
	        

};

$(document).ready(function() {   
    lookupWithContext.onLoad();
}); 