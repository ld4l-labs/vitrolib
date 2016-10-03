/* $This file is distributed under the terms of the license in /doc/license.txt$ */

var workHasContributionUtils = {
        
    onLoad: function() {
      

        this.initObjectReferences();                 
        this.bindEventListeners();
        
        $.extend(this, vitro.customFormUtils);
        $.extend(this, i18nStrings);

        if ( this.findValidationErrors() ) {
            //Error handling
        }
    },

    initObjectReferences: function() {
    
    this.form = $('#workHasContributorForm');
    this.contributionType = $("select[name='contributionType']");
    this.contributionLabel = $("#contributionLabel");
    
    },
    
    bindEventListeners: function() {
        this.idCache = {};
        
      
        
        this.form.submit(function(event) {
            //populate the contribution Label field
        	contributionLabel = $("select[name='contributionType'] option:selected").text();
        	workHasContributionUtils.contributionLabel.val(contributionLabel);
        });            
    }
} 

$(document).ready(function(){
    workHasContributionUtils.onLoad();
});
