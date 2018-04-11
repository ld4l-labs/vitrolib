/* $This file is distributed under the terms of the license in /doc/license.txt$ */

//In this particular case, we are using this JavaScript in the case where we are employing an external template
//And NOT generating fields
//For now, we are only using this when creating an entirely new object, but later will incorporate editing functionality as well

var workHasPart = {
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
	        	this.workActionType = $("input[name='workActionType']");
	        	this.newWorkForm = $("div#formcontent");
	        	this.lookupWorkDiv = $("#lookupLocalWork");
	        },

	        // Initial page setup. Called only at page load.
	        initPage: function() {
	        	this.retrieveExistingValues();
	        	//Lookup is checked
	        	this.newWorkForm.hide();
	                           
	        },
	      
	        bindEventListeners:function() {
	        	//If create new chosen, then show lookupType
	        	this.workActionType.change(function() {
	        		var actionTypeVal = $(this).val();
	        		if(actionTypeVal == "createNewWork") {
	        			workHasPart.disableAndHideExistingWorkForm();
	        			workHasPart.showAndEnableNewWorkForm();
	        		}
	        		else {
	        			workHasPart.showAndEnableExistingWorkForm();
	        			workHasPart.disableAndHideNewWorkForm();
	        		}
	        	});
	        	
	         	//Update which input is used for search
	        	$("input[name='selectAcUrl']").change(function() {
	        		var selectedInput = $("input[name='selectAcUrl']:checked");
	        		var selectedUrl = selectedInput.val();
	        		var agentNameInput = $("#agentName");
	        		agentNameInput.attr("acUrl", selectedUrl);
	        		//Also change the value of the agent type dropdown on the basis of what is checked
	        		workHasPart.setAgentType(selectedInput.attr("lookupType"));
	        	});
	        	
	        	$("form").submit(function(event) {
	        		//update activity labels for work and instance level based on activity type selected
	        		workHasPart.updateActivityLabel(event);
	        		//this is relevant only if NEW is picked but no agent/etc. is selected
	        		workHasPart.clearEmptyAutocompleteFields();
	        	});
	        	

	        },
	        setAgentType:function(lookupType) {
	        	$("#agentType").val(lookupType);
	        },
	        disableAndHideNewWorkForm:function() {
	        	//Disable all new form inputs
    			$("div#formcontent").find("input, textarea, select").attr("disabled", "disabled");
    			//Hide the new work form
    			workHasPart.newWorkForm.hide() ;
	        },
	        showAndEnableNewWorkForm:function() {
	        	//Show new form and enable inputs
    			workHasPart.newWorkForm.show() ;
    			$("div#formcontent").find("input, textarea, select").removeAttr("disabled");	   
	        },
	        disableAndHideExistingWorkForm:function() {
	        	//Disable lookup input
    			$("#existingTitle").attr("disabled", "disabled");
    			workHasPart.lookupWorkDiv.hide();
	        },
	        showAndEnableExistingWorkForm:function() {
	        	//show the existing form and remove disabled attribute
    			workHasPart.lookupWorkDiv.show();
    			$("#existingTitle").removeAttr("disabled");
	        },
	        updateActivityLabel:function(event) {
	        	//Update activity label
	    		var optionText = $("#activityType option:selected").text();
	    		$("#activityLabel").val(optionText);
	        },
	        clearEmptyAutocompleteFields:function() {
	        	var fieldNames = ["agentName", "lgftTerm"];
	        	var f;
	        	for(f = 0; f < fieldNames.length; f++) {
	        		workHasPart.clearEmptyAutocompleteField(fieldNames[f]);
	        	}
	        },
	        clearEmptyAutocompleteField(fieldName) {
	        	var fieldElement = $("input[name='" + fieldName + "']");
	        	var fieldValue = fieldElement.val();
	        	if(fieldValue.match("^" + workHasPart.selectAnExisting)) {
	        		fieldElement.val("");
	        	}
	        },
	        /**Code for retrieving existing song contents and enabling removal through links**/
	    	retrieveExistingValues:function() {
	    		//Do ajax request - reusing query from lookupConfig as it's the same idea
	    		var query = lookupConfig["existingValuesQuery"];
	    		//Replace subject with subject URI and predicate with predicate URI
	    		query = query.replace("?subject", "<" + workHasPart.subjectURI + ">");
	    		query = query.replace("?predicate", "<" + workHasPart.predicateURI + ">");
	    		var URL = workHasPart.queryAJAXURL + "?query=" + encodeURIComponent(query);
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
	    						html += workHasPart.generateExistingValueRow(uri, label);
	    						
	    					}
	    				}
	    				
	    				$("#existingParts").append(html);
	    				$("#existingParts").show();
	    				//Bind event listeners to existing concepts here
	    				workHasPart.bindExistingTermEvents();
	    			}
	    		});
	    	},
	    	generateExistingValueRow:function(uri, label) {
	    		var openURL = workHasPart.baseHref + uri;
	    		var html = "<li class='existingConcept conceptsListContainer'>" + 
	                "<div class='container'>" + 
	                    "<div class='row'>" + 
	                        "<div class='col-12'>" + 
	                            "<div class='column conceptLabelInfo'><a href='#' uri='" + openURL + "' class='openAuth'>" + label + "</a>"  +  
	                            "</div>" + 
	                            "<div class='column conceptRemoval'>" + 
	                                "<a href='" + workHasPart.primitiveEdit + "' class='remove' title='remove' uri='" + uri + "'>Remove</a>" + 
	                            "</div>" + 
	                        "</div>" + 
	                    "</div>" + 
	                "</div>" + 
	            "</li>";
	    		return html;
	    	},
	    	bindExistingTermEvents:function() {
	    		//Bind opening of auth
	    		$("#existingParts a.openAuth").click(function(e) {
	    			var uri = $(this).attr("uri");
	        		workHasPart.openAuthURL(uri, e);
	                return false;
	    		});
	    		$("a.remove").click(function() {
	                workHasPart.removeExistingPart(this);
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
		                message = "Are you sure you wish to remove this track listing?";
		                
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
		                    retractions: workHasPart.generateDeletionN3($(link).attr("uri"))
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
		        	var n3String = "<" + workHasPart.subjectURI + "> <" + workHasPart.predicateURI + "> <" + conceptNodeUri + "> .";
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
    workHasPart.onLoad();
}); 