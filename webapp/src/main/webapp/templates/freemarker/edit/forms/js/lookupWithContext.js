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
	        },

	        // Initial page setup. Called only at page load.
	        initPage: function() {
	        	
	                           
	        },
	      
	        bindEventListeners:function() {
	        	this.searchSubmit.click(function() {
	        		//addConceptForm.clearErrors();
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
	        	//addConceptForm.resetShowHideMultipleSearchResults();
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
	                	//var allResults = lookupWithContext.parseResults(results.conceptList);
	                	/*
	                	var bestMatchResults = allResults["bestMatch"];
	                	var alternateResults = allResults["alternate"];
	                    var numberBestMatches = bestMatchResults.length;
	                    var numberAlternateMatches = alternateResults.length;
	                	var numberTotalMatches = numberBestMatches + numberAlternateMatches;

	                    var i;
	                    //For each result, display
	                    if(numberTotalMatches > 0) {
	                    	htmlAdd = "<div class='container'><ul class='dd' id='concepts' name='concepts'>";
	                    	htmlAdd+= addConceptForm.addResultsHeader(vocabSourceValue);
	                    	//Show best matches first
	    	                for(i = 0; i < numberBestMatches; i++) {
	    	                	var conceptResult = bestMatchResults[i];
	    	                	htmlAdd+= addConceptForm.displayConceptSearchResult(conceptResult, true);
	    	                }
	    	                //If any alternate matches, show that next
	    	                for(i = 0; i < numberAlternateMatches; i++) {
	    	                	var conceptResult = alternateResults[i];
	    	                	htmlAdd+= addConceptForm.displayConceptSearchResult(conceptResult, false);
	    	                }
	    	                htmlAdd+= "</ul></div>";
	                    } else {
	                    	htmlAdd+= "<p>" + addConceptForm.noResultsFound + "</p>";
	                    }
	                	*/
	                }
	                /*
	                if(htmlAdd.length) {
	                	//hide the loading icon again
	                	lookupWithContext.loadingIndicator.addClass("hidden");
	                	$('#selectedConcept').html(htmlAdd);
	                	if (htmlAdd.indexOf("No search results") >= 0) {
	                		lookupWithContext.showHiddenElements(hasResults);
	                	}
	                	else {
	                	   hasResults = true;
	                	   lookupWithContext.showHiddenElements(hasResults);
	                       //Here, tweak the display based on the number of results
	                	   lookupWithContext.displayUptoMaxResults();
	                    }
	                }
	                
	                */
	              });
	              
	            return true;
	        }
	        

};

$(document).ready(function() {   
    lookupWithContext.onLoad();
}); 