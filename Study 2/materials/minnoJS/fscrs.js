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
        { text: 'מאוד נכון לגבי עצמי', value: 4 }, // ==> 4
        { text: 'נכון לגבי עצמי', value: 3 }, // ==> 3
        { text: 'נכון לגבי עצמי באופן בינוני', value: 2 }, // ==> 2
        { text: 'קצת נכון לגבי עצמי', value: 1 }, // ==> 1
        { text: 'כלל לא נכון לגבי עצמי', value: 0 } // ==> 0
      ],
      help: '<%= pagesMeta.number < 3 %>',
      helpText: '<p style="text-align:right; direction:rtl">טיפ: למענה מהיר לחצו פעמיים ברציפות על התשובה.</p>',
      stemCss: { 'text-align': 'right', 'direction': 'rtl' }
    })

  API.addQuestionsSet('fscrsset',
    [
      {
        inherit: 'basicSelect',
        name: 'fscrsQ01',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני מתאכזב<%=global.femaleT%> מעצמי בקלות </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ02',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>יש בי חלק ש"יורד" על עצמי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ03',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני יכול<%=global.femaleA%> להזכיר לעצמי שיש בי צדדים חיוביים </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ04',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני מתקשה לשלוט ברגשות של כעס ותסכול שיש לי כלפי עצמי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ05',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>קל לי לסלוח לעצמי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ06',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>יש בי חלק שמרגיש שאני לא מספיק טוב<%=global.femaleA%> </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ07',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני מרגיש<%=global.femaleA%> מובס<%=global.femaleT%> ומוכה על ידי מחשבות ביקורתיות כלפי עצמי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ08',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני ממשי<%=global.femaleK%><%=global.femaleA%> לאהוב להיות אני  </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ09',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני כל כך כועס<%=global.femaleT%> על עצמי שאני מרגיש<%=global.femaleA%> צורך לפגוע או לפצוע בעצמי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ10',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>יש לי תחושה של גועל מעצמי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ11',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני עדיין מסוגל<%=global.femaleT%> להרגיש נאהב<%=global.femaleT%> ומקובל<%=global.femaleT%> </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ12',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>מפסיק להיות איכפת לי מעצמי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ13',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני מרגיש<%=global.femaleA%> שקל לי לאהוב את עצמי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ14',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני נזכר<%=global.femaleT%> בכישלונות שלי ולא מפסיק<%=global.femaleA%> לחשוב עליהם </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ15',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני מכנה את עצמי בשמות </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ16',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני עדי<%=global.femaleN%><%=global.femaleA%> ותומ<%=global.femaleK%><%=global.femaleT%> בעצמי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ17',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אינני מסוגל<%=global.femaleT%> לקבל כשלונות מבלי להרגיש לקוי<%=global.femaleA%> או פגו<%=global.femaleM%><%=global.femaleA%> </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ18',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני מאמי<%=global.femaleN%><%=global.femaleA%> שביקורת עצמית מגיעה לי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ19',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני מסוגל<%=global.femaleT%> לטפל ולדאוג לעצמי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ20',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>יש בי חלק שרוצה להיפטר מהחלקים שאני לא אוהב<%=global.femaleT%> בעצמי </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ21',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני מעודד<%=global.femaleT%> את עצמי לקראת העתיד </b>'
      },
      {
        inherit: 'basicSelect',
        name: 'fscrsQ22',
        stem: 'כאשר דברים לא מצליחים לי <br/><b>אני לא אוהב<%=global.femaleT%> להיות אני </b>'
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
        times: 22,
        data:
          [
            {
              inherit: 'basicPage',
              questions: { inherit: { set: 'fscrsset', type: 'exRandom' } }
            }
          ]
      }
    ])

  /**
  Return the script to piquest's god, or something of that sort.
  **/
  return API.script
})
