/* $This file is distributed under the terms of the license in /doc/license.txt$ */

//In this particular case, we are using this JavaScript in the case where we are employing an external template
//And NOT generating fields
//For now, we are only using this when creating an entirely new object, but later will incorporate editing functionality as well

var armHasPartBinding = {
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
	        	this.searchUrlButton = $("input[name='selectAcUrl']");
	        	this.formSubmit = $("input[name='formSubmit'");
	        	this.actionType = $("input[name='actionType']");
	        	this.vocabSource = $("div#vocabSource");
	        },

	        // Initial page setup. Called only at page load.
	        initPage: function() {
	        	this.retrieveExistingValues();         
	        },
	      
	        bindEventListeners:function() {
	        	this.searchUrlButton.change(function() {
	        		var selectedInput = $("input[name='selectAcUrl']:checked");
	        		var selectedUrl = selectedInput.val();
	        		var agentNameInput = $("#agentName");
	        		agentNameInput.attr("acUrl", selectedUrl);
	        		//Also change the value of the agent type dropdown on the basis of what is checked
	        		armHasPartBinding.setAgentType(selectedInput.attr("lookupType"));
	        	});
	        	
	        	//If create new chosen, then show lookupType
	        	this.actionType.change(function() {
	        		var actionTypeVal = $(this).val();
	        		if(actionTypeVal == "create") {
	        			armHasPartBinding.vocabSource.hide();
	        		}
	        		else {
	        			armHasPartBinding.vocabSource.show();
	        		}
	        	});
	        	
	        	this.formSubmit.click(function() {
	        		armHasPartBinding.copyActivityLabel();
	        		return true;
	        	});
	        	
	           
	        },
	        copyActivityLabel:function() {
	        	//Find selected activity label
	        	var selectedLabel = $("#activityType option:selected").text();
	        	$("#activityLabel").val(selectedLabel);
	        },
	        /**Code for retrieving existing song contents and enabling removal through links**/
	    	retrieveExistingValues:function() {
	    		//Do ajax request - reusing query from lookupConfig as it's the same idea
	    		//Could make this more involved but keeping it simple for now
	    		//The query needs to change based on the content we're looking at
	    		var query = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>  " + 
	    		"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> " + 
	    		"PREFIX arm: <https://w3id.org/arm/core/ontology/0.1/> " + 
	    		"PREFIX bibframe: <http://id.loc.gov/ontologies/bibframe/> " + 
	    		"PREFIX crm:<http://www.cidoc-crm.org/cidoc-crm/> " + 
	    		"PREFIX skos:<http://www.w3.org/2004/02/skos/core#> " + 
	    		"SELECT DISTINCT ?object ?bindingType ?bindingTypeLabel  " + 
	    		"WHERE {?subject ?predicate ?object ." + 
	    		"?object crm:P2_has_type ?bindingType ." +
	    		"OPTIONAL{ ?object skos:prefLabel ?bindingTypeLabel  .}}  " + 
	    		"ORDER BY ?object ?bindingTypeLabel";
	    		
	    		//Replace subject with subject URI and predicate with predicate URI
	    		query = query.replace("?subject", "<" + armHasPartBinding.subjectURI + ">");
	    		query = query.replace("?predicate", "<" + armHasPartBinding.predicateURI + ">");
	    		var URL = armHasPartBinding.queryAJAXURL + "?query=" + encodeURIComponent(query);
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
	    						if("bindingTypeLabel" in binding && "value" in binding["bindingTypeLabel"]) labelValues.push("Binding Type:" + binding["bindingTypeLabel"]["value"]);
	    						label = labelValues.join(", ");
	    						html += armHasPartBinding.generateExistingValueRow(uri, label);
	    						
	    					}
	    				}
	    				
	    				$("#existingCitations").append(html);
	    				$("#existingCitations").show();
	    				//Bind event listeners to existing concepts here
	    				armHasPartBinding.bindExistingTermEvents();
	    			}
	    		});
	    	},
	    	generateExistingValueRow:function(uri, label) {
	    		var openURL = armHasPartBinding.baseHref + uri;
	    		var html = "<li class='existingConcept conceptsListContainer'>" + 
	                "<div class='container'>" + 
	                    "<div class='row'>" + 
	                        "<div class='col-12'>" + 
	                            "<div class='column conceptLabelInfo'><a href='#' uri='" + openURL + "' class='openAuth'>" + label + "</a>"  +  
	                            "</div>" + 
	                            "<div class='column conceptRemoval'>" + 
	                                "<a href='" + armHasPartBinding.primitiveEdit + "' class='remove' title='remove' uri='" + uri + "'>Remove</a>" + 
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
	        		armHasPartBinding.openAuthURL(uri, e);
	                return false;
	    		});
	    		$("a.remove").click(function() {
	                armHasPartBinding.removeExistingPart(this);
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
		                message = "Are you sure you wish to remove this binding?";
		                
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
		                    retractions: armHasPartBinding.generateDeletionN3($(link).attr("uri"))
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
		                        alert("Error removing binding");
		                    }
		                }
		            });     
	    	 }, 
	    	 generateDeletionN3: function(conceptNodeUri) {
		        	var n3String = "<" + armHasPartBinding.subjectURI + "> <" + armHasPartBinding.predicateURI + "> <" + conceptNodeUri + "> .";
		        	return n3String;
		     }
};

$(document).ready(function() {   
    armHasPartBinding.onLoad();
}); 