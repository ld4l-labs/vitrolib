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
	        	//Lookup is checked
	        	this.newWorkForm.hide();
	                           
	        },
	      
	        bindEventListeners:function() {
	        	//If create new chosen, then show lookupType
	        	this.workActionType.change(function() {
	        		var actionTypeVal = $(this).val();
	        		if(actionTypeVal == "createNewWork") {
	        			workHasPart.newWorkForm.show() ;
	        			workHasPart.lookupWorkDiv.hide();
	        		}
	        		else {
	        			workHasPart.newWorkForm.hide() ;
	        			workHasPart.lookupWorkDiv.show();
	        		}
	        	});
	        	
	        	
	        	
	           
	        }
	        

};

$(document).ready(function() {   
    workHasPart.onLoad();
}); 