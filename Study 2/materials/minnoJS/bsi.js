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
      minWidth: '19%',
      autoSubmit: true,
      numericValues: true,
      required: true,
      decline: false,
      errorMsg: {
        required: 'אנא בחרו תשובה'
      },
      answers: [
        { text: 'מאוד', value: 4 }, // ==> 4
        { text: 'במידה רבה', value: 3 }, // ==> 3
        { text: 'במידה בינונית', value: 2 }, // ==> 2
        { text: 'במקצת', value: 1 }, // ==> 1
        { text: 'בכלל לא', value: 0 } // ==> 0
      ],
      help: '<%= pagesMeta.number < 3 %>',
      helpText: '<p style="text-align:right; direction:rtl">טיפ: למענה מהיר לחצו פעמיים ברציפות על התשובה.</p>',
      stemCss: { 'text-align': 'right', 'direction': 'rtl' }
    })

  API.addQuestionsSet('bsiset',
    [
      {
        inherit: 'basicSelect',
        name: 'bsiQ01',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/>עצבנות '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ02',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/>הרגשת עילפון או סחרחורת '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ03',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/>מחשבה שמישהו אחר יכול לשלוט על מחשבותיך '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ04',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/>הרגשה שאחרים אשמים בבעיות שלך '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ05',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/>קשיים בזיכרון '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ06',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/>מתרגז<%=global.femaleT%> ומתעצב<%=global.femaleN%><%=global.femaleT%> מהר '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ07',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/>כאבים בלב או בחזה '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ08',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/>פחד ממקומות פתוחים '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ09',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/>מחשבות לשים קץ לחייך '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ10',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשה שאי אפשר לסמוך על מרבית האנשים '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ11',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> חוסר תאבון '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ12',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשת פחד פתאומי ללא סיבה '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ13',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> התפרצויות זעם שלא יכולת לשלוט בהן '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ14',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשת בדידות גם כשהינך בחברת אנשים '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ15',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשה שמשהו מפריע לך לבצע דברים '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ16',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשת בדידות '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ17',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> מצוברח<%=global.femaleT%> '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ18',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> חוסר עניין בדברים '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ19',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשת פחד '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ20',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הנך נפגע<%=global.femaleT%> בקלות '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ21',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשה שאנשים אינם ידידותיים או שאינם מסמפטים אותך '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ22',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשה שהנך נחות<%=global.femaleA%> מאחרים '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ23',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> בחילה או אי-שקט בבטן '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ24',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשה שאנשים מסתכלים או מדברים עליך '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ25',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> קושי להירדם '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ26',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> צורך לחזור ולבדוק מה שעשית '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ27',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> קושי בהחלטה '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ28',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> פחד לנסוע באוטובוס או ברכבת '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ29',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> קושי בנשימה '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ30',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> גלי חום או קור '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ31',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> צורך להמנע ממקומות או מפעולות אשר מפחידים אותך '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ32',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> שהראש נעשה ריק '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ33',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> שהגפיים כאילו מאובנות או דקירות בחלקים שונים של הגוף '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ34',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> מחשבה שמגיע לך עונש על חטאיך '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ35',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> חוסר תקווה לגבי העתיד'
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ36',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> קשיי ריכוז '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ37',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשת חולשה בחלקים מגופך '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ38',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשת מתח '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ39',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> מחשבות על מוות '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ40',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> דחף להכות, לפצוע או להזיק למישהו '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ41',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> דחף לשבור ולהפוך דברים '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ42',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשת מבוכה בחברה '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ43',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשת אי נוחות פנימית '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ44',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> חוסר הרגשת קרבה לאנשים '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ45',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> התקפי פחד או פאניקה '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ46',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> נכנס<%=global.femaleT%> לויכוחים מהירים '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ47',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשת עצבנות כשהינך נשאר<%=global.femaleT%> לבד '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ48',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> שהאחרים אינם מעריכים כראוי את הישגיך '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ49',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> חוסר שקט כזה שאינך יכול<%=global.femaleA%> לשבת במקום אחד '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ50',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשת חוסר ערך '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ51',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשה שאנשים ינצלו אותך (אם תת<%=global.femaleN%><%=global.femaleI%> להם) '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ52',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשות אשמה '
      },
      {
        inherit: 'basicSelect',
        name: 'bsiQ53',
        stem: 'בחודש האחרון, <b>כולל היום</b>, עד כמה סבלת מ:<br/> הרגשה שמשהו לא בסדר עם הראש שלך '
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
        times: 53,
        data:
          [
            {
              inherit: 'basicPage',
              questions: { inherit: { set: 'bsiset', type: 'exRandom' } }
            }
          ]
      }
    ])

  /**
  Return the script to piquest's god, or something of that sort.
  **/
  return API.script
})
