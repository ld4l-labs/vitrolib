/* $This file is distributed under the terms of the license in /doc/license.txt$ */

var selectEntity = {
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
	        	this.newEntityDiv = $("div#actionCreateNew");
	        	this.lookupEntityDiv = $("div#actionLookupExisting");
	        },

	        // Initial page setup. Called only at page load.
	        initPage: function() {
	        },
	      
	        bindEventListeners:function() {
	        	//If create new chosen, then show lookupType
	        	this.actionType.change(function() {
	        		var actionTypeVal = $(this).val();
	        		if(actionTypeVal == "createEntity") {
	        			selectEntity.newEntityDiv.show() ;
	        			selectEntity.lookupEntityDiv.hide();
	        		}
	        		else {
	        			selectEntity.newEntityDiv.hide() ;
	        			selectEntity.lookupEntityDiv.show();
	        		}
	        	});
	        	
	        	
	        	
	           
	        }
	        

};

$(document).ready(function() {   
    selectEntity.onLoad();
}); 