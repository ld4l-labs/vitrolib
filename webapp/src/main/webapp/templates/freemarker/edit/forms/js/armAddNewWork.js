/* $This file is distributed under the terms of the license in /doc/license.txt$ */

//In this particular case, we are using this JavaScript in the case where we are employing an external template
//And NOT generating fields
//For now, we are only using this when creating an entirely new object, but later will incorporate editing functionality as well

var addNewWorkSpecific = {

 
    onLoad: function() {
    	 	this.mixIn();  
    	 	this.bindEventListeners();
            
        },

    mixIn: function() {

        // Get the custom form data from the page
        $.extend(this, customFormData);
        $.extend(this, i18nStrings);
    },

    // Initial page setup. Called only at page load.
    initPage: function() {
    	
                       
    },
    bindEventListeners:function() {
    	//Copy title field to instance title and item, but enable changing item title
    	$("#title").bind("propertychange change click keyup input paste", function(event) {
    		//Get value of title
    		var titleValue = $("#title").val();
    		//Check instance title value
    		var instanceTitleValue = $("#instanceTitle").val();
    		if(instanceTitleValue != titleValue) {
    			$("#instanceTitle").val(titleValue);
    		}
    		var itemTitleValue = $("#itemTitle").val();
    		if(itemTitleValue != titleValue) {
    			$("#itemTitle").val(titleValue);
    		}
    	});
    	
   
    
    	
    }

};

$(document).ready(function() {   
    addNewWorkSpecific.onLoad();
}); 