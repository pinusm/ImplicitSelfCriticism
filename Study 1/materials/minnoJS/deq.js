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

	API.addQuestionsSet('deqset',
	[
		{
			inherit : 'basicSelect',
			name : 'deqQ01',
			stem :  'I often find that I don\'t live up to my own standards or ideals.'
		},
		{
			inherit : 'basicSelect',
			name : 'deqQ02',
			stem :  'There is a considerable difference between how I am now and how I would like to be.'
		},
		{
			inherit : 'basicSelect',
			name : 'deqQ03',
			stem :  'I tend not to be satisfied with what I have.'
		},
		{
			inherit : 'basicSelect',
			name : 'deqQ04',
			stem :  'I have a difficult time accepting weaknesses in myself.'
		},
		{
			inherit : 'basicSelect',
			name : 'deqQ05',
			stem :  'I tend to be very critical of myself.'
		},
		{
			inherit : 'basicSelect',
			name : 'deqQ06',
			stem :  'I very frequently compare myself to standards or goals.'
		}
	]);

	/**
	Pages
	**/
	API.addPagesSet('basicPage',
	{
		progressBar: '<%= pagesMeta.number %> out of 6',
		header: 'Self Questionnaire',
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
			times : 6,
			data :
			[
				{
					inherit : 'basicPage',
					questions : {inherit:{set:'deqset', type:'exRandom'}}
				}
			]
		}
	]);

	/**
	Return the script to piquest's god, or something of that sort.
	**/
	return API.script;
});










