define(['pipAPI','/implicit/common/all/js/pip/piscripts/iat/iat5.js'], function(APIConstructor, iatExtension){
	return iatExtension({
		category1 : {
			name : 'Not Self', //Will appear in the data.
			title : {
				media : {word : 'Not Self'}, //Name of the category presented in the task.
				css : {color:'#31b404','font-size':'2em'}, //Style of the category title.
				height : 4 //Used to position the "Or" in the combined block.
			}, 
			stimulusMedia : [ //Stimuli content as PIP's media objects
				{word: 'They'},
				{word: 'Them'},
				{word: 'Their'},
				{word: 'Theirs'},
				{word: 'Others'}
			], 
			//Stimulus css (style)
			stimulusCss : {color:'#31b404','font-size':'1.8em'}
    
		},	
		category2 :	{
			name : 'Self', //Will appear in the data.
			title : {
				media : {word : 'Self'}, //Name of the category presented in the task.
				css : {color:'#31b404','font-size':'2em'}, //Style of the category title.
				height : 4 //Used to position the "Or" in the combined block.
			}, 
			stimulusMedia : [ //Stimuli content as PIP's media objects
				{word: 'I'},
				{word: 'Me'},
				{word: 'Mine'},
				{word: 'Myself'},
				{word: 'Self'}
			], 
			//Stimulus css
			stimulusCss : {color:'#31b404','font-size':'1.8em'}
		},
		attribute2 : {
			name : 'Satisfactory', 
			title : {
				media : {word : 'Satisfactory'}, 
				css : {color:'#0000FF','font-size':'2em'}, 
				height : 4 //Used to position the "Or" in the combined block.
				
			}, 
			stimulusMedia : [ //Stimuli content as PIP's media objects
				{word: 'Acceptable'},
				{word: 'Good-Enough'},
				{word: 'Sufficient'},
				{word: 'Reasonable'},
				{word: 'Satisfactory'}
			], 
			//Stimulus css
			stimulusCss : {color:'#0000FF','font-size':'1.8em'} 
		},
		attribute1 : 
		{
			name : 'Disappointing', 
			title : {
				media : {word : 'Disappointing'}, 
				css : {color:'#0000FF','font-size':'2em'}, 
				height : 4 //Used to position the "Or" in the combined block.
			}, 
			stimulusMedia : [ //Stimuli content as PIP's media objects
				{word: 'Flawed'},
				{word: 'Substandard'},
				{word: 'Unacceptable'},
				{word: 'Deficient'},
				{word: 'Disappointing'}
			], 
			//Stimulus css
			stimulusCss : {color:'#0000FF','font-size':'1.8em'}
		}
    });
});












