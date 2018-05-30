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
	        	//Make invisible for now
	        	
	                           
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
	        }
};

$(document).ready(function() {   
    armHasPartBinding.onLoad();
}); 