/* jshint asi: true */
/* global define:true */
define(['questAPI'], function (Quest) {
  var API = new Quest()

  /**
  Settings
  **/
  API.addSettings('logger',
    {
      url: '/implicit/PiQuest'
    })
  /* API.addSettings('DEBUG', {
        tags: 'all',
        level: 'debug'
    }); */

  /**
  Questions
  **/
  API.addQuestionsSet('basicSelect',
    {
      type: 'selectOne',
      style: 'multiButtons',
      minWidth: '23%',
      autoSubmit: true,
      numericValues: true,
      required: true,
      decline: false,
      errorMsg: {
        required: 'אנא בחרו תשובה'
      },
      answers: [
        { text: 'מאוד מסכי<%=global.femaleM%><%=global.femaleA%>', value: 3 }, // ==> 3
        { text: 'מסכי<%=global.femaleM%><%=global.femaleA%>', value: 2 }, // ==> 2
        { text: 'לא מסכי<%=global.femaleM%><%=global.femaleA%>', value: 1 }, // ==> 1
        { text: 'מאוד לא מסכי<%=global.femaleM%><%=global.femaleA%>', value: 0 } // ==> 0
      ],
      help: '<%= pagesMeta.number < 3 %>',
      helpText: '<p style="text-align:right; direction:rtl">טיפ: למענה מהיר לחצו פעמיים ברציפות על התשובה.</p>',
      stemCss: { 'text-align': 'right', 'direction': 'rtl' }
    })

  API.addQuestionsSet('rsesset',
    [
      {
        inherit: 'basicSelect',
        name: 'rsesQ01',
        stem: 'אני מרגיש<%=global.femaleA%> שאני אדם בעל ערך, לפחות כמו אנשים אחרים'
      },
      {
        inherit: 'basicSelect',
        name: 'rsesQ02',
        stem: 'אני מרגיש<%=global.femaleA%> שיש לי מספר תכונות טובות'
      },
      {
        inherit: 'basicSelect',
        name: 'rsesQ03',
        stem: 'אני מסוגל<%=global.femaleT%> לעשות דברים כמו רב האנשים'
      },
      {
        inherit: 'basicSelect',
        name: 'rsesQ04',
        stem: 'אני נוקט<%=global.femaleT%> בגישה חיובית כלפי עצמי'
      },
      {
        inherit: 'basicSelect',
        name: 'rsesQ05',
        stem: 'באופן כללי, אני מרוצה מעצמי'
      },
      {
        inherit: 'basicSelect',
        name: 'rsesQ06',
        stem: 'סך הכול, אני נוטה להרגיש שאני כישלון'
      },
      {
        inherit: 'basicSelect',
        name: 'rsesQ07',
        stem: 'אני מרגיש<%=global.femaleA%> שאין לי הרבה דברים להתגאות בהם'
      },
      {
        inherit: 'basicSelect',
        name: 'rsesQ08',
        stem: 'הלוואי והיה לי יותר כבוד כלפי עצמי'
      },
      {
        inherit: 'basicSelect',
        name: 'rsesQ09',
        stem: 'אני בהחלט מרגיש<%=global.femaleA%> חסר<%=global.femaleT%> תועלת לעיתים'
      },
      {
        inherit: 'basicSelect',
        name: 'rsesQ10',
        stem: 'לעיתים אני חושב<%=global.femaleT%> שאני לא שווה כלל'
      }
    ])

  /**
  Pages
  **/
  API.addPagesSet('basicPage',
    {
      progressBar: '<p style="direction:rtl"><%= pagesMeta.number %> מתוך <%= pagesMeta.outOf%></p>',
      header: 'שאלון',
      headerStyle: { 'font-size': '1em', 'text-align': 'center', 'direction': 'rtl' },
      submitText: 'המשך',
      v1style: 2,
      numbered: false,
      noSubmit: false // Change to true if you don't want to show the submit button.
    })

  /**
  Sequence
  **/
  API.addSequence(
    [
      {
        mixer: 'repeat',
        times: 10,
        data:
          [
            {
              inherit: 'basicPage',
              questions: { inherit: { set: 'rsesset', type: 'exRandom' } }
            }
          ]
      }
    ])

  /**
  Return the script to piquest's god, or something of that sort.
  **/
  return API.script
})
