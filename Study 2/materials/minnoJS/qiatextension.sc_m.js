/* jshint esversion: 5 */
/* jshint maxerr: 1000 */
/* jshint asi: true */
/* global define:true */
define(['pipAPI', 'pipScorer', 'underscore'], function (APIConstructor, Scorer, _) {
  /**
  Created by: Yoav Bar-Anan (baranan@gmail.com). Modified by Elad for IAT, and by Michael Pinus (pinusm@post.bgu.ac.il) for qIAT
   * @param  {Object} options Options that replace the defaults...
   * @return {Object}         PIP script
  **/

  // TODO 11/03/2018:
  // none at the moment

  // use the 'typePairing' variable as one of the sentences in the debriefing. It results a sentence such as:
  // "במטלה שביצעת, 'Typ הקטגוריהe 1' depicted a person ייצגה אדם בעלesteem, and 'Type 2'והקטגוריה icted a person with low seייצגה אדם בעל

  // taken from: http://heyjavascript.com/4-creative-ways-to-clone-objects/
  // recursive function to clone an object. If a non object parameter
  // is passed in, that parameter is returned and no recursion occurs.
  function cloneObject (obj) {
    if (obj === null || typeof obj !== 'object') {
      return obj
    }

    var temp = obj.constructor() // give temp the original obj's constructor
    for (var key in obj) {
      temp[key] = cloneObject(obj[key])
    }

    return temp
  }

  function qiatExtension (options) {
    var API = new APIConstructor()
    var scorer = new Scorer()
    var piCurrent = API.getCurrent()

    // Here we set the settings of our task.
    // Read the comments to learn what each parameters means.
    // You can also do that from the outside, with a dedicated jsp file.
    var qiatObj = {
      istouch: false, // Set whether the task is on a touch device.
      // Set the canvas of the task
      canvas: {
        maxWidth: 825,
        proportions: 0.7,
        background: '#ffffff',
        borderWidth: 5,
        canvasBackground: '#ffffff',
        borderColor: 'lightblue'
      },
      category1: {
        name: 'highSC', // Will appear in the debrifing and the data.
        title: {
          // media : {word : "Type 1"}, //Name of the category presented in the task. if commented out, 'Type 1' or 'Type 2' will be assigned randomly. Has an effect only if both category disply names and both hints are provided. You will also have to configure topLabel/bottomLabel and topInventory/bottomInventory below...
          // hint : {word : " - 1"}, //Hint appened to the stimuli of this category in the hinted practice block. if commented out, 'Type 1' or 'Type 2' will be assigned randomly, and the hint will be added accordingly. Has an effect only if both category disply names and both hints are provided. You will also have to configure topLabel/bottomLabel and topInventory/bottomInventory below...
          css: {color: '#336600', 'font-size': '1.8em'}, // Style of the category title.
          height: 4 // Used to position the "Or" in the combined block.

        },
        stimulusMedia: [ // Stimuli content as PIP's media objects
          {word: 'קיים הבדל ניכר בין איך שאני היום ואיך שהייתי רוצה להיות'},
          {word: 'אני נוטה לא להיות מרוצה ממה שיש לי'},
          {word: 'קשה לי לקבל את החולשות שלי'},
          {word: 'לעיתים קרובות אני משווה את עצמי לסטנדרטים או מטרות'},
          {word: 'יש לי נטייה להיות מאוד ביקורתי כלפי עצמי'}
        ],
        // Stimulus css (style)
        stimulusCss: {color: '#336600', 'font-size': '2.3em'}
      },
      category2: {
        name: 'lowSC', // Will appear in the debrifing and the data.
        title: {
          // media : {word : "Type 2"}, //Name of the category presented in the task. if commented out, 'Type 1' or 'Type 2' will be assigned randomly. Has an effect only if both category disply names and both hints are provided. You will also have to configure topLabel/bottomLabel and topInventory/bottomInventory below...
          // hint : {word : " - 2"}, //Hint appened to the stimuli of this category in the hinted practice block. if commented out, 'Type 1' or 'Type 2' will be assigned randomly, and the hint will be added accordingly. Has an effect only if both category disply names and both hints are provided. You will also have to configure topLabel/bottomLabel and topInventory/bottomInventory below...
          css: {color: '#336600', 'font-size': '1.8em'}, // Style of the category title.
          height: 4 // Used to position the "Or" in the combined block.

        },
        stimulusMedia: [ // Stimuli content as PIP's media objects
          {word: 'אין הבדל ניכר בין איך שאני היום ואיך שהייתי רוצה להיות'},
          {word: 'אני נוטה להיות מרוצה ממה שיש לי'},
          {word: 'לא קשה לי לקבל את החולשות שלי'},
          {word: 'רק לעיתים רחוקות אני משווה את עצמי לסטנדרטים או מטרות'},
          {word: 'אין לי נטייה להיות מאוד ביקורתי כלפי עצמי'}
        ],
        // Stimulus css
        stimulusCss: {color: '#336600', 'font-size': '2.3em'}
      },
      attribute2:
      {
        name: 'אמת',
        title: {
          media: {word: 'אמת'},
          css: {color: '#0000FF', 'font-size': '1.8em'},
          height: 4 // Used to position the "Or" in the combined block.
        },
        stimulusMedia: [ // Stimuli content as PIP's media objects
          {word: 'אני ממיין משפטים'},
          {word: 'אני מסתכל על מסך מחשב'},
          {word: 'אני משתתף בניסוי בפסיכולוגיה'},
          {word: 'האצבעות שלי על המקלדת'},
          {word: 'אני יושב מול מחשב'}
        ],
        // Stimulus css
        stimulusCss: {color: '#0000FF', 'font-size': '2.3em'}
      },
      attribute1:
      {
        name: 'שקר',
        title: {
          media: {word: 'שקר'},
          css: {color: '#0000FF', 'font-size': '1.8em'},
          height: 4 // Used to position the "Or" in the combined block.
        },
        stimulusMedia: [ // Stimuli content as PIP's media objects
          {word: 'אני מטפס על הר תלול'},
          {word: 'אני יושב על החול בחוף הים'},
          {word: 'אני מנגן בגיטרה החשמלית שלי'},
          {word: 'אני משחק כדורגל על הדשא'},
          {word: 'אני קונה עכשיו מצרכים במכולת השכונתית'}
        ],
        // Stimulus css
        stimulusCss: {color: '#0000FF', 'font-size': '2.3em'}
      },
      nBlocks: 8, // Should be 8, to account for the 2a,2b split in block 2
      /// /In each block, we can include a number of mini-blocks, to reduce repetition of same group/response.
      blockAttributes_nTrials: 20,
      blockAttributes_nMiniBlocks: 5,
      blockCategoriesPractice_ntrials: 20,
      blockCategoriesPractice_nMiniblocks: 5,
      blockCategories_nTrials: 40,
      blockCategories_nMiniBlocks: 10,
      blockFirstCombined_nTrials: 20,
      blockFirstCombined_nMiniBlocks: 5,
      blockSecondCombined_nTrials: 40, // Not used if nBlocks=5.
      blockSecondCombined_nMiniBlocks: 10, // Not used if nBlocks=5.
      blockSwitch_nTrials: 40,
      blockSwitch_nMiniBlocks: 10,

      // Should we randomize which attribute is on the right, and which on the left?
      randomAttSide: false, // Accepts 'true' and 'false'. If false, then attribute2 on the right.

      // Should we randomize which category is on the right first?
      randomBlockOrder: true, // Accepts 'true' and 'false'. If false, then category1 on the left first.
      // Note: the player sends block4Cond at the end of the task (saved in the explicit table) to inform about the categories in that block.
      // In the block4Cond variable: "att1/cat1,att2/cat2" means att1 and cat1 on the left, att2 and cat2 on the right.

      // Show a reminder what to do on error, throughout the task
      remindError: true,

      remindErrorText: '<p dir="rtl" align="center" style="font-size:"0.6em"; font-family:arial">' +
      'אם תבצע טעות יופיע על המסך <font color="#ff0000"><b>X</b></font>. ' +
      'תקן את הטעות בעזרת המקש האחר.<p/>',

      remindErrorTextTouch: '<p dir="rtl" align="center" style="font-size:"1.4em"; font-family:arial">' +
      'אם תבצע טעות יופיע על המסך <font color="#ff0000"><b>X</b></font>. ' +
      'תקן את הטעות בעזרת המקש האחר.<p/>',

      errorCorrection: true, // Should participants correct error responses?
      errorFBDuration: 500, // Duration of error feedback display (relevant only when errorCorrection is false)
      ITIDuration: 250, // Duration between trials.

      fontColor: '#000000', // The default color used for printed messages.

      // Text and style for key instructions displayed about the category labels.
      leftKeyText: 'הקש על המקש "E" עבור',
      rightKeyText: 'הקש על המקש "I" עבור',
      keysCss: {'font-size': '0.8em', 'font-family': 'courier', color: '#000000'},
      // Text and style for the separator between the top and bottom category labels.
      orText: 'או',
      orCss: {'font-size': '1.8em', color: '#000000'},

      instWidth: 99, // The width of the instructions stimulus

      finalText: 'להמשך, נא ללחוץ על רווח',
      finalTouchText: 'Touch the bottom green area to continue to the next task',

      touchMaxStimulusWidth: '50%',
      touchMaxStimulusHeight: '50%',
      bottomTouchCss: {}, // Add any CSS value you want for changing the css of the bottom touch area.

      // Instructions text.
      // You can use the following variables and they will be replaced by
      // the name of the categories and the block's number variables:
      // leftCategory, rightCategory, leftAttribute and rightAttribute, blockNum, nBlocks.
      // Notice that this is HTML text.
      instAttributePractice: '<div dir="rtl"><p align="center" style="font-size:20px; font-family:arial">' +
        '<font color="#000000"><u>סיבוב blockNum מתוך nBlocks </u><br/><br/></p>' +
        '<p style="font-size:20px; text-align:right; vertical-align:bottom; margin-left:10px; font-family:arial">' +
        '<font size="4.4px">הקש על המקש <b>E</b> כאשר הפריט מתאים לקטגוריה <font color="#0000ff">leftAttribute.</font>' +
        '<br/><font size="4.4px">הקש על המקש <b>I</b> כאשר הפריט מתאים לקטגוריה <font color="#0000ff">rightAttribute</font>.<br/><br/>' +
        'אם תבצע טעות יופיע על המסך <font color="#ff0000"><b>X</b></font>. ' +
        'תקן את הטעות בעזרת המקש האחר.<br/>' +
        'השתדל למיין <u>מהר ככל האפשר</u> אבל עם כמה שפחות טעויות.<br/><br/></p>' +
        '<p align="center">להמשך, נא ללחוץ על רווח</font></p></div>',
      instAttributePracticeTouch: [
        '<div dir="rtl">',
        '<p align="center">',
        '<u>סיבוב blockNum מתוך nBlocks</u>',
        '</p>',
        '<p align="right" style="margin-right:5px">',
        '<br/>',
        '<font size="4.4px">Put a left finger over the the <b>left</b> green area for statements that belong to the category <font color="#0000ff">leftAttribute</font>.<br/>',
        '<font size="4.4px">Put a right finger over the <b>right</b> green area for statements that belong to the category <font color="#0000ff">rightAttribute</font>.<br/>',
        'Statements will appear one at a time.<br/>',
        '<br/>',
        'If you make a mistake, a red <font color="#ff0000"><b>X</b></font> will appear. Touch the other side. <u>Go as fast as you can</u> while being accurate.',
        '</p>',
        '<p align="center">Touch the <b>lower </b> green area to start.</p>',
        '</div>'
      ].join('\n'),

      instCategoriesPracticeHinted: '<div dir="rtl"><p align="center" style="font-size:20px; font-family:arial">' +
        '<font color="#000000"><u>סיבוב blockNum מתוך nBlocks </u><br/><br/></p>' +
        '<p style="font-size:20px; text-align:right; vertical-align:bottom; margin-left:10px; font-family:arial">' +
        'שים לב, בסיבוב הבא הקטגוריות שבראש המסך שונות, אך המשימה זהה.<br/> ' +
        'כעת יופיעו פריטים מהקטגוריה <font color="#336600">leftCategory</font> ופריטים מהקטגוריה <font color="#336600">rightCategory</font>. ' +
        'בחלק זה של המטלה, יופיע רמז עם כל משפט, על מנת לעזור לך לסווג אותו, וללמוד את הקטגוריות. ' +
        'בחלקים הבאים של המטלה הרמז לא יופיע.<br/><br/>' +
        '<font size="4.4px">הקש על המקש <b>E</b> כאשר הפריט מתאים לקטגוריה <font color="#336600">leftCategory.</font>' +
        '<br/><font size="4.4px">הקש על המקש <b>I</b> כאשר הפריט מתאים לקטגוריה <font color="#336600">rightCategory</font>.<br/><br/>' +
        'מטרת החלק הזה של המטלה היא אימון ולמידה של הקטגוריות. לכן, מהירות התגובה אינה חשובה.<br/><br/>' +
        '<p align="center">להמשך, נא ללחוץ על רווח</font></p></div>',
      instCategoriesPracticeTouchHinted: [
        '<div dir="rtl">',
        '<p align="center">',
        '<u>סיבוב blockNum מתוך nBlocks</u>',
        '</p>',
        '<p align="right" style="margin-right:5px">',
        '<br/>',
        'Notice: the categories have changed.<br/>',
        'We will show you <font color="#336600">leftCategory</font> statements and <font color="#336600">rightCategory</font> statements. ',
        "We know that you don't know these categories yet, so we will give you a hint what statements belong to each category,",
        'until you learn which statements go with each category.<br/><br/>',
        '<font size="4.4px">Put a left finger over the <b>left</b> green area for statements that belong to the category <font color="#336600">leftCategory</font>.<br/>',
        '<font size="4.4px">Put a right finger over the <b>right</b> green area for statements that belong to the category <font color="#336600">rightCategory</font>.<br/>',
        '<p align="center">Touch the <b>lower </b> green area to start.</p>',
        '</div>'
      ].join('\n'),

      instCategoriesPractice: '<div dir="rtl"><p align="center" style="font-size:20px; font-family:arial">' +
        '<font color="#000000"><u>סיבוב blockNum מתוך nBlocks </u><br/><br/></p>' +
        '<p style="font-size:20px; text-align:right; vertical-align:bottom; margin-left:10px; font-family:arial">' +
        'האם אתה זוכר איזה פריטים מתאימים לטיפוסים השונים?<br/>' +
        'שים לב, המשימה בסיבוב הבא זהה למשימה בסיבוב הקודם, אך כעת לא יופיעו רמזים.<br/>' +
        'עליך למיין את הפריטים המופיעים במרכז המסך לאחת הקטגוריות המופיעות בראש המסך.<br/>' +
        '<font size="4.4px">הקש על המקש <b>E</b> כאשר הפריט מתאים לקטגוריה <font color="#336600">leftCategory.</font>' +
        '<br/><font size="4.4px">הקש על המקש <b>I</b> כאשר הפריט מתאים לקטגוריה <font color="#336600">rightCategory</font>.<br/><br/>' +
        'אם תבצע טעות יופיע על המסך <font color="#ff0000"><b>X</b></font>. ' +
        'תקן את הטעות בעזרת המקש האחר.<br/>' +
        'השתדל למיין <u>מהר ככל האפשר</u> אבל עם כמה שפחות טעויות.<br/><br/></p>' +
        '<p align="center">להמשך, נא ללחוץ על רווח</font></p></div>',

      instCategoriesPracticeTouch: [
        '<div dir="rtl">',
        '<p align="center">',
        '<u>סיבוב blockNum מתוך nBlocks</u>',
        '</p>',
        '<p align="right" style="margin-right:5px">',
        '<br/>',
        'Did you learn what statements go with each type?<br/>',
        'The next part is just like the previous part, but without hints.<br/>',
        'See whether you are able to tell us which statement goes with each category.<br/>',
        '<br/><font size="4.4px">Put a left finger over the <b>left</b> green area for statements that belong to the category <font color="#336600">leftCategory</font>.<br/>',
        '<font size="4.4px">Put a right finger over the <b>right</b> green area for statements that belong to the category <font color="#336600">rightCategory</font>.<br/>',
        'If you make a mistake, a red <font color="#ff0000"><b>X</b></font> will appear. Touch the other side. <u>Go as fast as you can</u> while being accurate.',
        '</p>',
        '<p align="center">Touch the <b>lower </b> green area to start.</p>',
        '</div>'
      ].join('\n'),

      instFirstCombined: '<div dir="rtl"><p align="center" style="font-size:20px; font-family:arial">' +
        '<font color="#000000"><u>סיבוב blockNum מתוך nBlocks </u><br/><br/></p>' +
        '<p style="font-size:20px; text-align:right; vertical-align:bottom; margin-left:10px; font-family:arial">' +
        'בסיבוב הבא תמיין פריטים לארבע הקטגוריות אליהן מיינת פריטים בסיבובים הקודמים.<br/>' +
        '<u>כל פריט מתאים לקטגוריה אחת בלבד.</u> <br/><br/>' +
        'הקש על המקש <b>E</b> עבור פריטים השייכים לקטגוריה <font color="#336600">leftCategory</font> או לקטגוריה <font color="#0000ff">leftAttribute</font>.<br/>' +
        'הקש על המקש <b>I</b> עבור פריטים השייכים לקטגוריה <font color="#336600">rightCategory</font> או לקטגוריה <font color="#0000ff">rightAttribute</font>.<br/>' +
        '<br/>' +
        'אם תבצע טעות יופיע על המסך <font color="#ff0000"><b>X</b></font>. ' +
        'תקן את הטעות בעזרת המקש האחר.<br/>' +
        'השתדל למיין <u>מהר ככל האפשר</u> אבל עם כמה שפחות טעויות.<br/><br/></p>' +
        '<p align="center">להמשך, נא ללחוץ על רווח</font></p></div>',
      instFirstCombinedTouch: [
        '<div dir="rtl">',
        '<p align="center">',
        '<u>סיבוב blockNum מתוך nBlocks</u>',
        '</p>',
        '<br/>',
        '<br/>',
        '<p align="right" style="margin-right:5px">',
        'NOTICE: The four categories you saw separately now appear together.<br/>',
        '<u>Each statement belongs to only one category.</u> <br/><br/>',
        '<font size="4.4px">Put a left finger over the <b>left</b> green area for <font color="#336600">leftCategory</font> statements and for <font color="#0000ff">leftAttribute</font>.</br>',
        '<font size="4.4px">Put a right finger over the <b>right</b> green area for <font color="#336600">rightCategory</font> statements and for <font color="#0000ff">rightAttribute</font>.</br>',
        '<br/>',
        'If you make a mistake, a red <font color="#ff0000"><b>X</b></font> will appear. Touch the other side. <u>Go as fast as you can</u> while being accurate.</br>',
        '</p>',
        '<p align="center">Touch the <b>lower </b> green area to start.</p>',
        '</div>'
      ].join('\n'),

      instSecondCombined: '<div dir="rtl"><p align="center" style="font-size:20px; font-family:arial">' +
        '<font color="#000000"><u>סיבוב blockNum מתוך nBlocks </u><br/><br/></p>' +
        '<p style="font-size:20px; text-align:right; vertical-align:bottom; margin-left:10px; font-family:arial">' +
        'המשימה בסיבוב הבא זהה למשימה בסיבוב הקודם.<br/>' +
        'הקש על המקש <b>E</b> עבור פריטים השייכים לקטגוריה <font color="#336600">leftCategory</font> או לקטגוריה <font color="#0000ff">leftAttribute</font>.<br/>' +
        'הקש על המקש <b>I</b> עבור פריטים השייכים לקטגוריה <font color="#336600">rightCategory</font> או לקטגוריה <font color="#0000ff">rightAttribute</font>.<br/>' +
        'כל פריט מתאים לקטגוריה אחת בלבד.<br/><br/>' +
        'השתדל למיין <u>מהר ככל האפשר</u> אבל עם כמה שפחות טעויות.<br/><br/></p>' +
        '<p align="center">להמשך, נא ללחוץ על רווח</font></p></div>',
      instSecondCombinedTouch: [
        '<div dir="rtl">',
        '<p align="center"><u>סיבוב blockNum מתוך nBlocks</u></p>',
        '<br/>',
        '<br/>',

        '<p align="right" style="margin-right:5px">',
        'This is the same as the previous part.<br/>',
        '<font size="4.4px">Put a left finger over the <b>left</b> green area for <font color="#336600">leftCategory</font> statements and for <font color="#0000ff">leftAttribute</font>.<br/>',
        '<font size="4.4px">Put a right finger over the <b>right</b> green area for <font color="#336600">rightCategory</font> statements and for <font color="#0000ff">rightAttribute</font>.<br/>',
        'Each sentence belongs to only one category.<br/><br/>',
        '<br/>',
        '<u>Go as fast as you can</u> while being accurate.<br/>',
        '</p>',
        '<p align="center">Touch the <b>lower </b> green area to start.</p>',
        '</div>'
      ].join('\n'),

      instSwitchCategories: '<div dir="rtl"><p align="center" style="font-size:20px; font-family:arial">' +
        '<font color="#000000"><u>סיבוב blockNum מתוך nBlocks </u><br/><br/></p>' +
        '<p style="font-size:20px; text-align:right; vertical-align:bottom; margin-left:10px; font-family:arial">' +
        '<b>שים לב, בסיבוב הבא הקטגוריות שבראש המסך החליפו צדדים, אך המשימה זהה!</b><br/>' +
        'הקש על המקש <b>E</b> עבור פריטים השייכים לקטגוריה <font color="#336600">leftCategory</font>.<br/>' +
        'הקש על המקש <b>I</b> עבור פריטים השייכים לקטגוריה <font color="#336600">rightCategory</font>.<br/>' +
        '<br/>' +
        'השתדל למיין <u>מהר ככל האפשר</u> אבל עם כמה שפחות טעויות.<br/><br/></p>' +
        '<p align="center">להמשך, נא ללחוץ על רווח</font></p></div>',
      instSwitchCategoriesTouch: [
        '<div dir="rtl">',
        '<p align="center">',
        '<u>סיבוב blockNum מתוך nBlocks</u>',
        '</p>',
        '<p align="right" style="margin-right:5px">',
        '<br/>',
        'Watch out, the labels have changed position!<br/>',
        '<font size="4.4px">Put a left finger over the <b>left</b> green area for <font color="#336600">leftCategory</font> statements.<br/>',
        '<font size="4.4px">Put a right finger over the <b>right</b> green area for <font color="#336600">rightCategory</font> statements.<br/>',
        'Statements will appear one at a time.',
        '<br/>',
        'If you make a mistake, a red <font color="#ff0000"><b>X</b></font> will appear. Touch the other side. <u>Go as fast as you can</u> while being accurate.<br/>',
        '</p>',
        '<p align="center">Touch the <b>lower </b> green area to start.</p>',
        '</div>'
      ].join('\n'),

      instThirdCombined: 'instFirstCombined', // this means that we're going to use the instFirstCombined property for the third combined block as well. You can change that.
      instFourthCombined: 'instSecondCombined', // this means that we're going to use the instSecondCombined property for the fourth combined block as well. You can change that.
      instThirdCombinedTouch: 'instFirstCombined', // this means that we're going to use the instFirstCombined property for the third combined block as well. You can change that.
      instFourthCombinedTouch: 'instSecondCombined', // this means that we're going to use the instSecondCombined property for the fourth combined block as well. You can change that.

      // The default feedback messages for each cutoff -
      // attribute1, and attribute2 will be replaced with the name of attribute1 and attribute2.
      // categoryA is the name of the category that is found to be associated with attribute1,
      // and categoryB is the name of the category that is found to be associated with attribute2.
      fb_strong_Att1WithCatA_Att2WithCatB: 'Your data suggest you strongly associate yourself with categoryB, over categoryA.',
      fb_moderate_Att1WithCatA_Att2WithCatB: 'Your data suggest you moderatly associate yourself with categoryB, over categoryA.',
      fb_slight_Att1WithCatA_Att2WithCatB: 'Your data suggest you sligthly associate yourself with categoryB, over categoryA.',
      fb_equal_CatAvsCatB: 'Your data suggest you do not associate yourself with categoryB, over categoryA.',

      // Error messages in the feedback
      manyErrors: 'There were too many errors made to determine a result.',
      tooFast: 'There were too many fast trials to determine a result.',
      notEnough: 'There were not enough trials to determine a result.'
    }

    var type1ascategory1 = []
    var category1name = []
    var category2name = []
    var category1append = []
    var category2append = []
    var manualCatDisplayNames = (typeof qiatObj.category1.title.media !== 'undefined' & typeof qiatObj.category2.title.media !== 'undefined' & typeof qiatObj.category1.title.hint !== 'undefined' & typeof qiatObj.category2.title.hint !== 'undefined')

    if (manualCatDisplayNames) { // The display names for the categories were defined manually (and properly)
      type1ascategory1 = 'no - manually defined'
      category1name = qiatObj.category1.title.media.word
      category2name = qiatObj.category2.title.media.word
      category1append = qiatObj.category1.title.hint.word
      category2append = qiatObj.category2.title.hint.word
    } else { // The display names for the categories were defined by the qiat extension
      type1ascategory1 = API.shuffle([true, false])[0]
      category1name = type1ascategory1 === true ? 'טיפוס 1' : 'טיפוס 2'
      category2name = type1ascategory1 === true ? 'טיפוס 2' : 'טיפוס 1'
      category1append = type1ascategory1 === true ? ' - 1' : ' - 2'
      category2append = type1ascategory1 === true ? ' - 2' : ' - 1'
      qiatObj.category1.title.media = { word: category1name }
      qiatObj.category2.title.media = { word: category2name }
      qiatObj.category1.title.hint = { word: category1append }
      qiatObj.category2.title.hint = { word: category2append }
    }

    // extend the "current" object with the default
    _.defaultsDeep(piCurrent, options, qiatObj)

    // shuffle the items of both atts and cats, to display in random order in the instructions
    // TODO

    API.addSettings('skip', true)
    API.addGlobal({
      type1ascategory1: type1ascategory1
    })
    API.save({
      type1ascategory1: API.getGlobal().type1ascategory1
    })

    piCurrent.category2practice = cloneObject(piCurrent.category2)
    piCurrent.category1practice = cloneObject(piCurrent.category1)
    // append the hints, and scale by number of stimuli in each category
    for (var i1 in piCurrent.category1practice.stimulusMedia) {
      piCurrent.category1practice.stimulusMedia[i1].word = piCurrent.category1practice.stimulusMedia[i1].word + category1append
    }
    for (var i2 in piCurrent.category2practice.stimulusMedia) {
      piCurrent.category2practice.stimulusMedia[i2].word = piCurrent.category2practice.stimulusMedia[i2].word + category2append
    }

    // create the instructions slides where all the statements are presented
    piCurrent.instAttributeInventory = '<div dir="rtl"><p align="center" style="font-size:20px; font-family:arial">' +
        '<font color="#000000"><u>סיבוב blockNum מתוך nBlocks </u><br/><br/></p>' +
        '<p style="font-size:20px; text-align:center; vertical-align:bottom; margin-left:10px; font-family:arial">' +
        '<font size="4.4px">Put a left finger on the <b>E</b> key for statements that belong to the category <font color="#0000ff">leftAttribute.</font>' +
        '<br/><font size="4.4px">Put a right finger on the <b>I</b> key for statements that belong to the category <font color="#0000ff">rightAttribute</font>.<br/><br/>' +
        'If you make a mistake, a red <font color="#ff0000"><b>X</b></font> will appear. ' +
        'Press the other key to continue.<br/>' +
        '<u>Go as fast as you can</u> while being accurate.<br/><br/></p>' +
        '<p align="center">Press the <b>space bar</b> when you are ready to start.</font></p></div>'
    piCurrent.instAttributeInventoryTouch = [
      '<div dir="rtl">',
      '<p align="center">',
      '<u>סיבוב blockNum מתוך nBlocks</u>',
      '</p>',
      '<p align="center" style="margin-right:5px">',
      '<br/>',
      '<font size="4.4px">Put a left finger over the the <b>left</b> green area for statements that belong to the category <font color="#0000ff">leftAttribute</font>.<br/>',
      '<font size="4.4px">Put a right finger over the <b>right</b> green area for statements that belong to the category <font color="#0000ff">rightAttribute</font>.<br/>',
      'Statements will appear one at a time.<br/>',
      '<br/>',
      'If you make a mistake, a red <font color="#ff0000"><b>X</b></font> will appear. Touch the other side. <u>Go as fast as you can</u> while being accurate.',
      '</p>',
      '<p align="center">Touch the <b>lower </b> green area to start.</p>',
      '</div>'
    ].join('\n')

    // create the instructions slides where all the statements are presented
    var att1stimuliobject = []
    for (stimuliobject of piCurrent.attribute1.stimulusMedia) {
      att1stimuliobject.push(stimuliobject.word)
    }
    // sets the prefix for the first element
    // concatenate the stimuli to a single string in html format
    var att1stimuliobjectHtml = [
      '<div dir="rtl" style="margin-left: auto; margin-right: auto; display: table; width: 700px;">',
      '<ul style="text-align: justify; margin: 10px 0; list-style-position:inside; list-style-type:disk;">',
      '<font color="#0000ff" size="4px">',
      '<li>',
      att1stimuliobject.join('</li><li>'),
      '</li></font></ul></div>'
    ].join('')

    var att2stimuliobject = []
    for (stimuliobject of piCurrent.attribute2.stimulusMedia) {
      att2stimuliobject.push(stimuliobject.word)
    }
    // sets the prefix for the first element
    // concatenate the stimuli to a single string in html format
    var att2stimuliobjectHtml = [
      '<div dir="rtl" style="margin-left: auto; margin-right: auto; display: table;  width: 700px;">',
      '<ul style="text-align: justify; margin: 10px 0; list-style-position:inside; list-style-type:disk;">',
      '<font color="#0000ff" size="4px">',
      '<li>',
      att2stimuliobject.join('</li><li>'),
      '</li></font></ul></div>'
    ].join('')

    var cat1stimuliobject = []
    for (stimuliobject of piCurrent.category1.stimulusMedia) {
      cat1stimuliobject.push(stimuliobject.word)
    }
    // sets the prefix for the first element
    // concatenate the stimuli to a single string in html format
    var cat1stimuliobjectHtml = [
      '<div dir="rtl" style="margin-left: auto; margin-right: auto; display: table; width: 700px;">',
      '<ul dir ="rtl" style="text-align: justify; margin: 10px 0; list-style-position:inside; list-style-type:disk;">',
      '<font color="#336600" size="4px">',
      '<li>',
      cat1stimuliobject.join('</li><li>'),
      '</li></font></ul></div>'
    ].join('')

    var cat2stimuliobject = []
    for (stimuliobject of piCurrent.category2.stimulusMedia) {
      cat2stimuliobject.push(stimuliobject.word)
    }
    // sets the prefix for the first element
    // concatenate the stimuli to a single string in html format
    var cat2stimuliobjectHtml = [
      '<div dir="rtl" style="margin-left: auto; margin-right: auto; display: table; width: 700px;">',
      '<ul dir="rtl" style="text-align: justify; margin: 10px 0; list-style-position:inside; list-style-type:disk;">',
      '<font color="#336600" size="4px">',
      '<li>',
      cat2stimuliobject.join('</li><li>'),
      '</li></font></ul></div>'
    ].join('')

    // The next lines will have to be configured manually if the category names are fixed. I suggest using the random option. Use at your own risk...

    var topLabel = []
    var bottomLabel = []
    var topInventory = []
    var bottomInventory = []

    if (type1ascategory1 === true) {
      topLabel = category1name
      bottomLabel = category2name
      topInventory = cat1stimuliobjectHtml
      bottomInventory = cat2stimuliobjectHtml
    } else {
      topLabel = category2name
      bottomLabel = category1name
      topInventory = cat2stimuliobjectHtml
      bottomInventory = cat1stimuliobjectHtml
    }

    piCurrent.instAttributeInventory = '<div dir="rtl"><p align="center" style="font-size:20px; font-family:arial">' +
        '<font color="#000000"><u>סיבוב blockNum מתוך nBlocks </u><br/><br/></p>' +
        '<p style="font-size:20px; text-align:center; vertical-align:bottom; margin-left:10px; font-family:arial">' +
        'אלה הפריטים שתתבקש למיין בסיבוב הבא:<br/><br/>' +
        '<center>' +
          '<font color="#0000ff"><b>' +
            piCurrent.attribute1.title.media.word +
          '</b></font>' +
            att1stimuliobjectHtml +
            '<br/>' +
          '<font color="#0000ff"><b>' +
            piCurrent.attribute2.title.media.word +
          '</b></font>' +
            att2stimuliobjectHtml +
        '</center><br/>' +
        'להמשך, נא ללחוץ על רווח.' +
        '</p></div>'
    piCurrent.instAttributeInventoryTouch = [
      'table { border-collapse: separate; border-spacing: 5px; } <div dir="rtl">',
      '<p align="center">',
      '<u>סיבוב blockNum מתוך nBlocks</u>',
      '</p>',
      '<p align="center" style="margin-right:5px">',
      '<br/>',
      'בסיבוב הזה הקטגוריות הן:<br/><br/>',
      '<center>',
      '<font color="#0000ff"><b>',
      piCurrent.attribute1.title.media.word,
      '</b></font>',
      att1stimuliobjectHtml,
      '<br/>',
      '<font color="#0000ff"><b>',
      piCurrent.attribute1.title.media.word,
      '</b></font>',
      att2stimuliobjectHtml,
      '</center><br/>',
      '</p>',
      '<p align="center">Touch the <b>lower </b> green area to start.</p>',
      '</div>'
    ].join('\n')

    piCurrent.instCategoryInventory = '<div dir="rtl"><p align="center" style="font-size:20px; font-family:arial">' +
        '<font color="#000000"><u>סיבוב blockNum מתוך nBlocks </u><br/><br/></p>' +
        '<p style="font-size:20px; text-align:center; vertical-align:bottom; margin-left:10px; font-family:arial">' +
        'אלה הפריטים שתתבקש למיין בסיבוב הבא:<br/><br/>' +
        '<center>' +
          '<font color="#336600">פריטים השייכים ל<b>' + topLabel + '</b></font>' +
            topInventory +
            '<br/>' +
          '<font color="#336600">פריטים השייכים ל<b>' + bottomLabel + '</b></font>' +
            bottomInventory +
        '</center><br/>' +
        'להמשך, נא ללחוץ על רווח.' +
        '</p></div>'
    piCurrent.instCategoryInventoryTouch = [
      '<div dir="rtl">',
      '<p align="center">',
      '<u>סיבוב blockNum מתוך nBlocks</u>',
      '</p>',
      '<p align="center" style="margin-right:5px">',
      '<br/>',
      'Here are the statements you will classify in the first part:<br/><br/>',
      '<center>',
      '<font color="#336600"><b>',
      topLabel,
      ' Statements</b></font>',
      topInventory,
      '<br/>',
      '<font color="#336600"><b>',
      bottomLabel,
      ' Statements</b></font>',
      bottomInventory,
      '</center><br/>',
      '</p>',
      '<p align="center">Touch the <b>lower </b> green area to start.</p>',
      '</div>'
    ].join('\n')

    // are we on the touch version
    var isTouch = piCurrent.isTouch

    // We use these objects a lot, so let's read them here
    var att1 = piCurrent.attribute1
    var att2 = piCurrent.attribute2
    var cat1 = piCurrent.category1
    var cat2 = piCurrent.category2
    var cat1practice = piCurrent.category1practice
    var cat2practice = piCurrent.category2practice
    if (isTouch) {
      var maxW = piCurrent.touchMaxStimulusWidth
      var maxH = piCurrent.touchMaxStimulusHeight
      att1.stimulusCss.maxWidth = maxW
      att2.stimulusCss.maxWidth = maxW
      cat1.stimulusCss.maxWidth = maxW
      cat2.stimulusCss.maxWidth = maxW
      cat1practice.stimulusCss.maxWidth = maxW
      cat2practice.stimulusCss.maxWidth = maxW
      att1.stimulusCss.maxHeight = maxH
      att2.stimulusCss.maxHeight = maxH
      cat1.stimulusCss.maxHeight = maxH
      cat2.stimulusCss.maxHeight = maxH
      cat1practice.stimulusCss.maxHeight = maxH
      cat2practice.stimulusCss.maxHeight = maxH
    }

    var typePairing = '' // set the type pairing explanation for the debrifing

    if (manualCatDisplayNames) { // The display name for the categories were defined manually (properly)
      typePairing = '' // We have no way of knowing this...
    } else { // The display name for the categories defined by the extension
      if (type1ascategory1) { // this if condition makes sure that we always first describe type 1, and later type 2.
        typePairing = "במטלה שביצעת הקטגוריה, '" + category1name + "' ייצגה אדם בעל " + cat1.name + ", והקטגוריה '" + category2name + "' ייצגה אדם בעל " + cat2.name + '.'
      } else {
        typePairing = "במטלה שביצעת הקטגוריה, '" + category2name + "' ייצגה אדם בעל " + cat2.name + ", והקטגוריה '" + category1name + "' ייצגה אדם בעל " + cat1.name + '.'
      }
    }
    API.addGlobal({
      typePairing: typePairing
    })
    API.save({
      typePairing: API.getGlobal().typePairing
    })
    // Set the attribute on the left.
    var rightAttName = (piCurrent.randomAttSide) ? (Math.random() >= 0.5 ? att1.name : att2.name) : att2.name

    /**
   * Create inputs
   */

    var leftInput = !isTouch ? {handle: 'left', on: 'keypressed', key: 'e'} : {handle: 'left', on: 'click', stimHandle: 'left'}
    var rightInput = !isTouch ? {handle: 'right', on: 'keypressed', key: 'i'} : {handle: 'right', on: 'click', stimHandle: 'right'}
    var proceedInput = !isTouch ? {handle: 'space', on: 'space'} : {handle: 'space', on: 'bottomTouch', css: piCurrent.bottomTouchCss}

    /**
  *Set basic settings.
  */
    API.addSettings('canvas', piCurrent.canvas)
    API.addSettings('base_url', piCurrent.base_url)
    API.addSettings('logger', {
      pulse: 20,
      url: '/implicit/PiPlayerApplet'
    })
    API.addSettings('hooks', {
      endTask: function () {
        var DScoreObj = scorer.computeD()
        piCurrent.feedback = DScoreObj.FBMsg
        API.save({block4Cond: block4Cond, feedback: DScoreObj.FBMsg, d: DScoreObj.DScore})
      }
    })
    /**
   * Create default sorting trial
   */
    API.addTrialSets('sort', {
    // by default each trial is correct, this is modified in case of an error
      data: {score: 0, parcel: 'first'}, // We're using only one parcel for computing the score, so we're always going to call it 'first'.
      // set the interface for trials
      input: [
        {handle: 'skip1', on: 'keypressed', key: 27}, // Esc + Enter will skip blocks
        leftInput,
        rightInput
      ],

      // user interactions
      interactions: [
        // begin trial : display stimulus immediately
        {
          conditions: [{type: 'begin'}],
          actions: [{type: 'showStim', handle: 'targetStim'}]
        },
        // error response
        {
          conditions: [
            {type: 'inputEqualsTrial', property: 'corResp', negate: true}, // Not the correct response.
            {type: 'inputEquals', value: ['right', 'left']} // responded with one of the two responses
          ],
          actions: [
            {type: 'setTrialAttr', setter: {score: 1}}, // set the score to 1
            {type: 'showStim', handle: 'error'}, // show error stimulus
            {type: 'trigger', handle: 'onError'} // perhaps we need to end the trial (if no errorCorrection)
          ]
        },
        // error when there is no correction
        {
          conditions: [
            {type: 'globalEquals', property: 'errorCorrection', value: false}, // no error correction.
            {type: 'inputEquals', value: 'onError'} // Was error
          ],
          actions: [
            {type: 'removeInput', handle: 'All'}, // Cannot respond anymore
            {type: 'log'}, // log this trial
            {type: 'trigger', handle: 'ITI', duration: piCurrent.errorFBDuration} // Continue to the ITI, after that error fb has been displayed
          ]
        },
        // correct
        {
          conditions: [{type: 'inputEqualsTrial', property: 'corResp'}], // check if the input handle is equal to correct response (in the trial's data object)
          actions: [
            {type: 'removeInput', handle: 'All'}, // Cannot respond anymore
            {type: 'hideStim', handle: 'All'}, // hide everything
            {type: 'log'}, // log this trial
            {type: 'trigger', handle: 'ITI'} // End the trial after ITI
          ]
        },
        // Display nothing for ITI until the next trial
        {
          conditions: [{type: 'inputEquals', value: 'ITI'}],
          actions: [
            {type: 'removeInput', handle: 'All'}, // Cannot respond anymore
            {type: 'hideStim', handle: 'All'}, // hide everything
            {type: 'trigger', handle: 'end', duration: piCurrent.ITIDuration} // Continue to the ITI, after that error fb has been displayed
          ]
        },
        // end after ITI
        {
          conditions: [{type: 'inputEquals', value: 'end'}],
          actions: [
            {type: 'endTrial'}
          ]
        },

        // skip block: enter and then ESC
        {
          conditions: [{type: 'inputEquals', value: 'skip1'}],
          actions: [
            {type: 'setInput', input: {handle: 'skip2', on: 'enter'}} // allow skipping if next key is enter.
          ]
        },
        // skip block: then ESC
        {
          conditions: [{type: 'inputEquals', value: 'skip2'}],
          actions: [
            {type: 'goto', destination: 'nextWhere', properties: {blockStart: true}},
            {type: 'endTrial'}
          ]
        }
      ]
    })

    /**
   * Create default instructions trials
   */
    API.addTrialSets('instructions', [
    // generic instructions trial, to be inherited by all other inroduction trials
      {
        // set block as generic so we can inherit it later
        data: {blockStart: true, condition: 'instructions', score: 0, block: 0},

        // create user interface (just click to move on...)
        input: [
          proceedInput
        ],

        interactions: [
          // display instructions
          {
            conditions: [{type: 'begin'}],
            actions: [
              {type: 'showStim', handle: 'All'}
            ]
          },
          // space hit, end trial soon
          {
            conditions: [{type: 'inputEquals', value: 'space'}],
            actions: [
              {type: 'hideStim', handle: 'All'},
              {type: 'removeInput', handle: 'space'},
              {type: 'log'},
              {type: 'trigger', handle: 'endTrial', duration: 500}
            ]
          },
          {
            conditions: [{type: 'inputEquals', value: 'endTrial'}],
            actions: [{type: 'endTrial'}]
          }
        ]
      }
    ])

    /**
   * All basic trials.
   */

    // Helper function to create a basic trial for a certain category (or attribute)
    // as an in or out trial (right is in and left is out).
    function createBasicTrialSet (params) { // params: side is left or right. stimSet is the name of the stimulus set.
      var set = [{
        inherit: 'sort',
        data: {corResp: params.side},
        stimuli:
      [
        {inherit: {type: 'exRandom', set: params.stimSet}},
        {inherit: {set: 'error'}}
      ]
      }]
      return set
    }

    var basicTrialSets = {}
    // Four trials for the attributes.
    basicTrialSets.att1left =
    createBasicTrialSet({side: 'left', stimSet: 'att1'})
    basicTrialSets.att1right =
    createBasicTrialSet({side: 'right', stimSet: 'att1'})
    basicTrialSets.att2left =
    createBasicTrialSet({side: 'left', stimSet: 'att2'})
    basicTrialSets.att2right =
    createBasicTrialSet({side: 'right', stimSet: 'att2'})
    // Four trials for the categories.
    basicTrialSets.cat1left =
    createBasicTrialSet({side: 'left', stimSet: 'cat1'})
    basicTrialSets.cat1right =
    createBasicTrialSet({side: 'right', stimSet: 'cat1'})
    basicTrialSets.cat2left =
    createBasicTrialSet({side: 'left', stimSet: 'cat2'})
    basicTrialSets.cat2right =
    createBasicTrialSet({side: 'right', stimSet: 'cat2'})
    // Four trials for the hinted categories.
    basicTrialSets.cat1leftpractice =
    createBasicTrialSet({side: 'left', stimSet: 'cat1practice'})
    basicTrialSets.cat1rightpractice =
    createBasicTrialSet({side: 'right', stimSet: 'cat1practice'})
    basicTrialSets.cat2leftpractice =
    createBasicTrialSet({side: 'left', stimSet: 'cat2practice'})
    basicTrialSets.cat2rightpractice =
    createBasicTrialSet({side: 'right', stimSet: 'cat2practice'})
    API.addTrialSets(basicTrialSets)

    /**
   *    Stimulus Sets
   */

    // Basic stimuli
    API.addStimulusSets({
    // This Default stimulus is inherited by the other stimuli so that we can have a consistent look and change it from one place
      Default: [
        {css: {color: piCurrent.fontColor, 'font-size': '2em'}}
      ],

      instructions: [
        {css: {'font-size': '1.4em', color: 'black', lineHeight: 1.2},
          nolog: true,
          location: {left: 0, top: 0},
          size: {width: piCurrent.instWidth}}
      ],

      target: [{
        data: {handle: 'targetStim'}
      }],
      att1:
    [{
      data: {alias: att1.name},
      inherit: 'target',
      css: att1.stimulusCss,
      media: {inherit: {type: 'exRandom', set: 'att1'}}
    }],
      att2:
    [{
      data: {alias: att2.name},
      inherit: 'target',
      css: att2.stimulusCss,
      media: {inherit: {type: 'exRandom', set: 'att2'}}
    }],
      cat1:
    [{
      data: {alias: cat1.name},
      inherit: 'target',
      css: cat1.stimulusCss,
      media: {inherit: {type: 'exRandom', set: 'cat1'}}
    }],
      cat2:
    [{
      data: {alias: cat2.name},
      inherit: 'target',
      css: cat2.stimulusCss,
      media: {inherit: {type: 'exRandom', set: 'cat2'}}
    }],
      cat1practice:
    [{
      data: {alias: cat1practice.name},
      inherit: 'target',
      css: cat1practice.stimulusCss,
      media: {inherit: {type: 'exRandom', set: 'cat1practice'}}
    }],
      cat2practice:
    [{
      data: {alias: cat2practice.name},
      inherit: 'target',
      css: cat2practice.stimulusCss,
      media: {inherit: {type: 'exRandom', set: 'cat2practice'}}
    }],
      // this stimulus used for giving feedback, in this case only the error notification
      error: [{
        handle: 'error', location: {top: 75}, css: {color: 'red', 'font-size': '4em'}, media: {word: 'X'}, nolog: true
      }],

      touchInputStimuli: [
        {media: {html: '<div dir="rtl"></div>'}, size: {height: 48, width: 30}, css: {background: '#00FF00', opacity: 0.3, zindex: -1}, location: {right: 0}, data: {handle: 'right'}},
        {media: {html: '<div dir="rtl"></div>'}, size: {height: 48, width: 30}, css: {background: '#00FF00', opacity: 0.3, zindex: -1}, location: {left: 0}, data: {handle: 'left'}}
      ]
    })

    /**
   *    Media Sets
   */
    API.addMediaSets({
      att1: att1.stimulusMedia,
      att2: att2.stimulusMedia,
      cat1: cat1.stimulusMedia,
      cat2: cat2.stimulusMedia,
      cat1practice: cat1practice.stimulusMedia,
      cat2practice: cat2practice.stimulusMedia
    })

    /**
   *    Create the Task sequence
   */

    // helper Function for getting the instructions HTML.
    function getInstFromTemplate (params) { // params: instTemplate, blockNum, nBlocks, leftCat, rightCat, leftAtt, rightAtt.
      var retText = params.instTemplate
        .replace(/leftCategory/g, params.leftCategory)
        .replace(/rightCategory/g, params.rightCategory)
        .replace(/leftAttribute/g, params.leftAttribute)
        .replace(/rightAttribute/g, params.rightAttribute)
        .replace(/blockNum/g, params.blockNum)
        .replace(/nBlocks/g, params.nBlocks)
      return retText
    }

    // Helper function to create the trial's layout
    function getLayout (params) {
      function buildContent (layout) {
        if (!layout) { return '' }
        var isImage = !!layout.image
        var content = layout.word || layout.html || layout.image || layout
        if (_.isString(layout) || layout.word) { content = _.escape(content) }
        return isImage ? '<img src="' + piCurrent.base_url.image + content + '" style="max-width:100%;width:100%" />' : content
      }

      function buildStyle (css) {
        css || (css = {})
        var style = ''
        for (var i in css) { style += i + ':' + css[i] + ';' }
        return style
      }

      var template = '' +
    '   <div dir="rtl" style="margin:0 2%; text-align:center">  ' +
    '       <div dir="rtl" style="font-size:0.8em; <%= stimulusData.keysCss %>; visibility:<%= stimulusData.isTouch ? \'hidden\' : \'visible\' %>">  ' +
    '           <%= stimulusData.isLeft ? stimulusData.leftKeyText : stimulusData.rightKeyText %>  ' +
    '       </div>  ' +
    '     ' +
    '       <div dir="rtl" style="font-size:1.3em;<%= stimulusData.firstCss %>">  ' +
    '           <%= stimulusData.first %>  ' +
    '       </div>  ' +
    '     ' +
    '       <% if (stimulusData.second) { %>  ' +
    '           <div dir="rtl" style="font-size:2.3em; <%= stimulusData.orCss %>"><%= stimulusData.orText %> </div>  ' +
    '           <div dir="rtl" style="font-size:1.3em; max-width:100%; <%= stimulusData.secondCss %>">  ' +
    '               <%= stimulusData.second %>  ' +
    '           </div>  ' +
    '       <% } %>  ' +
    '   </div>  '

    // Attributes are above the categories.
      var layout = [
        {
          location: {left: 0, top: 0},
          media: {html: template},
          data: {
            first: buildContent(_.get(params, 'left1.title.media')),
            firstCss: buildStyle(_.get(params, 'left1.title.css')),
            second: buildContent(_.get(params, 'left2.title.media')),
            secondCss: buildStyle(_.get(params, 'left2.title.css')),
            leftKeyText: buildContent(_.get(piCurrent, 'leftKeyText')),
            rightKeyText: buildContent(_.get(piCurrent, 'rightKeyText')),
            keysCss: buildStyle(_.get(piCurrent, 'keysCss')),
            orText: buildContent(_.get(piCurrent, 'orText')),
            orCss: buildStyle(_.get(piCurrent, 'orCss')),
            isTouch: isTouch,
            isLeft: true
          }
        },
        {
          location: {right: 0, top: 0},
          media: {html: template},
          data: {
            first: buildContent(_.get(params, 'right1.title.media')),
            firstCss: buildStyle(_.get(params, 'right1.title.css')),
            second: buildContent(_.get(params, 'right2.title.media')),
            secondCss: buildStyle(_.get(params, 'right2.title.css')),
            leftKeyText: buildContent(_.get(piCurrent, 'leftKeyText')),
            rightKeyText: buildContent(_.get(piCurrent, 'rightKeyText')),
            keysCss: buildStyle(_.get(piCurrent, 'keysCss')),
            orText: buildContent(_.get(piCurrent, 'orText')),
            orCss: buildStyle(_.get(piCurrent, 'orCss')),
            isTouch: isTouch,
            isLeft: false
          }
        }
      ]

      if (!params.isInst && params.remindError) {
        layout.push({
          location: {bottom: 1},
          css: {color: piCurrent.fontColor, 'font-size': '1em'},
          media: {html: isTouch ? params.remindErrorTextTouch : params.remindErrorText}
        })
      }

      if (!params.isInst && isTouch) {
        layout.push({inherit: {type: 'byData', set: 'touchInputStimuli', data: {handle: 'right'}}})
        layout.push({inherit: {type: 'byData', set: 'touchInputStimuli', data: {handle: 'left'}}})
      }

      return layout
    }
    function getLayoutNoLabels (params) {
      function buildContent (layout) {
        if (!layout) { return '' }
        var isImage = !!layout.image
        var content = layout.word || layout.html || layout.image || layout
        if (_.isString(layout) || layout.word) { content = _.escape(content) }
        return isImage ? '<img src="' + piCurrent.base_url.image + content + '" style="max-width:100%;width:100%" />' : content
      }

      function buildStyle (css) {
        css || (css = {})
        var style = ''
        for (var i in css) { style += i + ':' + css[i] + ';' }
        return style
      }

      var template = '' +
    '   <div dir="rtl" style="margin:0 2%; text-align:center">  ' +
    '   </div>  '

    // Attributes are above the categories.
      var layout = [
        {
          location: {left: 0, top: 0},
          media: {html: template},
          data: {
            first: buildContent(_.get(params, 'left1.title.media')),
            firstCss: buildStyle(_.get(params, 'left1.title.css')),
            second: buildContent(_.get(params, 'left2.title.media')),
            secondCss: buildStyle(_.get(params, 'left2.title.css')),
            leftKeyText: buildContent(_.get(piCurrent, 'leftKeyText')),
            rightKeyText: buildContent(_.get(piCurrent, 'rightKeyText')),
            keysCss: buildStyle(_.get(piCurrent, 'keysCss')),
            orText: buildContent(_.get(piCurrent, 'orText')),
            orCss: buildStyle(_.get(piCurrent, 'orCss')),
            isTouch: isTouch,
            isLeft: true
          }
        },
        {
          location: {right: 0, top: 0},
          media: {html: template},
          data: {
            first: buildContent(_.get(params, 'right1.title.media')),
            firstCss: buildStyle(_.get(params, 'right1.title.css')),
            second: buildContent(_.get(params, 'right2.title.media')),
            secondCss: buildStyle(_.get(params, 'right2.title.css')),
            leftKeyText: buildContent(_.get(piCurrent, 'leftKeyText')),
            rightKeyText: buildContent(_.get(piCurrent, 'rightKeyText')),
            keysCss: buildStyle(_.get(piCurrent, 'keysCss')),
            orText: buildContent(_.get(piCurrent, 'orText')),
            orCss: buildStyle(_.get(piCurrent, 'orCss')),
            isTouch: isTouch,
            isLeft: false
          }
        }
      ]

      if (!params.isInst && params.remindError) {
        layout.push({
          location: {bottom: 1},
          css: {color: piCurrent.fontColor, 'font-size': '1em'},
          media: {html: isTouch ? params.remindErrorTextTouch : params.remindErrorText}
        })
      }

      if (!params.isInst && isTouch) {
        layout.push({inherit: {type: 'byData', set: 'touchInputStimuli', data: {handle: 'right'}}})
        layout.push({inherit: {type: 'byData', set: 'touchInputStimuli', data: {handle: 'left'}}})
      }

      return layout
    }
    // helper function for creating an instructions trial
    function getInstTrial (params) {
      var instParams = {isInst: true}
      // The names of the category and attribute labels.
      if (params.nCats === 2) { // When there are only two categories in the block, one two of these will appear in the instructions.
        instParams.leftAttribute = params.left1.name
        instParams.rightAttribute = params.right1.name
        instParams.leftCategory = params.left1.title.media.word
        instParams.rightCategory = params.right1.title.media.word
      } else {
        instParams.leftAttribute = params.left1.name
        instParams.rightAttribute = params.right1.name
        instParams.leftCategory = params.left2.title.media.word
        instParams.rightCategory = params.right2.title.media.word
      }
      _.extend(instParams, params)
      var instLocation = {bottom: 1}
      if (isTouch === true) {
        instLocation = {left: 0, top: (params.nCats === 2) ? 7 : 10}
      }
      var instTrial = {
        inherit: 'instructions',
        data: {blockStart: true},
        layout: getLayout(instParams),
        stimuli: [
          {
            inherit: 'instructions',
            media: {html: getInstFromTemplate(instParams)},
            location: instLocation,
            nolog: true
          },
          {
            data: {handle: 'dummy', alias: 'dummy'},
            media: {word: ' '},
            location: {top: 1}
          }
        ]
      }

      return instTrial
    }

    // helper function for creating an instructions trial
    function getInstTrialNoLabels (params) {
      var instParams = {isInst: true}
      // The names of the category and attribute labels.

      _.extend(instParams, params)
      var instLocation = {bottom: 1, top: 2}
      if (isTouch === true) {
        // TODO: need to test layout of this when isTouch = true
        instLocation = {left: 0, top: 2}
      }
      var instTrial = {
        inherit: 'instructions',
        data: {blockStart: true},
        layout: getLayoutNoLabels(instParams),
        stimuli: [
          {
            inherit: 'instructions',
            media: {html: getInstFromTemplate(instParams)},
            location: instLocation,
            nolog: true
          },
          {
            data: {handle: 'dummy', alias: 'dummy'},
            media: {word: ' '},
            location: {top: 1}
          }
        ]
      }

      return instTrial
    }
    // Get a mixer for a mini-block in a 2-categories block.
    function getMiniMixer2 (params) { // {nTrialsInMini : , currentCond : , rightTrial : , leftTrial : , blockNum : , blockLayout : )
      var mixer = {
        mixer: 'repeat',
        times: params.nTrialsInMini / 2,
        data:
      [
        {
          inherit: params.rightTrial,
          data: {condition: params.currentCond, block: params.blockNum},
          layout: params.blockLayout
        },
        {
          inherit: params.leftTrial,
          data: {condition: params.currentCond, block: params.blockNum},
          layout: params.blockLayout
        }
      ]
      }
      return ({
        mixer: 'random',
        data: [mixer] // Completely randomize the repeating trials.
      })
    }

    // Get a mixer for a mini-block in a 4-categories block.
    function getMiniMixer4 (params) { // {nTrialsInMini : , currentCond : , rightTrial1 : , leftTrial1 : , rightTrial2 : , leftTrial2 : , blockNum : , blockLayout : )
    /// /Because of the alternation, we randomize the trial order ourselves.
      var atts = []
      var cats = []
      var iTrial

      // Fill
      for (iTrial = 1; iTrial <= params.nTrialsInMini; iTrial += 4) {
        atts.push(1)
        atts.push(2)
        cats.push(1)
        cats.push(2)
      }
      // Randomize order
      atts = _.shuffle(atts)
      cats = _.shuffle(cats)

      var mixerData = []
      var iCat = 0
      var iAtt = 0
      for (iTrial = 1; iTrial <= params.nTrialsInMini; iTrial += 2) {
        mixerData.push(
          {
            inherit: (cats[iCat] === 1) ? params.leftTrial2 : params.rightTrial2,
            data: {condition: params.currentCond, block: params.blockNum},
            layout: params.blockLayout
          })
        iCat++
        mixerData.push(
          {
            inherit: (atts[iAtt] === 1) ? params.leftTrial1 : params.rightTrial1,
            data: {condition: params.currentCond, block: params.blockNum},
            layout: params.blockLayout
          })
        iAtt++
      }

      return ({
        mixer: 'wrapper',
        data: mixerData
      })
    }

    /// /////////////////////////////////////////////////////////////
    /// /AFTER ALL the helper functions, it is time to create the trial sequence.
    var trialSequence = []

    var globalObj = piCurrent

    // These parameters are used to create trials.
    var blockParamsAtts = {
      nBlocks: globalObj.nBlocks,
      remindError: globalObj.remindError,
      remindErrorText: globalObj.remindErrorText,
      remindErrorTextTouch: globalObj.remindErrorTextTouch
    }
    /// ///////////////////////////
    /// /Block 1: Attributes block
    var iBlock = 1

    // Set variables related to the sides
    blockParamsAtts.left1 = att1
    blockParamsAtts.right1 = att2
    // Names of the trials in this block
    var leftAttTrial = 'att1left'
    var rightAttTrial = 'att2right'
    if (rightAttName === att1.name) {
      blockParamsAtts.right1 = att1
      rightAttTrial = 'att1right'
      leftAttTrial = 'att2left'
      blockParamsAtts.left1 = att2
    }

    blockParamsAtts.nMiniBlocks = globalObj.blockAttributes_nMiniBlocks
    blockParamsAtts.nTrials = globalObj.blockAttributes_nTrials
    blockParamsAtts.blockNum = iBlock
    blockParamsAtts.nCats = 2
    // we'll first push the inventory instructions
    blockParamsAtts.instTemplate = isTouch ? globalObj.instAttributeInventoryTouch : globalObj.instAttributeInventory
    trialSequence.push(getInstTrialNoLabels(blockParamsAtts))
    // now we'll push the actual instruction for the first block
    blockParamsAtts.instTemplate = isTouch ? globalObj.instAttributePracticeTouch : globalObj.instAttributePractice
    trialSequence.push(getInstTrial(blockParamsAtts))

    // Set the block's condition
    var blockCondition = blockParamsAtts.left1.name + ',' + blockParamsAtts.right1.name
    var blockLayout = getLayout(blockParamsAtts)
    var nTrialsInMini = blockParamsAtts.nTrials / blockParamsAtts.nMiniBlocks
    var iBlock1Mini
    for (iBlock1Mini = 1; iBlock1Mini <= blockParamsAtts.nMiniBlocks; iBlock1Mini++) {
      trialSequence.push(getMiniMixer2({
        nTrialsInMini: nTrialsInMini,
        currentCond: blockCondition,
        rightTrial: rightAttTrial,
        leftTrial: leftAttTrial,
        blockNum: iBlock,
        blockLayout: blockLayout}))
    }
    /// ///////////////////////////
    /// /Block 2 (2a): Hinted Categories
    var blockParamsCats = {
      nBlocks: globalObj.nBlocks,
      remindError: globalObj.remindError,
      remindErrorText: globalObj.remindErrorText,
      remindErrorTextTouch: globalObj.remindErrorTextTouch
    }
    iBlock++ // this is block 2, but the first part of it...
    // Set sides
    var rightCatName = (globalObj.randomBlockOrder ? (Math.random() >= 0.5 ? cat1.name : cat2.name) : cat2.name)
    var leftCatTrial = 'cat1leftpractice'
    blockParamsCats.left1 = cat1practice
    var rightCatTrial = 'cat2rightpractice'
    blockParamsCats.right1 = cat2practice
    if (rightCatName === cat1practice.name) {
      blockParamsCats.right1 = cat1practice
      rightCatTrial = 'cat1rightpractice'
      blockParamsCats.left1 = cat2practice
      leftCatTrial = 'cat2leftpractice'
    }

    // Set the block's condition
    blockCondition = blockParamsCats.left1.name + ',' + blockParamsCats.right1.name
    // Number variables
    blockParamsCats.nMiniBlocks = globalObj.blockCategoriesPractice_nMiniblocks
    blockParamsCats.nTrials = globalObj.blockCategoriesPractice_ntrials
    blockParamsCats.blockNum = iBlock
    blockParamsCats.nCats = 2
    // we'll now push the inventory instructions
    blockParamsCats.instTemplate = isTouch ? globalObj.instCategoryInventoryTouch : globalObj.instCategoryInventory
    trialSequence.push(getInstTrialNoLabels(blockParamsCats))
    // Instructions trial
    blockParamsCats.instTemplate = isTouch ? globalObj.instCategoriesPracticeTouchHinted : globalObj.instCategoriesPracticeHinted
    trialSequence.push(getInstTrial(blockParamsCats))
    // Layout for the sorting trials
    blockLayout = getLayout(blockParamsCats)
    // Number of trials in a mini block.
    nTrialsInMini = blockParamsCats.nTrials / blockParamsCats.nMiniBlocks
    // Add a mixer for each mini block.
    var iBlock2Mini
    for (iBlock2Mini = 1; iBlock2Mini <= blockParamsCats.nMiniBlocks; iBlock2Mini++) {
      trialSequence.push(getMiniMixer2(
        {nTrialsInMini: nTrialsInMini,
          currentCond: blockCondition,
          rightTrial: rightCatTrial,
          leftTrial: leftCatTrial,
          blockNum: iBlock,
          blockLayout: blockLayout}))
    }

    /// ///////////////////////////
    /// /Block 3 (2b): Categories
    iBlock++
    // Set variables related to the sides
    blockParamsCats = {
      nBlocks: globalObj.nBlocks,
      remindError: globalObj.remindError,
      remindErrorText: globalObj.remindErrorText,
      remindErrorTextTouch: globalObj.remindErrorTextTouch
    }
    // Set sides
    rightCatName = (globalObj.randomBlockOrder ? (Math.random() >= 0.5 ? cat1.name : cat2.name) : cat2.name)
    leftCatTrial = 'cat1left'
    blockParamsCats.left1 = cat1
    rightCatTrial = 'cat2right'
    blockParamsCats.right1 = cat2
    if (rightCatName === cat1.name) {
      blockParamsCats.right1 = cat1
      rightCatTrial = 'cat1right'
      blockParamsCats.left1 = cat2
      leftCatTrial = 'cat2left'
    }

    // Set the block's condition
    blockCondition = blockParamsCats.left1.name + ',' + blockParamsCats.right1.name
    // Number variables
    blockParamsCats.nMiniBlocks = globalObj.blockCategories_nMiniBlocks
    blockParamsCats.nTrials = globalObj.blockCategories_nTrials
    blockParamsCats.blockNum = iBlock
    blockParamsCats.nCats = 2
    // Instructions trial
    blockParamsCats.instTemplate = isTouch ? globalObj.instCategoriesPracticeTouch : globalObj.instCategoriesPractice
    trialSequence.push(getInstTrial(blockParamsCats))
    // Layout for the sorting trials
    blockLayout = getLayout(blockParamsCats)
    // Number of trials in a mini block.
    nTrialsInMini = blockParamsCats.nTrials / blockParamsCats.nMiniBlocks
    // Add a mixer for each mini block.
    var iBlock3Mini
    for (iBlock3Mini = 1; iBlock3Mini <= blockParamsCats.nMiniBlocks; iBlock3Mini++) {
      trialSequence.push(getMiniMixer2(
        {nTrialsInMini: nTrialsInMini,
          currentCond: blockCondition,
          rightTrial: rightCatTrial,
          leftTrial: leftCatTrial,
          blockNum: iBlock,
          blockLayout: blockLayout}))
    }

    /// ///////////////////////////
    /// /Block 4: First combined block
    iBlock++
    var blockParamsCombined = {
      nBlocks: globalObj.nBlocks,
      remindError: globalObj.remindError,
      remindErrorText: globalObj.remindErrorText,
      remindErrorTextTouch: globalObj.remindErrorTextTouch
    }
    // We get the categories from the first two blocks.
    blockParamsCombined.right1 = blockParamsAtts.right1
    blockParamsCombined.left1 = blockParamsAtts.left1
    blockParamsCombined.right2 = blockParamsCats.right1
    blockParamsCombined.left2 = blockParamsCats.left1
    blockCondition = blockParamsCombined.left2.name + '/' + blockParamsCombined.left1.name + ',' + blockParamsCombined.right2.name + '/' + blockParamsCombined.right1.name
    // We will send the condition of the third block to the server at the end.
    var block4Cond = blockCondition
    // Number variables.
    blockParamsCombined.nMiniBlocks = globalObj.blockFirstCombined_nMiniBlocks
    blockParamsCombined.nTrials = globalObj.blockFirstCombined_nTrials
    blockParamsCombined.blockNum = iBlock
    blockParamsCombined.nCats = 4
    // Instructions trial.
    blockParamsCombined.instTemplate = isTouch ? globalObj.instFirstCombinedTouch : globalObj.instFirstCombined
    trialSequence.push(getInstTrial(blockParamsCombined))
    // Get the layout for the sorting trials.
    blockLayout = getLayout(blockParamsCombined)
    // Fill the trials.
    nTrialsInMini = blockParamsCombined.nTrials / blockParamsCombined.nMiniBlocks
    var iBlock4Mini
    for (iBlock4Mini = 1; iBlock4Mini <= blockParamsCombined.nMiniBlocks; iBlock4Mini++) {
      trialSequence.push(getMiniMixer4({
        nTrialsInMini: nTrialsInMini,
        currentCond: blockCondition,
        rightTrial1: rightAttTrial,
        leftTrial1: leftAttTrial,
        rightTrial2: rightCatTrial,
        leftTrial2: leftCatTrial,
        blockNum: iBlock,
        blockLayout: blockLayout}))
    }
    /// ///////////////////////////
    /// /Second combined block.
    if (globalObj.nBlocks === 8) { // Fourth block is another combined block.
      iBlock++
      blockParamsCombined.blockNum = iBlock
      blockParamsCombined.nMiniBlocks = globalObj.blockSecondCombined_nMiniBlocks
      blockParamsCombined.nTrials = globalObj.blockSecondCombined_nTrials
      // Instructions trial.
      blockParamsCombined.instTemplate = isTouch ? globalObj.instSecondCombinedTouch : globalObj.instSecondCombined
      trialSequence.push(getInstTrial(blockParamsCombined))
      // The layout for the sorting trials.
      blockLayout = getLayout(blockParamsCombined)
      // Fill the trials
      nTrialsInMini = blockParamsCombined.nTrials / blockParamsCombined.nMiniBlocks
      var iBlock5Mini
      for (iBlock5Mini = 1; iBlock5Mini <= blockParamsCombined.nMiniBlocks; iBlock5Mini++) {
        trialSequence.push(getMiniMixer4({
          nTrialsInMini: nTrialsInMini,
          currentCond: blockCondition,
          rightTrial1: rightAttTrial,
          leftTrial1: leftAttTrial,
          rightTrial2: rightCatTrial,
          leftTrial2: leftCatTrial,
          blockNum: iBlock,
          blockLayout: blockLayout}))
      }
    }
    /// ///////////////////////////
    /// /Switch categories side block.
    iBlock++
    // Do the switch
    blockParamsCats.right1 = blockParamsCombined.left2
    blockParamsCats.left1 = blockParamsCombined.right2
    rightCatTrial = (rightCatTrial === 'cat1right') ? 'cat2right' : 'cat1right'
    leftCatTrial = (leftCatTrial === 'cat1left') ? 'cat2left' : 'cat1left'
    blockParamsCats.instTemplate = isTouch ? globalObj.instSwitchCategoriesTouch : globalObj.instSwitchCategories
    // Get numbers
    blockParamsCats.nMiniBlocks = globalObj.blockSwitch_nMiniBlocks
    blockParamsCats.nTrials = globalObj.blockSwitch_nTrials
    // The rest is like blocks 1 and 2.
    blockCondition = blockParamsCats.left1.name + ',' + blockParamsCats.right1.name
    blockParamsCats.blockNum = iBlock
    blockParamsCats.nCats = 2
    trialSequence.push(getInstTrial(blockParamsCats))
    // The layout for the sorting trials.
    blockLayout = getLayout(blockParamsCats)
    // Fill the trials.
    nTrialsInMini = blockParamsCats.nTrials / blockParamsCats.nMiniBlocks
    var iBlock6Mini
    for (iBlock6Mini = 1; iBlock6Mini <= blockParamsCats.nMiniBlocks; iBlock6Mini++) {
      trialSequence.push(getMiniMixer2({
        nTrialsInMini: nTrialsInMini,
        currentCond: blockCondition,
        rightTrial: rightCatTrial,
        leftTrial: leftCatTrial,
        blockNum: iBlock,
        blockLayout: blockLayout}))
    }
    /// ///////////////////////////
    /// /The other combined block
    iBlock++
    // Get the categories side from the switch block.
    blockParamsCombined.right2 = blockParamsCats.right1
    blockParamsCombined.left2 = blockParamsCats.left1
    blockCondition = blockParamsCombined.left2.name + '/' + blockParamsCombined.left1.name + ',' + blockParamsCombined.right2.name + '/' + blockParamsCombined.right1.name
    // Number variables.
    blockParamsCombined.nMiniBlocks = globalObj.blockFirstCombined_nMiniBlocks
    blockParamsCombined.nTrials = globalObj.blockFirstCombined_nTrials
    blockParamsCombined.blockNum = iBlock
    blockParamsCombined.nCats = 4
    // Instruction trial.
    blockParamsCombined.instTemplate = isTouch ? globalObj.instFirstCombinedTouch : globalObj.instFirstCombined
    if (globalObj.instThirdCombined !== 'instFirstCombined') {
      blockParamsCombined.instTemplate = isTouch ? globalObj.instThirdCombinedTouch : globalObj.instThirdCombined
    }
    trialSequence.push(getInstTrial(blockParamsCombined))
    // Layout for the sorting trials.
    blockLayout = getLayout(blockParamsCombined)
    // Fill the trials.
    nTrialsInMini = blockParamsCombined.nTrials / blockParamsCombined.nMiniBlocks
    var iBlock7Mini
    for (iBlock7Mini = 1; iBlock7Mini <= blockParamsCombined.nMiniBlocks; iBlock7Mini++) {
      trialSequence.push(getMiniMixer4({
        nTrialsInMini: nTrialsInMini,
        currentCond: blockCondition,
        rightTrial1: rightAttTrial,
        leftTrial1: leftAttTrial,
        rightTrial2: rightCatTrial,
        leftTrial2: leftCatTrial,
        blockNum: iBlock,
        blockLayout: blockLayout}))
    }
    /// ///////////////////////////
    /// /Second combined block.
    if (globalObj.nBlocks === 8) { // Fifth block is another combined block.
      iBlock++
      blockParamsCombined.blockNum = iBlock
      blockParamsCombined.nMiniBlocks = globalObj.blockSecondCombined_nMiniBlocks
      blockParamsCombined.nTrials = globalObj.blockSecondCombined_nTrials
      // Instructions trial.
      blockParamsCombined.instTemplate = isTouch ? globalObj.instSecondCombinedTouch : globalObj.instSecondCombined
      if (globalObj.instFourthCombined !== 'instSecondCombined') {
        blockParamsCombined.instTemplate = isTouch ? globalObj.instFourthCombinedTouch : globalObj.instFourthCombined
      }
      trialSequence.push(getInstTrial(blockParamsCombined))
      // Layout for sorting trials.
      blockLayout = getLayout(blockParamsCombined)
      // Fill the trials.
      nTrialsInMini = blockParamsCombined.nTrials / blockParamsCombined.nMiniBlocks
      var iBlock8Mini
      for (iBlock8Mini = 1; iBlock8Mini <= blockParamsCombined.nMiniBlocks; iBlock8Mini++) {
        trialSequence.push(getMiniMixer4({
          nTrialsInMini: nTrialsInMini,
          currentCond: blockCondition,
          rightTrial1: rightAttTrial,
          leftTrial1: leftAttTrial,
          rightTrial2: rightCatTrial,
          leftTrial2: leftCatTrial,
          blockNum: iBlock,
          blockLayout: blockLayout}))
      }
    }
    /// ///////////////////////////
    // Add final trial
    trialSequence.push({
      inherit: 'instructions',
      data: {blockStart: true},
      layout: [{media: {word: ''}}],
      stimuli: [
        {
          inherit: 'Default',
          media: {word: (isTouch ? piCurrent.finalTouchText : piCurrent.finalText)}
        }
      ]
    })

    // Add the trials sequence to the API.
    API.addSequence(trialSequence)

    /**
  *Compute scores and feedback messages
  **/
    var errorLatencyUse = piCurrent.errorCorrection ? 'latency' : 'penalty'
    // Settings for the score computation.
    scorer.addSettings('compute', {
      ErrorVar: 'score',
      condVar: 'condition',
      // condition 1
      cond1VarValues: [
        cat1.name + '/' + att1.name + ',' + cat2.name + '/' + att2.name,
        cat2.name + '/' + att2.name + ',' + cat1.name + '/' + att1.name
      ],
      // condition 2
      cond2VarValues: [
        cat2.name + '/' + att1.name + ',' + cat1.name + '/' + att2.name,
        cat1.name + '/' + att2.name + ',' + cat2.name + '/' + att1.name
      ],
      parcelVar: 'parcel', // We use only one parcel because it is probably not less reliable.
      parcelValue: ['first'],
      fastRT: 150, // Below this reaction time, the latency is considered extremely fast.
      maxFastTrialsRate: 0.1, // Above this % of extremely fast responses within a condition, the participant is considered too fast.
      minRT: 400, // Below this latency
      maxRT: 10000, // above this
      errorLatency: {use: errorLatencyUse, penalty: 600, useForSTD: true},
      postSettings: {score: 'score', msg: 'feedback', url: '/implicit/scorer'}
    })

    // Helper function to set the feedback messages.
    function getFB (inText, categoryA, categoryB) {
      var retText = inText.replace(/attribute1/g, att1.name)
      retText = retText.replace(/attribute2/g, att2.name)
      retText = retText.replace(/categoryA/g, categoryA)
      retText = retText.replace(/categoryB/g, categoryB)
      return retText
    }

    // Set the feedback messages.
    var messageDef = [
      { cut: '-0.65', message: getFB(piCurrent.fb_strong_Att1WithCatA_Att2WithCatB, category1name, category2name) },
      { cut: '-0.35', message: getFB(piCurrent.fb_moderate_Att1WithCatA_Att2WithCatB, category1name, category2name) },
      { cut: '-0.15', message: getFB(piCurrent.fb_slight_Att1WithCatA_Att2WithCatB, category1name, category2name) },
      { cut: '0.15', message: getFB(piCurrent.fb_equal_CatAvsCatB, category1name, category2name) },
      { cut: '0.35', message: getFB(piCurrent.fb_slight_Att1WithCatA_Att2WithCatB, category2name, category1name) },
      { cut: '0.65', message: getFB(piCurrent.fb_moderate_Att1WithCatA_Att2WithCatB, category2name, category1name) },
      { cut: '5', message: getFB(piCurrent.fb_strong_Att1WithCatA_Att2WithCatB, category2name, category1name) }
    ]
    var scoreMessageObject = { MessageDef: messageDef }
    if (piCurrent.manyErrors !== '') {
      scoreMessageObject.manyErrors = piCurrent.manyErrors
    }
    if (piCurrent.tooFast !== '') {
      scoreMessageObject.tooFast = piCurrent.tooFast
    }
    if (piCurrent.notEnough !== '') {
      scoreMessageObject.notEnough = piCurrent.notEnough
    }
    // Set messages to the scorer.
    scorer.addSettings('message', scoreMessageObject)

    return API.script
  }

  return qiatExtension
})
