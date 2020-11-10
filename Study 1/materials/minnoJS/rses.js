define(['questAPI'], function(quest){ 
	var API = new quest();

	/**
	Settings
	**/
	API.addSettings('logger',
	{
		url: '/implicit/PiQuest'
	});
	/*API.addSettings('DEBUG', {
        tags: 'all',
        level: 'debug'
    });*/
	
	/**
	Questions
	**/
	API.addQuestionsSet('basicSelect',
	{
		type: 'selectOne',
		style:'multiButtons',
		autoSubmit:true,
		numericValues:true,
        required:true,
        errorMsg: {
            required: "Please select an answer, or click 'decline to answer'"
        },
		answers: ["Strongly Disagree",  "Disagree" ,  "Agree", "Strongly Agree"],
		help: '<%= pagesMeta.number < 3 %>',
		helpText: 'Tip: For quick response, click to select your answer, and then click again to submit.'
	});

	API.addQuestionsSet('rsesset',
	[
		{
			inherit : 'basicSelect',
			name : 'rsesQ01',
			stem :  'On the whole, I am satisfied with myself.'
		},
		{
			inherit : 'basicSelect',
			name : 'rsesQ02',
			stem :  'At times, I think I am no good at all.'
		},
		{
			inherit : 'basicSelect',
			name : 'rsesQ03',
			stem :  'I feel that I have a number of good qualities.'
		},
		{
			inherit : 'basicSelect',
			name : 'rsesQ04',
			stem :  'I am able to do things as well as most other people.'
		},
		{
			inherit : 'basicSelect',
			name : 'rsesQ05',
			stem :  'I feel I do not have much to be proud of.'
		},
		{
			inherit : 'basicSelect',
			name : 'rsesQ06',
			stem :  'I certainly feel useless at times.'
		},
		{
			inherit : 'basicSelect',
			name : 'rsesQ07',
			stem :  'I feel that I am a person of worth, at least on an equal plane with others.'
		},
		{
			inherit : 'basicSelect',
			name : 'rsesQ08',
			stem :  'I wish I could have more respect for myself.'
		},
		{
			inherit : 'basicSelect',
			name : 'rsesQ09',
			stem :  'All in all, I am inclined to feel that I am a failure.'
		},
		{
			inherit : 'basicSelect',
			name : 'rsesQ10',
			stem :  'I take a positive attitude toward myself.'
		}
	]);

	/**
	Pages
	**/
	API.addPagesSet('basicPage',
	{
		progressBar: '<%= pagesMeta.number %> out of 10',
		header: 'Questionnaire',
		headerStyle : {'font-size':'1em'},
		decline:true,
		v1style:2,
		numbered: false,
		noSubmit:false //Change to true if you don't want to show the submit button.
	});


	/**
	Sequence
	**/
	API.addSequence(
	[
		{
			mixer : 'repeat',
			times : 10,
			data :
			[
				{
					inherit : 'basicPage',
					questions : {inherit:{set:'rsesset', type:'exRandom'}}
				}
			]
		}
	]);

	/**
	Return the script to piquest's god, or something of that sort.
	**/
	return API.script;
});









