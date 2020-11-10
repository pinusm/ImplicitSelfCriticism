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
		autoSubmit:true,
		numericValues:true,
        required:true,
        errorMsg: {
            required: "Please select an answer, or click 'decline to answer'"
        },
		answers: ["Rarely or None of the Time (Less than 1 Day)",
		          "Some or a Little of the Time (1-2 Days)" , 
		          "Occasionally or a Moderate Amount of Time (3-4 Days)", 
		          "Most or All of the Time (5-7 Days)"],
		help: '<%= pagesMeta.number < 2 %>',
		helpText: 'Tip: For quick response, click to select your answer, and then click again to submit.'
	});

	API.addQuestionsSet('cesd4set',
	[
		{
			inherit : 'basicSelect',
			name : 'cesdQ01',
			stem :  'During the past week, I felt depressed.'
		},
		{
			inherit : 'basicSelect',
			name : 'cesdQ02',
			stem :  'During the past week, I felt lonely.'
		},
		{
			inherit : 'basicSelect',
			name : 'cesdQ03',
			stem :  'During the past week, I had crying spells.'
		},
		{
			inherit : 'basicSelect',
			name : 'cesdQ04',
			stem :  'During the past week, I felt sad.'
		}
	]);
	
	API.addQuestionsSet('cesd5set', //this is the possibliy gender-bias free question mentioned in the plan. It's always last because the cesd cut-off point is calibrated for the other questions, and the calculation is limited to either onSubmit or onCreate. Hence, at leaset one question needed to be in a fixed position (Clearly, this could be circumvented with more complex code...)
	[
		{
			inherit : 'basicSelect',
			name : 'cesdQ05',
			stem :  'During the past week, my sleep was restless.',
			onCreate : function(log, current){
    			var sum=0, count=0, prop, response;
    
    			// for each question (that has a response and begings with "ros") add to sum
    			for (prop in current.questions){
    				response = current.questions[prop].response;
    				if (response && /^cesd/.test(prop)) {
    					sum += response;
    					count+=1;
    				}
    			}
    
    			if (count === 4){
    				current.cesdScore = sum - 4;
    			} else {
    				current.cesdScore = 'No score; You did not answer all the questions required to compute a score';
    			}
    			API.addGlobal({cesdScore: current.cesdScore});
    			API.save({cesdScore:API.getGlobal().cesdScore});
    			//console.log(current.cesdScore);
    		}
		}
	]);
	
	
	/**
	Pages
	**/
	API.addPagesSet('basicPage',
	{
		progressBar: '<%= pagesMeta.number %> out of 5',
		header: 'Mood Questionnaire',
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
			times : 4,
			data :
			[
				{
					inherit : 'basicPage',
					questions : {inherit:{set:'cesd4set', type:'exRandom'}}
				}
			]
		},
		{
			inherit:'basicPage',
			questions:[{inherit:'cesd5set'}]
		}
	]);
    
	/**
	Return the script to piquest's god, or something of that sort.
	**/
	
	return API.script;
});

