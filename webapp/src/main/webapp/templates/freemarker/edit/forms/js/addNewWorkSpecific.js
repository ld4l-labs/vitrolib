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
    	//Copy title field to instance title field whenever title field changes
    	$("#title").bind("propertychange change click keyup input paste", function(event) {
    		//Get value of title
    		var titleValue = $("#title").val();
    		//Check instance title value
    		var instanceTitleValue = $("#instanceTitle").val();
    		if(instanceTitleValue != titleValue) {
    			$("#instanceTitle").val(titleValue);
    		}
    	});
    	
    	
    	//On submit, copy label fields or populate as needed (for anything dynamic)
    	$("form").submit(function(event) {
    		addNewWorkSpecific.updateActivityLabel(event);
    		addNewWorkSpecific.updatePublicationActivityLabel(event);
    		addNewWorkSpecific.updatePublicationActivityURI();
    	})
    	
    	//Update which input is used for search
    	$("input[name='selectAcUrl']").change(function() {
    		var selectedInput = $("input[name='selectAcUrl']:checked");
    		var selectedUrl = selectedInput.val();
    		var agentNameInput = $("#agentName");
    		agentNameInput.attr("acUrl", selectedUrl);
    		//Also change the value of the agent type dropdown on the basis of what is checked
    		addNewWorkSpecific.setAgentType(selectedInput.attr("lookupType"));
    	});
    	
    },
    updateActivityLabel:function(event) {
    	//Update activity label
		var optionText = $("#activityType option:selected").text();
		$("#activityLabel").val(optionText);
    },
    updatePublicationActivityLabel:function(event) {
    	//Update activity label
		$("#publicationActivityLabel").val("Publication");
    },
    //on submit, check if none of date, location, agent are filled, then ensure activity uri does not get created
    updatePublicationActivityURI:function() {
    	var date = $("input[name='publicationDate']").val();
    	var location = $("input[name='locationName']").val();
    	var agentName = $("input[name='publisherAgentName']").val();
    	if(date == "" && location == "" & agentName == "") {
    		$("input[name='publicationActivity']").val(">SUBMITTED VALUE WAS BLANK<");
    	}
    },
    setAgentType:function(lookupType) {
    	$("#agentType").val(lookupType);
    }
   

};

$(document).ready(function() {   
    addNewWorkSpecific.onLoad();
}); 