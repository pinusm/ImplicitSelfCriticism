define(['/implicit/user/pinus/qiat.sc2/qiatextension.js'], function(qiatExtension){
	return qiatExtension({
		category1 : {  
    			name : "High Self-Criticism", //Will appear in the data.
    			stimulusMedia : [ //Stimuli content as PIP's media objects
    				{word: 'I often find that I don\'t live up to my own standards or ideals'},
    				{word: 'When things go wrong I call myself names'},
    				{word: 'I tend not to be satisfied with what I have'},
    				{word: 'I have a difficult time accepting weaknesses in myself'},
    				{word: 'I tend to be very critical of myself'},
    				{word: 'I very frequently compare myself to standards or goals'}
    			]
    		},
    		category2 :	{
    			name : "Low Self-Criticism", //Will appear in the data.
    			stimulusMedia : [ //Stimuli content as PIP's media objects
                    {word: 'I find it easy to forgive myself'},
    				{word: 'I like being me'},
    				{word: 'When things go wrong I can still feel lovable and acceptable'},
    				{word: 'I am gentle and supportive with myself'},
    				{word: 'I can accept failures and setbacks without feeling inadequate'},
    				{word: 'I seldom compare myself to standards or goals'}
    			]
    		}
	});
	
	//NOTE: when you test the task, remember that pressing ESC and then ENTER skips blocks.
});









