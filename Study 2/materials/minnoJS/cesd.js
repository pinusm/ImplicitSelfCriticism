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
        { text: 'רוב הזמן', value: 3 }, // ==> 3
        { text: 'לפעמים', value: 2 }, // ==> 2
        { text: 'בחלק קטן מהזמן', value: 1 }, // ==> 1
        { text: 'לעיתים נדירות', value: 0 } // ==> 0
      ],
      help: '<%= pagesMeta.number < 3 %>',
      helpText: '<p style="text-align:right; direction:rtl">טיפ: למענה מהיר לחצו פעמיים ברציפות על התשובה.</p>',
      stemCss: { 'text-align': 'right', 'direction': 'rtl' }
    })

  API.addQuestionsSet('cesdset',
    [
      {
        inherit: 'basicSelect',
        name: 'cesdQ01',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>הייתי מוטרד<%=global.femaleT%> בשל דברים שבדרך כלל לא מטרידים אותי. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ02',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>לא היה לי חשק לאכול. לא היה לי תאבון. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ03',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>הרגשתי שאני לא יכול<%=global.femaleA%> להיפטר ממצבי רוח, אפילו לא בעזרת משפחתי או חברי. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ04',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>הרגשתי שאני טוב<%=global.femaleA%> בדיוק כמו כל אחד אחר. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ05',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>היה לי קשה להתרכז בדברים שאני עושה. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ06',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>הרגשתי מדוכא<%=global.femaleT%>. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ07',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>הרגשתי שכל מה שאני עושה דורש מאמץ. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ08',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>הרגשתי מלא<%=global.femaleT%> תקווה בקשר לעתיד. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ09',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>חשבתי שחיי הם כישלון. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ10',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>הרגשתי מפוחד<%=global.femaleT%>. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ11',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>השינה שלי לא היתה שקטה. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ12',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>הייתי מאושר<%=global.femaleT%>. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ13',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>דיברתי פחות מהרגיל. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ14',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>הרגשתי בודד<%=global.femaleA%>. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ15',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>אנשים לא היו ידידותיים כלפי. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ16',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>נהנתי מהחיים. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ17',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>היו לי התפרצויות בכי. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ18',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>הרגשתי עצוב<%=global.femaleA%>. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ19',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>הרגשתי שאנשים לא מחבבים אותי. '
      },
      {
        inherit: 'basicSelect',
        name: 'cesdQ20',
        stem: 'במהלך <u>השבועיים האחרונים</u>, כולל היום<br/>לא יכולתי "להזיז את עצמי". '
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
        times: 20,
        data:
          [
            {
              inherit: 'basicPage',
              questions: { inherit: { set: 'cesdset', type: 'exRandom' } }
            }
          ]
      }
    ])

  /**
  Return the script to piquest's god, or something of that sort.
  **/
  return API.script
})


