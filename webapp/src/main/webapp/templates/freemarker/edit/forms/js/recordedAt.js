/* $This file is distributed under the terms of the license in /doc/license.txt$ */

//In this particular case, we are using this JavaScript in the case where we are employing an external template
//And NOT generating fields
//For now, we are only using this when creating an entirely new object, but later will incorporate editing functionality as well

var recordedAt = {
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
	        			$("div#createNew").show();
	        			$("div#lookupExisting").hide();
	        		}
	        		else {
	        			$("div#createNew").hide();
	        			$("div#lookupExisting").show();
	        		}
	        	});
	        	
	        	this.formSubmit.click(function() {
	        	
	        		return true;
	        	});
	        	
	           
	        },
	        /**Code for retrieving existing song contents and enabling removal through links**/
	    	retrieveExistingValues:function() {
	    		//Do ajax request - reusing query from lookupConfig as it's the same idea
	    		//Could make this more involved but keeping it simple for now
	    		var query = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>  SELECT DISTINCT ?object ?label WHERE {?subject ?predicate ?object . ?object rdfs:label ?label .} ORDER BY ?object ?label";
	    		//Replace subject with subject URI and predicate with predicate URI
	    		query = query.replace("?subject", "<" + recordedAt.subjectURI + ">");
	    		query = query.replace("?predicate", "<" + recordedAt.predicateURI + ">");
	    		var URL = recordedAt.queryAJAXURL + "?query=" + encodeURIComponent(query);
	    		$.getJSON(URL, function(results) {
	    			if((results != null) && ("results" in results) && ("bindings" in results["results"])) {
	    				var bindings = results["results"]["bindings"];
	    				//Array of var name to value
	    				var len = bindings.length;
	    				
	    				var html = "";
	    				var b;
	    				for(b = 0; b < len; b++) {
	    					var binding = bindings[b];
	    					if("object" in binding && "label" in binding) {
	    						var uri = binding["object"]["value"];
	    						var label = binding["label"]["value"];
	    						html += recordedAt.generateExistingValueRow(uri, label);
	    						
	    					}
	    				}
	    				
	    				$("#existingEvents").append(html);
	    				$("#existingEvents").show();
	    				//Bind event listeners to existing concepts here
	    				recordedAt.bindExistingTermEvents();
	    			}
	    		});
	    	},
	    	generateExistingValueRow:function(uri, label) {
	    		var openURL = recordedAt.baseHref + uri;
	    		var html = "<li class='existingConcept conceptsListContainer'>" + 
	                "<div class='container'>" + 
	                    "<div class='row'>" + 
	                        "<div class='col-12'>" + 
	                            "<div class='column conceptLabelInfo'><a href='#' uri='" + openURL + "' class='openAuth'>" + label + "</a>"  +  
	                            "</div>" + 
	                            "<div class='column conceptRemoval'>" + 
	                                "<a href='" + recordedAt.primitiveEdit + "' class='remove' title='remove' uri='" + uri + "'>Remove</a>" + 
	                            "</div>" + 
	                        "</div>" + 
	                    "</div>" + 
	                "</div>" + 
	            "</li>";
	    		return html;
	    	},
	    	bindExistingTermEvents:function() {
	    		//Bind opening of auth
	    		$("#existingEvents a.openAuth").click(function(e) {
	    			var uri = $(this).attr("uri");
	        		recordedAt.openAuthURL(uri, e);
	                return false;
	    		});
	    		$("a.remove").click(function() {
	                recordedAt.removeExistingPart(this);
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
		                message = "Are you sure you wish to remove this event?";
		                
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
		                    retractions: recordedAt.generateDeletionN3($(link).attr("uri"))
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
		        	var n3String = "<" + recordedAt.subjectURI + "> <" + recordedAt.predicateURI + "> <" + conceptNodeUri + "> .";
		        	return n3String;
		     }
	       
};

$(document).ready(function() {   
    recordedAt.onLoad();
}); 