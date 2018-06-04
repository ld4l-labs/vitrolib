/* $This file is distributed under the terms of the license in /doc/license.txt$ */

//In this particular case, we are using this JavaScript in the case where we are employing an external template
//And NOT generating fields
//For now, we are only using this when creating an entirely new object, but later will incorporate editing functionality as well

var armMarkedBy = {
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
	        		armMarkedBy.setAgentType(selectedInput.attr("lookupType"));
	        	});
	        	
	        	//If create new chosen, then show lookupType
	        	this.actionType.change(function() {
	        		var actionTypeVal = $(this).val();
	        		if(actionTypeVal == "create") {
	        			armMarkedBy.vocabSource.hide();
	        		}
	        		else {
	        			armMarkedBy.vocabSource.show();
	        		}
	        	});
	        	
	        	this.formSubmit.click(function() {
	        		armMarkedBy.copyActivityLabel();
	        		return true;
	        	});
	        	
	           
	        },
	        copyActivityLabel:function() {
	        	//Find selected activity label
	        	var selectedLabel = $("#activityType option:selected").text();
	        	$("#activityLabel").val(selectedLabel);
	        },
	        //Existing values - need to put this in its own javascript file
	        /**Code for retrieving existing song contents and enabling removal through links**/
	    	retrieveExistingValues:function() {
	    		//Do ajax request - reusing query from lookupConfig as it's the same idea
	    		//Could make this more involved but keeping it simple for now
	    		//The query needs to change based on the content we're looking at
	    		var query = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>  " + 
	    		"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> " + 
	    		"PREFIX arm: <https://w3id.org/arm/core/ontology/0.1/> " + 
	    		"PREFIX bibframe: <http://id.loc.gov/ontologies/bibframe/> " + 
	    		"SELECT DISTINCT ?object ?markingValue ?markingNoteValue  " + 
	    		"WHERE {?subject ?predicate ?object ." + 
	    		" ?object rdf:value ?markingValue .  " + 
	    		" OPTIONAL{ ?object bibframe:note ?note . ?note rdf:value ?markingNoteValue . } }" + 
	    		"ORDER BY ?object ?entryValue ?locationLabel";
	    		//Replace subject with subject URI and predicate with predicate URI
	    		query = query.replace("?subject", "<" + armMarkedBy.subjectURI + ">");
	    		query = query.replace("?predicate", "<" + armMarkedBy.predicateURI + ">");
	    		var URL = armMarkedBy.queryAJAXURL + "?query=" + encodeURIComponent(query);
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
	    						if("markingValue" in binding && "value" in binding["markingValue"]) labelValues.push("Marking value:" + binding["markingValue"]["value"]);
	    						if("markingNoteValue" in binding && "value" in binding["markingNoteValue"]) labelValues.push("Note:" + binding["markingNoteValue"]["value"]);
	    						label = labelValues.join(", ");
	    						html += armMarkedBy.generateExistingValueRow(uri, label);
	    						
	    					}
	    				}
	    				
	    				$("#existingCitations").append(html);
	    				$("#existingCitations").show();
	    				//Bind event listeners to existing concepts here
	    				armMarkedBy.bindExistingTermEvents();
	    			}
	    		});
	    	},
	    	generateExistingValueRow:function(uri, label) {
	    		var openURL = armMarkedBy.baseHref + uri;
	    		var html = "<li class='existingConcept conceptsListContainer'>" + 
	                "<div class='container'>" + 
	                    "<div class='row'>" + 
	                        "<div class='col-12'>" + 
	                            "<div class='column conceptLabelInfo'><a href='#' uri='" + openURL + "' class='openAuth'>" + label + "</a>"  +  
	                            "</div>" + 
	                            "<div class='column conceptRemoval'>" + 
	                                "<a href='" + armMarkedBy.primitiveEdit + "' class='remove' title='remove' uri='" + uri + "'>Remove</a>" + 
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
	        		armMarkedBy.openAuthURL(uri, e);
	                return false;
	    		});
	    		$("a.remove").click(function() {
	                armMarkedBy.removeExistingPart(this);
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
		                message = "Are you sure you wish to remove this marking?";
		                
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
		                    retractions: armMarkedBy.generateDeletionN3($(link).attr("uri"))
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
		                        alert("Error removing marking");
		                    }
		                }
		            });     
	    	 }, 
	    	 generateDeletionN3: function(conceptNodeUri) {
		        	var n3String = "<" + armMarkedBy.subjectURI + "> <" + armMarkedBy.predicateURI + "> <" + conceptNodeUri + "> .";
		        	return n3String;
		     }

};

$(document).ready(function() {   
    armMarkedBy.onLoad();
}); 