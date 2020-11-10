/* global define:true */
<%@page pageEncoding = "UTF-8" %>
<%@page import= "org.uva.*, java.io.*, java.util.*" %>
<%
  StudySession studySession = (StudySession) session.getAttribute("studysession");
String code = (String)studySession.getParameters().get("subject_nr");
String female = (String)studySession.getParameters().get("female");
String wave = (String)studySession.getParameters().get("wave");
%>

define(['managerAPI'], function (Manager) {
  // This code is responsible for styling the piQuest tasks as panels (like piMessage)
  // Don't touch unless you know what you're doing
  var API = new Manager()
  API.addSettings('injectStyle', '.btn-toolbar {text-align:right}label{width:100%}') // rtl layout for multibuttons items
  API.addSettings('injectStyle', '.list-group-item {text-align:right}label{width:100%}') // rtl layout for list items
  API.setName('mgr')
  API.addSettings('skip', true)
  API.addSettings('skin', 'demo')
  API.save({<%
    Map parameters = studySession.getParameters();
  Iterator itr = parameters.keySet().iterator();
  while (itr.hasNext()) {
    String element = (String)itr.next();%>
  <%=element + ":'" + parameters.get(element) + "'," %><%
      }
  %>});
  
  API.addGlobal({ 
    $picode: '<%=code%>',
    female: '<%=female%>',
    wave: '<%=wave%>'
  })

  if (API.getGlobal().female == 1) { 
    API.addGlobal({
      femaleT:  'ת' ,
      femaleA:  'ה' ,
      femaleN:  'נ' ,
      femaleI:  'י' ,
      femaleIA: 'י' ,
      femaleK:  'כ' ,
      femaleM:  'מ' 
    });
  } else {
     API.addGlobal({
      femaleT:  '',
      femaleA:  '',
      femaleN:  'ן',
      femaleI:  '',
      femaleIA: 'ה',
      femaleK:  'ך',
      femaleM:  'ם'
    });
  }

console.log(API.getGlobal().$picode);
console.log(API.getGlobal().wave);
console.log(API.getGlobal().female);
  
  // Define all the tasks.
  API.addTasksSet({
    instructions: [{
      type: 'message', buttonText: 'המשך'
    }],

    instqiatsc: [{
      inherit: 'instructions',
      name: 'realstart',
      templateUrl: 'instqiat.sc.jst',
      title: 'מטלת סיווג',
      piTemplate: true,
      header: 'מטלת סיווג'
    }],

    instqiatse: [{
      inherit: 'instructions',
      name: 'instqiat.se',
      templateUrl: 'instqiat.se.jst',
      title: 'מטלת סיווג',
      piTemplate: true,
      header: 'מטלת סיווג'
    }],

    scqiat_m: [{
      type: 'pip', name: 'sc.qiat_m', version: '0.3', scriptUrl: 'sc.qiat_m.js'
    }],

    scqiat_f: [{
      type: 'pip', name: 'sc.qiat_f', version: '0.3', scriptUrl: 'sc.qiat_f.js'
    }],

    seqiat_m: [{
      type: 'pip', name: 'se.qiat_m', version: '0.3', scriptUrl: 'se.qiat_m.js'
    }],

    seqiat_f: [{
      type: 'pip', name: 'se.qiat_f', version: '0.3', scriptUrl: 'se.qiat_f.js'
    }],

    instrses: [{
      inherit: 'instructions',
      name: 'instrses',
      templateUrl: 'instrses.jst',
      title: 'שאלון',
      piTemplate: true,
      header: 'שאלון'
    }],

    rses: [{
      type: 'quest', name: 'rses', scriptUrl: 'rses.js'
    }],

    instbsi: [{
      inherit: 'instructions',
      name: 'instbsi',
      templateUrl: 'instbsi.jst',
      title: 'שאלון',
      piTemplate: true,
      header: 'שאלון'
    }],

    bsi: [{
      type: 'quest', name: 'bsi', scriptUrl: 'bsi.js'
    }],

    instfscrs: [{
      inherit: 'instructions',
      name: 'instfscrs',
      templateUrl: 'instfscrs.jst',
      title: 'שאלון',
      piTemplate: true,
      header: 'שאלון'
    }],

    fscrs: [{
      type: 'quest', name: 'fscrs', scriptUrl: 'fscrs.js'
    }],

    instcesd: [{
      inherit: 'instructions',
      name: 'instcesd',
      templateUrl: 'instcesd.jst',
      title: 'שאלון',
      piTemplate: true,
      header: 'שאלון'
    }],

    cesd: [{
      type: 'quest', name: 'cesd', scriptUrl: 'cesd.js'
    }],

    lastpage: [{
      type: 'message', name: 'lastpage', templateUrl: 'lastpage.jst', piTemplate: true, last: true
    }]
  })

  API.addSequence([
    {// SC qIAT instructions
      inherit: 'instqiatsc'
    },
    {// SC qIAT
      mixer: 'branch',
      conditions: [ {compare: 'global.female', to: '1'} ],
      data: [
         {inherit: 'scqiat_f'}
      ],
      elseData: [
         {inherit: 'scqiat_m'}
      ]
    },
    {// randomize
      mixer: 'random',
      data: [
        {// CESD
          mixer: 'wrapper',
          data: [
            {inherit: 'instcesd'},
            {inherit: 'cesd'}
          ]
        },
        {// FSCRS
          mixer: 'wrapper',
          data: [
            {inherit: 'instfscrs'},
            {inherit: 'fscrs'}
          ]
        },
        {// RSES
          mixer: 'wrapper',
          data: [
            {inherit: 'instrses'},
            {inherit: 'rses'}
          ]
        },
        {// BSI
          mixer: 'wrapper',
          data: [
            {inherit: 'instbsi'},
            {inherit: 'bsi'}
          ]
        }
      ]},
    {// SE qIAT instructions
      inherit: 'instqiatse'
    },
    {// SE qIAT
      mixer: 'branch',
      conditions: [ {compare: 'global.female', to: '1'} ],
      data: [
         {inherit: 'seqiat_f'}
      ],
      elseData: [
         {inherit: 'seqiat_m'}
      ]
    },
     {// lastpage
      inherit: 'lastpage' 
    }
  ])
  return API.script
})
