define(['questAPI'], function(Quest){
	var API = new Quest();
	
	// The structure for the basic questionnaire page
	API.addPagesSet('basicPage', {
		progressBar: '<%= pagesMeta.number %> out of 8',
		header : 'Behaviors Questionnaire',
		headerStyle : {'font-size':'1em'},
		decline : true,
		autoFocus : true,
		v1style : 2,
		questions : [
			{
				inherit : {
					type : 'exRandom',
					set : 'SDSList'
				}
			}
		]
	});
	
	// The structure for the basic question    
	API.addQuestionsSet('basicSelect', {
		type : 'selectOne',
		autoSubmit : true,
		numericValues : true,
		help : '<%= pagesMeta.number < 3 %>',
		helpText : 'Tip: For quick response, click to select your answer, and then click again to submit.',
		answers : ['True', 'False']
	});
	// This is the question pool, the sequence picks the questions from here
	API.addQuestionsSet('SDSList', [
		{
			stem : 'I sometimes litter.',
			name : 'sdsQ16',
			inherit : 'basicSelect'
		},
		{
			stem : 'I always admit my mistakes openly and face the potential negative consequences.',
			name : 'sdsQ1',
			inherit : 'basicSelect'
		},
		{
			stem : 'In traffic I am always polite and considerate of others.',
			name : 'sdsQ2',
			inherit : 'basicSelect'
		},
		{
			stem : 'I always accept others\' opinions, even when they don\'t agree with my own.',
			name : 'sdsQ3',
			inherit : 'basicSelect'
		},
		{
			stem : 'I take out my bad moods on others now and then.',
			name : 'sdsQ4',
			inherit : 'basicSelect'
		},
		{
			stem : 'There has been an occasion when I took advantage of someone else.',
			name : 'sdsQ5',
			inherit : 'basicSelect'
		},
		{
			stem : 'In conversations I always listen attentively and let others finish their sentences.',
			name : 'sdsQ6',
			inherit : 'basicSelect'
		},
		{
			stem : 'I never hesitate to help someone in case of emergency.',
			name : 'sdsQ7',
			inherit : 'basicSelect'
		},
		{
			stem : 'When I have made a promise, I keep it--no ifs, ands or buts.',
			name : 'sdsQ8',
			inherit : 'basicSelect'
		},
		{
			stem : 'I occasionally speak badly of others behind their back.',
			name : 'sdsQ9',
			inherit : 'basicSelect'
		},
		{
			stem : 'I would never live off other people.',
			name : 'sdsQ10',
			inherit : 'basicSelect'
		},
		{
			stem : 'I always stay friendly and courteous with other people, even when I am stressed out.',
			name : 'sdsQ11',
			inherit : 'basicSelect'
		},
		{
			stem : 'During arguments I always stay objective and matter-of-fact.',
			name : 'sdsQ12',
			inherit : 'basicSelect'
		},
		{
			stem : 'There has been at least one occasion when I failed to return an item that I borrowed.',
			name : 'sdsQ13',
			inherit : 'basicSelect'
		},
		{
			stem : 'I always eat a healthy diet.',
			name : 'sdsQ14',
			inherit : 'basicSelect'
		},
		{
			stem : 'Sometimes I only help because I expect something in return.',
			name : 'sdsQ15',
			inherit : 'basicSelect'
		}
	]);
	
	// This is the sequence of questions
	// Note that you may want to update the "times" property if you change the number of questions
	API.addSequence([
		{
			mixer : 'repeat',
			times : '8',
			data : [
				{
					inherit : 'basicPage'
				}
			]
		}
	]);
	
	return API.script;
});

