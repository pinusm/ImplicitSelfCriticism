define(['managerAPI'], function(Manager){
 
	// This code is responsible for styling the piQuest tasks as panels (like piMessage)
	// Don't touch unless you know what you're doing
	var API = new Manager();
	API.setName('mgr');
	API.addSettings('skip',true);
	API.addSettings('skin', 'demo');

   	API.addGlobal({
		implicitType : API.shuffle(['iat', 'qIAT'])[0]
	});
	API.save({
		implicitType:API.getGlobal().implicitType
	});
//  console.log(API.getGlobal().implicitType);
	//Define all the tasks.
	API.addTasksSet({
		instructions: [{
			type:'message', buttonText:'Continue'
		}], 
		
		consent: [{
			inherit:'instructions', name:'consent', templateUrl: 'consent.jst', title:'Consent',
			piTemplate:true, header:'Consent Agreement: Implicit Social Cognition on the Internet'
		}], 
			
		realstart: [{
			inherit:'instructions', name:'realstart', templateUrl: 'intro.jst', title:'Introduction',
			piTemplate:true, header:'Welcome'
		}], 
		
		instqiat : [{
			inherit:'instructions', name:'instqiat', templateUrl: 'instqiat.jst', title:'Classification Task',
            piTemplate:true, header:'Classification Task'
		}], 
		
		instiat : [{
			inherit:'instructions', name:'instiat', templateUrl: 'instiat.jst', title:'IAT',
            piTemplate:true, header:'IAT'
		}],
		
		scqiat : [{
			type: 'pip', name: 'sc.qiat', version: '0.3', scriptUrl: 'sc.qiat.js'
		}], 

		sciat : [{
			type: 'pip', name: 'sc.iat', version: '0.3', scriptUrl: 'sc.iat.js'
		}], 

		instrses : [{
			inherit:'instructions', name:'instrses', templateUrl: 'instrses.jst', title:'Questionnaire',
            piTemplate:true, header:'Questionnaire'
		}], 
		
        rses: [{
			type: 'quest', name: 'rses', scriptUrl: 'rses.js'	
		}], 
        
        instdeq : [{
			inherit:'instructions', name:'instdeq', templateUrl: 'instdeq.jst', title:'Questionnaire',
            piTemplate:true, header:'Self Questionnaire'
		}], 
		
		deq: [{
			type: 'quest', name: 'deq', scriptUrl: 'deq.js'
		}],
		
		instcesd : [{
			inherit:'instructions', name:'instcesd', templateUrl: 'instcesd.jst', title:'Questionnaire',
            piTemplate:true, header:'Mood Questionnaire'
		}], 
		
		cesd: [{
			type: 'quest', name: 'cesd', scriptUrl: 'cesd.js'
		}],
		
		instsds : [{
			inherit:'instructions', name:'instsds', templateUrl: 'instsds.jst', title:'Questionnaire',
            piTemplate:true, header:'Behaviors Questionnaire'
		}], 
		
		sds: [{
			type: 'quest', name: 'sds', scriptUrl: 'sds.js'
		}],
		
		lastpageIAT : [{
			type:'message',name:'lastpage', templateUrl: 'debriefingIAT.jst', piTemplate:'debrief', last:true
		}], 
		
		lastpageQIAT : [{
			type:'message',name:'lastpage', templateUrl: 'debriefingQIAT.jst', piTemplate:'debrief', last:true
		}]
	});

	API.addSequence([
        
		{inherit:'consent'},
		{inherit:'realstart'},
		{
		    mixer: 'random',
            data:[
            {   mixer: 'branch', //indirect SC
                conditions: [{compare: 'global.implicitType', to: 'iat'}],
                data: [
                    {//iat 
                        mixer: 'wrapper',
    					data: [
    						{inherit:'instiat'}, 
                            {inherit:'sciat'}
    					]
                    }
                ],
                elseData: [
                    {//qiat 
    					mixer: 'wrapper',
    					data: [
    						{inherit:'instqiat'}, 
                            {inherit:'scqiat'}
    					]
                    }
                ]
            },
            {//direct SC
                mixer: 'wrapper',
				data: [
						{inherit:'instdeq'}, 
                        {inherit:'deq'}
					]
            },
            {//direct SE
				mixer: 'wrapper',
				data: [
					{inherit:'instrses'}, 
                    {inherit:'rses'}
				]
            }
            ]
		},
		{
		    mixer: 'random',
            data:[
                {//SDS 
                    mixer: 'wrapper',
                    data: [
                            {inherit:'instsds'}, 
                            {inherit:'sds'}
                    ]
                },
                {//CESD 
                    mixer: 'wrapper',
                    data: [
                            {inherit:'instcesd'}, 
                            {inherit:'cesd'}
                    ]
		        }
            ]
    	},
		{mixer: 'branch',
                        conditions: [
                            {compare: 'global.implicitType', to: 'iat'}
                        ],
                        data: [
                            {inherit:'lastpageIAT'}
                        ],
                        elseData: [
                           {inherit:'lastpageQIAT'}
                        ]
            }
	]);
    return API.script;
});

















