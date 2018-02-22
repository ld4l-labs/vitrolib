/* $This file is distributed under the terms of the license in /doc/license.txt$ */

//In this particular case, we are using this JavaScript in the case where we are employing an external template
//And NOT generating fields
//For now, we are only using this when creating an entirely new object, but later will incorporate editing functionality as well

var hasActivity = {
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
	        },

	        // Initial page setup. Called only at page load.
	        initPage: function() {
	        	
	                           
	        },
	      
	        bindEventListeners:function() {
	        	this.searchUrlButton.change(function() {
	        		var selectedUrl = $("input[name='selectAcUrl']:checked").val();
	        		var agentNameInput = $("#agentName");
	        		agentNameInput.attr("acUrl", selectedUrl);
	        	});
	        	
	        	this.formSubmit.click(function() {
	        		hasActivity.copyActivityLabel();
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
    hasActivity.onLoad();
}); 