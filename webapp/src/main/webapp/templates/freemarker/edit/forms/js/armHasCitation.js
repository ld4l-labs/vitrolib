/* $This file is distributed under the terms of the license in /doc/license.txt$ */

//In this particular case, we are using this JavaScript in the case where we are employing an external template
//And NOT generating fields
//For now, we are only using this when creating an entirely new object, but later will incorporate editing functionality as well

var armHasCitation = {
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
	        	this.actionType = $("input[name='actionType']");
	        	this.createNewLocation = $("#createNewLocation");
	        	this.lookupLocation = $("#lookupLocation");
	        	this.locationTypeDropdown = $("#locationType");//this is hidden on load - will the jquery selector pick it up
	        	this.locationValueSection = $("#locationValueSection");
	        	this.locationTitleSection = $("#locationTitleSection");
	        	this.formSubmit = $("input#submit");
	        },

	        // Initial page setup. Called only at page load.
	        initPage: function() {
	        	this.retrieveExistingValues();
	                           
	        },
	      
	        bindEventListeners:function() {
	        	
	        	//If create new chosen, then show lookupType
	        	this.actionType.change(function() {
	        		var actionTypeVal = $(this).val();
	        		if(actionTypeVal == "create") {
	        			armHasCitation.lookupLocation.hide();
	        			armHasCitation.createNewLocation.show();
	        		}
	        		else {
	        			armHasCitation.lookupLocation.show();
	        			armHasCitation.createNewLocation.hide();
	        		}
	        	});
	        	
	        	this.locationTypeDropdown.change(function() {
	        		var locationTypeVal = $(this).val();
	        		if(locationTypeVal == "") {
	        			armHasCitation.locationTitleSection.hide();
	        			armHasCitation.locationValueSection.hide();
	        		} else if(locationTypeVal == "http://id.loc.gov/ontologies/bibframe/Instance") {
	        			armHasCitation.locationTitleSection.show();
	        			armHasCitation.locationValueSection.hide();
	        		} else {
	        			armHasCitation.locationTitleSection.hide();
	        			armHasCitation.locationValueSection.show();
	        			
	        		}
	        	});
	        	
	        	this.formSubmit.click(function() {
	        		armHasCitation.clearLocationValues();
	        		return true;
	        	});
	        	
	           
	        },
	       clearLocationValues:function() {
	        	//Based on selection, clear other values
	    	   var actionTypeValue = $("input[name='actionType']:checked").val();
	    	   if(actionTypeValue == "create") {
	    		   //if create, then get rid of any uris for location
	    		   $("#location").val("");
	    	   } else {
	    		   $("#locationType").val("");
	    		   $("#locationValue").val("");
	    		   $("#locationPreferredTitle").val("");
	    	   }
	        },
	        //Existing values - need to put this in its own javascript file
	        /**Code for retrieving existing song contents and enabling removal through links**/
	    	retrieveExistingValues:function() {
	    		//Do ajax request - reusing query from lookupConfig as it's the same idea
	    		//Could make this more involved but keeping it simple for now
	    		var query = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>  " + 
	    		"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> " + 
	    		"PREFIX arm: <https://w3id.org/arm/core/ontology/0.1/> " + 
	    		"PREFIX bibframe: <http://id.loc.gov/ontologies/bibframe/> " + 
	    		"SELECT DISTINCT ?object ?noteValue ?entryValue ?location ?locationLabel  " + 
	    		"WHERE {?subject ?predicate ?object ." + 
	    		" OPTIONAL {?object bibframe:note ?note . ?note rdf:value ?noteValue .} " + 
	    		" OPTIONAL{ ?object arm:hasSource ?entry . ?entry rdf:value ?entryValue . " + 
	    		" OPTIONAL {?object arm:hasSource ?entry . ?entry arm:atLocation ?location . ?location rdfs:label ?locationLabel .}} }" + 
	    		"ORDER BY ?object ?entryValue ?locationLabel";
	    		//Replace subject with subject URI and predicate with predicate URI
	    		query = query.replace("?subject", "<" + armHasCitation.subjectURI + ">");
	    		query = query.replace("?predicate", "<" + armHasCitation.predicateURI + ">");
	    		var URL = armHasCitation.queryAJAXURL + "?query=" + encodeURIComponent(query);
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
	    						var uri = binding["object"]["value"];
	    						var label = "";
	    						var labelValues = [];
	    						if("location" in binding && "locationLabel" in binding && "value" in binding["locationLabel"]) labelValues.push("Source:" + binding["locationLabel"]["value"]);
	    						if("entryValue" in binding && "value" in binding["entryValue"]) labelValues.push("Entry value:" + binding["entryValue"]["value"]);
	    						if("noteValue" in binding && "value" in binding["noteValue"]) labelValues.push("Note:" + binding["noteValue"]["value"]);
	    						label = labelValues.join(", ");
	    						html += armHasCitation.generateExistingValueRow(uri, label);
	    						
	    					}
	    				}
	    				
	    				$("#existingCitations").append(html);
	    				$("#existingCitations").show();
	    				//Bind event listeners to existing concepts here
	    				armHasCitation.bindExistingTermEvents();
	    			}
	    		});
	    	},
	    	generateExistingValueRow:function(uri, label) {
	    		var openURL = armHasCitation.baseHref + uri;
	    		var html = "<li class='existingConcept conceptsListContainer'>" + 
	                "<div class='container'>" + 
	                    "<div class='row'>" + 
	                        "<div class='col-12'>" + 
	                            "<div class='column conceptLabelInfo'><a href='#' uri='" + openURL + "' class='openAuth'>" + label + "</a>"  +  
	                            "</div>" + 
	                            "<div class='column conceptRemoval'>" + 
	                                "<a href='" + armHasCitation.primitiveEdit + "' class='remove' title='remove' uri='" + uri + "'>Remove</a>" + 
	                            "</div>" + 
	                        "</div>" + 
	                    "</div>" + 
	                "</div>" + 
	            "</li>";
	    		return html;
	    	},
	    	bindExistingTermEvents:function() {
	    		//Bind opening of auth
	    		$("#existingCitations a.openAuth").click(function(e) {
	    			var uri = $(this).attr("uri");
	        		armHasCitation.openAuthURL(uri, e);
	                return false;
	    		});
	    		$("a.remove").click(function() {
	                armHasCitation.removeExistingPart(this);
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
		                message = "Are you sure you wish to remove this citation?";
		                
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
		                    retractions: armHasCitation.generateDeletionN3($(link).attr("uri"))
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
		                        alert("Error removing citation");
		                    }
		                }
		            });     
	    	 }, 
	    	 generateDeletionN3: function(conceptNodeUri) {
		        	var n3String = "<" + armHasCitation.subjectURI + "> <" + armHasCitation.predicateURI + "> <" + conceptNodeUri + "> .";
		        	return n3String;
		     }

	        
};

$(document).ready(function() {   
    armHasCitation.onLoad();
}); 