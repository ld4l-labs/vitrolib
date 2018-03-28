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
	        			workHasPart.disableAndHideExistingWorkForm();
	        			workHasPart.showAndEnableNewWorkForm();
	        		}
	        		else {
	        			workHasPart.showAndEnableExistingWorkForm();
	        			workHasPart.disableAndHideNewWorkForm();
	        		}
	        	});

	        },
	        disableAndHideNewWorkForm:function() {
	        	//Disable all new form inputs
    			$("div#formContent").find("input, textarea, select").attr("disabled", "disabled");
    			//Hide the new work form
    			workHasPart.newWorkForm.hide() ;
	        },
	        showAndEnableNewWorkForm:function() {
	        	//Show new form and enable inputs
    			workHasPart.newWorkForm.show() ;
    			$("div#formContent").find("input, textarea, select").removeAttr("disabled");	   
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
	        }
	        

};

$(document).ready(function() {   
    workHasPart.onLoad();
}); 