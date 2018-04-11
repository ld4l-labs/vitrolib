/* $This file is distributed under the terms of the license in /doc/license.txt$ */

//In this particular case, we are using this JavaScript in the case where we are employing an external template
//And NOT generating fields
//For now, we are only using this when creating an entirely new object, but later will incorporate editing functionality as well

var hasMeasurement = {
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
	
	        },

	        // Initial page setup. Called only at page load.
	        initPage: function() {
	        	this.retrieveExistingValues();
	       
	                           
	        },
	      
	        bindEventListeners:function() {
	        //on form submit, ensure at least one measurement is filled out completely
	        	
	   	

	        },
	  
	        /**Code for retrieving existing song contents and enabling removal through links**/
	    	retrieveExistingValues:function() {
	    		//Do ajax request - reusing query from lookupConfig as it's the same idea
	    		//var query = lookupConfig["existingValuesQuery"];
	    		//Embedding query here - for one, this is slightly more complicated
	    		var query ="SELECT ?object ?m1 ?m2 ?m3 " + 
	    		"(CONCAT (?value1, ' ', ?unit1Label, ' ', ?dimension1Label) AS ?m1Label) " + 
	    		"(CONCAT (?value2, ' ', ?unit2Label, ' ', ?dimension2Label) AS ?m2Label) " + 
	    		"(CONCAT (?value3, ' ', ?unit3Label, ' ', ?dimension3Label) AS ?m3Label) " + 
	    		" WHERE { ?subject ?predicate ?object . " + 
	    		"?object <http://measurement.bibliotek-o.org/hasMeasurement> ?m1 . " + 
	    		"?m1 <http://measurement.bibliotek-o.org/hasUnit> ?unit1. ?m1 <http://measurement.bibliotek-o.org/measures> ?dimension1. ?m1 <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> ?value1 . ?unit1 <http://www.w3.org/2000/01/rdf-schema#label> ?unit1Label . ?dimension1 <http://www.w3.org/2000/01/rdf-schema#label> ?dimension1Label ." + 
	    		"OPTIONAL {?object <http://measurement.bibliotek-o.org/hasMeasurement> ?m2 . ?m2 <http://measurement.bibliotek-o.org/hasUnit> ?unit2. ?m2 <http://measurement.bibliotek-o.org/measures> ?dimension2. ?m2 <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> ?value2 . ?unit2 <http://www.w3.org/2000/01/rdf-schema#label> ?unit2Label . ?dimension2 <http://www.w3.org/2000/01/rdf-schema#label> ?dimension2Label .}" + 
	    		"OPTIONAL {?object <http://measurement.bibliotek-o.org/hasMeasurement> ?m3 . ?m3 <http://measurement.bibliotek-o.org/hasUnit> ?unit3. ?m3 <http://measurement.bibliotek-o.org/measures> ?dimension3. ?m3 <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> ?value3 . ?unit3 <http://www.w3.org/2000/01/rdf-schema#label> ?unit3Label . ?dimension3 <http://www.w3.org/2000/01/rdf-schema#label> ?dimension3Label .}" + 
	    		" FILTER(str(?m1) > str(?m2) && str(?m2) > str(?m3)) " + 
	    		"}";
	    		
	    		
	    		//Replace subject with subject URI and predicate with predicate URI
	    		query = query.replace("?subject", "<" + hasMeasurement.subjectURI + ">");
	    		query = query.replace("?predicate", "<" + hasMeasurement.predicateURI + ">");
	    		var URL = hasMeasurement.queryAJAXURL + "?query=" + encodeURIComponent(query);
	    		$.getJSON(URL, function(results) {
	    			if((results != null) && ("results" in results) && ("bindings" in results["results"])) {
	    				var bindings = results["results"]["bindings"];
	    				//Array of var name to value
	    				var len = bindings.length;
	    				
	    				var html = "";
	    				var b;
	    				for(b = 0; b < len; b++) {
	    					var binding = bindings[b];
	    					if("object" in binding) {
	    						html += hasMeasurement.generateExistingValueRow(binding);
	    					}
	    				}
	    				
	    				$("#existingMeasurements").append(html);
	    				$("#existingMeasurements").show();
	    				//Bind event listeners to existing concepts here
	    				hasMeasurement.bindExistingTermEvents();
	    			}
	    		});
	    	},
	    	generateExistingValueRow:function(binding) {
	    		var uri =  binding["object"]["value"];
	    		var measurementHtml = hasMeasurement.generateMeasurementHTML(binding, "m1", "m1Label");
	    		measurementHtml += hasMeasurement.generateMeasurementHTML(binding, "m2", "m2Label");
	    		measurementHtml += hasMeasurement.generateMeasurementHTML(binding, "m3", "m3Label");

				
	    		var html = "<li class='existingConcept conceptsListContainer'>" + 
	                "<div class='container'>" + 
	                    "<div class='row'>" + 
	                        "<div class='col-12'>" + 
	                            "<div class='column conceptLabelInfo'>" + measurementHtml   + "</div>" + 
	                            "<div class='column conceptRemoval'>" + 
	                                "<a href='" + hasMeasurement.primitiveEdit + "' class='remove' title='remove' uri='" + uri + "'>Remove</a>" + 
	                            "</div>" + 
	                        "</div>" + 
	                    "</div>" + 
	                "</div>" + 
	            "</li>";
	    		return html;
	    	},
	    	generateMeasurementHTML(binding, muri, mlabel) {
	    		var measurementHtml = " ";
				if(muri in binding && mlabel in binding) {
					var uri = binding[muri]["value"];
					var label = binding[mlabel]["value"];
					var openURL = hasMeasurement.baseHref + uri;
					measurementHtml += "<a href='" + openURL + "'>" + label + "</a>";
				}
				return measurementHtml;
	    	},
	    	bindExistingTermEvents:function() {
	    		//Bind opening of auth
	    		/*$("#existingParts a.openAuth").click(function(e) {
	    			var uri = $(this).attr("uri");
	        		hasMeasurement.openAuthURL(uri, e);
	                return false;
	    		});*/
	    		$("a.remove").click(function() {
	                hasMeasurement.removeExistingPart(this);
	                return false;
	       	 	});
	    	},
	    	openAuthURL:function(uri, e) {
	    		//open new window with 
	    		 window.open(uri);
	    		 e.preventDefault();
	    	},
	    	 removeExistingPart: function(link) {
		            var removeLast = false,
		                message = "Are you sure you wish to remove this measurement group?";
		                
		            if (!confirm(message)) {
		                return false;
		            }
		            
		            if ($(link)[0] === $('.remove:last')[0]) {
		                removeLast = true;
		            } 
		            //Using primitive rdf edit which expects an n3 string for deletion
		            $.ajax({
		                url: $(link).attr('href'),
		                type: 'POST', 
		                data: {
		            		additions: '', 
		                    retractions: hasMeasurement.generateDeletionN3($(link).attr("uri"))
		                },
		                dataType: 'json',
		                context: link, // context for callback
		                complete: function(request, status) {
		                    var existingConcept,
		                        conceptNodeUri;
		                
		                    if (status === 'success') {
		                        
		                        existingConcept = $(this).parents('.existingConcept');
		                        existingConcept.fadeOut(400, function() {
		                            var numConcepts;
		                            // For undo link: add to a deletedAuthorships array
		                            // Remove from the DOM                       
		                            $(this).remove();
		                            // Actions that depend on the author having been removed from the DOM:
		                            numConcepts = $('.existingConcept').length; // retrieve the length after removing authorship from the DOM        
		                        });

		                    } else {
		                        alert("Error removing part");
		                    }
		                }
		            });     
	    	 }, 
	    	 generateDeletionN3: function(conceptNodeUri) {
		        	var n3String = "<" + hasMeasurement.subjectURI + "> <" + hasMeasurement.predicateURI + "> <" + conceptNodeUri + "> .";
		        	return n3String;
		     }
	        /*,
	        //On submit, if existing URI selected, then add >submitted value was blank< for any
	        //fields that require a new resource: 
	        eliminateNewResourceURIsForExistingWork:function() {
	        	//if none of the items for activity, 
	        }*/
	        

};

$(document).ready(function() {   
    hasMeasurement.onLoad();
}); 