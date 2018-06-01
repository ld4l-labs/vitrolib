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
	        	//Make invisible for now
	        	
	                           
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
	        		var locationTypeeVal = $(this).val();
	        		if(locationTypeVal == "") {
	        			armHasCitation.locationTitleSection.hide();
	        			armHasCitation.locationValueSection.hide();
	        		} else if(locationTypeVal == "http://id.loc.gov/ontologies/bibframe/Text") {
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
	    	   if(armHasCitation.actionTypeVal == "create") {
	    		   //if create, then get rid of any uris for location
	    		   $("#location").val("");
	    	   } else {
	    		   $("#locationType").val("");
	    		   $("#locationValue").val("");
	    		   $("#locationPreferredTitle").val("");
	    	   }
	        }
};

$(document).ready(function() {   
    armHasCitation.onLoad();
}); 