import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get helloWorld => 'Salamu Dunia!';

  @override
  String get refresh => 'refresh';

  @override
  String get back => 'back';

  @override
  String get menu => 'menu';

  @override
  String get ok => 'Sawa';

  @override
  String get addtodo => 'add new todo';

  @override
  String get addassign => 'add new assignment';

  @override
  String get navigateright => 'navigate right';

  @override
  String get navigateleft => 'navigate left';

  @override
  String get success => 'Success';

  @override
  String get passwordlinksent => 'Password reset link has been sent to your email.';

  @override
  String get generic_error_prompt => 'Kosa limetokea';

  @override
  String get generic_error_prompt1 => 'There was an error submitting your request, kindly check your internet connection or verify your credetials before submission.';

  @override
  String get login_error_cannot_find_user => 'Haiwezi kupata mtumiaji na maelezo yaliyoingizwa';

  @override
  String get login_error_wrong_credentials => 'Maelezo sio sahihi';

  @override
  String get login => 'Ingia';

  @override
  String get letmein => 'Let me in';

  @override
  String get while_we_can => 'Wakati tunaweza';

  @override
  String get while_we_could => 'Wakati tunaweza';

  @override
  String get email_text_field_placeholder => 'Anwani ya Barua pepe';

  @override
  String get password_text_field_placeholder => 'Nenosiri';

  @override
  String get sign_up_instead => 'Jisajili Badala yake ?';

  @override
  String get forgot_password => 'Umesahau nenosiri ?';

  @override
  String get sign_up => 'Jisajili';

  @override
  String get signmeup => 'Sign me Up';

  @override
  String get internet_error => 'Kosa la muunganisho wa mtandao';

  @override
  String get account_disable => 'Akaunti imelemazwa kwa muda';

  @override
  String get weak_password => 'Nenosiri dhaifu';

  @override
  String get email_already_in_use => 'Barua pepe tayari inatumika.';

  @override
  String get invalid_email => 'Barua pepe batili.';

  @override
  String get password_mismatch => 'Nenosiri hazilingani';

  @override
  String get confirm_password => 'Thibitisha Nenosiri';

  @override
  String get login_instead => 'Ingia Badala yake ?';

  @override
  String get verify_email => 'Thibitisha Barua pepe';

  @override
  String get verify_message => 'Barua pepe imepelekwa kwako kwa uthibitisho. Tafadhali, bonyeza kiungo ili kuthibitisha. Kisha, endelea kuingia.\nHata hivyo, kama hujapokea barua pepe, bonyeza kitufe cha kutuma tena chini ili kutuma kiungo tena.\n\nAsante.';

  @override
  String get resend_link => 'Tuma tena Kiungo';

  @override
  String get login_q => 'Ingia ?';

  @override
  String get sign_upq => 'Jisajili ?';

  @override
  String get forgot_message => 'Ingiza barua pepe yako kisha bonyeza kitufe cha Rudisha chini. Barua pepe na kiungo cha kurudisha itatumwa kwako.';

  @override
  String get reset_password => 'Rudisha Nenosiri';

  @override
  String get resetmypassword => 'Reset my password';

  @override
  String get home => 'Nyumbani';

  @override
  String get work => 'Kazi';

  @override
  String get personal => 'Binafsi';

  @override
  String get title => 'Kichwa';

  @override
  String get begin => 'Anza';

  @override
  String get finish => 'Maliza';

  @override
  String get time => 'Wakati';

  @override
  String get allday => 'Siku nzima';

  @override
  String get createalert => 'Unda onyo';

  @override
  String get beforetime => 'kabla ya wakati';

  @override
  String get cancel => 'Ghairi';

  @override
  String get create => 'Unda';

  @override
  String get alert => 'Onyo';

  @override
  String get description => 'Maelezo';

  @override
  String get attach => 'Ambatanisha faili';

  @override
  String get incorrectdate => 'Muundo wa tarehe sio sahihi';

  @override
  String get second => 'sekunde';

  @override
  String get minute => 'dakika';

  @override
  String get hour => 'saa';

  @override
  String get day => 'siku';

  @override
  String get week => 'wiki';

  @override
  String get month => 'mwezi';

  @override
  String get once => 'once';

  @override
  String get daily => 'daily';

  @override
  String get weekly => 'weekly';

  @override
  String get monthly => 'monthly';

  @override
  String get titleEmpty => 'Kichwa ni lazima';

  @override
  String get beginEmpty => 'Wakati wa kuanza wa kazi ni lazima';

  @override
  String get finishEmpty => 'Wakati wa kumaliza wa kazi ni lazima';

  @override
  String get delete => 'Futa';

  @override
  String get account => 'Akaunti';

  @override
  String get all => 'Yote';

  @override
  String get open => 'Fungua';

  @override
  String get closed => 'Fungwa';

  @override
  String get archived => 'Imehifadhiwa';

  @override
  String get diary => 'Shajara';

  @override
  String get tasks => 'Kazi';

  @override
  String get abouttoday => 'Kuhusu leo ...';

  @override
  String task(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kazi',
      one: 'Kazi',
      zero: 'Hakuna Kazi bado',
    );
    return '$_temp0';
  }

  @override
  String get accountforthistask => 'Akaunti kwa kazi hii...';

  @override
  String get markascompleted => 'Weka kama Imekamilika';

  @override
  String get stillneedswork => 'Bado inahitaji Kazi?';

  @override
  String get profile => 'Profaili';

  @override
  String get notification => 'Arifa';

  @override
  String get addnewcontact => 'Ongeza mwasiliani mpya';

  @override
  String get deletemyaccount => 'Futa akaunti yangu';

  @override
  String get logout => 'Toka';

  @override
  String get accountname => 'Jina la Akaunti';

  @override
  String get accountemail => 'Barua pepe ya Akaunti';

  @override
  String get greaterthan3mb => 'Picha iliyochaguliwa ni kubwa kuliko 3Mb.';

  @override
  String get addnewcontact2 => 'Ongeza Mwasiliani Mpya';

  @override
  String get search => 'Tafuta';

  @override
  String get couldnotfindContact => 'Samahani, mwasiliani huyo haukupatikana';

  @override
  String get pleasewaitamoment => 'Tafadhali subiri kwa muda';

  @override
  String get synchronizing => 'Kusawazisha';

  @override
  String get editContactName => 'Hariri Jina la Mwasiliani';

  @override
  String get contactEmail => 'Barua pepe ya Mwasiliani';

  @override
  String get saveContact => 'Hifadhi Mwasiliani';

  @override
  String get jan => 'Jan';

  @override
  String get feb => 'Feb';

  @override
  String get mar => 'Mar';

  @override
  String get apr => 'Apr';

  @override
  String get may1 => 'Mei';

  @override
  String get jun => 'Jun';

  @override
  String get jul => 'Jul';

  @override
  String get aug => 'Ago';

  @override
  String get sep => 'Sep';

  @override
  String get oct => 'Okt';

  @override
  String get nov => 'Nov';

  @override
  String get dec => 'Des';

  @override
  String get today => 'Leo';

  @override
  String get set => 'Weka';

  @override
  String get assign => 'Panga';

  @override
  String get uploadingtocloud => 'Tafadhali subiri, kupakia faili kwenye wingu.';

  @override
  String get message => 'Ujumbe';

  @override
  String get updateInfo => 'Sasisha Taarifa';

  @override
  String get hometowork => 'Mwasiliani huyu tayari yupo kwenye mawasiliano ya Nyumbani.\nKuendelea kutafanya mwasiliani huyu ataondolewa kutoka kwa mawasiliano ya Nyumbani na kupelekwa kwa mawasiliano ya Kazi';

  @override
  String get hometowork2 => 'Kuendelea kutafanya mwasiliani huyu ataondolewa kutoka kwa mawasiliano ya Nyumbani na kupelekwa kwa mawasiliano ya Kazi';

  @override
  String get worktohome => 'Mwasiliani huyu tayari yupo kwenye mawasiliano ya Kazi.\nKuendelea kutafanya mwasiliani huyu ataondolewa kutoka kwa mawasiliano ya Kazi na kupelekwa kwa mawasiliano ya Nyumbani';

  @override
  String get worktohome2 => 'Kuendelea kutafanya mwasiliani huyu ataondolewa kutoka kwa mawasiliano ya Kazi na kupelekwa kwa mawasiliano ya Nyumbani';

  @override
  String get contacts => 'Mawasiliano';

  @override
  String get homecontact => 'Mawasiliano ya Nyumbani';

  @override
  String get workcontact => 'Mawasiliano ya Kazi';

  @override
  String get deleteinfo => 'Onyo: Kuendelea kutafanya kutafuta kufuta mwasiliani huyu kwa kudumu';

  @override
  String get update => 'Sasisha';

  @override
  String get save => 'Hifadhi';

  @override
  String get tdo => 'Kufanya';

  @override
  String get toaccount => 'Kwa Akaunti';

  @override
  String get todo => 'Kufanya';

  @override
  String get pending => 'Inasubiri';

  @override
  String get done => 'Imekamilika';

  @override
  String get archive => 'Hifadhi';

  @override
  String get accept => 'Kubali';

  @override
  String get decline => 'Kataa';

  @override
  String get declined => 'Imekataliwa';

  @override
  String get viewaccount => 'Tazama Akaunti';

  @override
  String get submit => 'Wasilisha';

  @override
  String get completed => 'Imekamilika';

  @override
  String get underway => 'Inaendelea';

  @override
  String get needswork => 'Inahitaji Kazi?';

  @override
  String get markdone => 'Weka kama Imekamilika?';

  @override
  String get pendingapproval => 'Inasubiri Idhini';

  @override
  String get filedoesnotexist => 'Faili haipo.';

  @override
  String get couldnotdeletefile => 'Kosa: Haiwezi kufuta faili';

  @override
  String get deletefile => 'Onyo: Kuendelea kutafanya kutafuta kufuta faili hii kwa kudumu';

  @override
  String get deletetask => 'Onyo: Kuendelea kutafanya kutafuta kufuta kazi hii kwa kudumu';

  @override
  String get calendar => 'Kalenda';

  @override
  String get deleteaccount => 'Futa Akaunti';

  @override
  String get invalidcredentials => 'Kufuta akaunti kumeshindikana, maelezo sio sahihi';

  @override
  String get dailyassignlimit => 'Kikomo cha kila siku cha kuweka ni tano';

  @override
  String get unabletofetchinternet => 'Haiwezekani kupata mawasiliano.\nTafadhali angalia uunganisho wako wa intaneti';

  @override
  String get monday => 'Jumatatu';

  @override
  String get tuesday => 'Jumanne';

  @override
  String get wednesday => 'Jumatano';

  @override
  String get thursday => 'Alhamisi';

  @override
  String get friday => 'Ijumaa';

  @override
  String get saturday => 'Jumamosi';

  @override
  String get sunday => 'Jumapili';

  @override
  String get tassign => 'Kabithi';

  @override
  String get eraseall => 'Onyo! Yote uliyojumuisha itafutwa.\n\nHii ni hatua isiyoweza kurekebishwa, je, una uhakika unataka kuendelea?';

  @override
  String get accountdelfailedinternet => 'Kufuta akaunti kumeshindikana tafadhali angalia uunganisho wako wa intaneti';

  @override
  String get maximumcloudsize => 'Kwa bahati mbaya, umekosa ukubwa wa juu wa kupakia kwenye wingu wa 150Kb';

  @override
  String get failedrequestinternet => 'Ombi limekwama.\nTafadhali angalia uunganisho wako wa intaneti';

  @override
  String get accountdoesnotexist => 'Ombi limekwama\nMtumiaji huyu huenda amefuta akaunti yake au akaunti yake imezuiwa';

  @override
  String get settimeperiod => 'Tafadhali weka kipindi sahihi. Wakati wa kuanza hauwezi kuwa sawa au baada ya wakati wa kumaliza.';

  @override
  String get january => 'Januari';

  @override
  String get february => 'Februari';

  @override
  String get march => 'Machi';

  @override
  String get april => 'Aprili';

  @override
  String get may => 'Mei';

  @override
  String get june => 'Juni';

  @override
  String get july => 'Julai';

  @override
  String get august => 'Agosti';

  @override
  String get september => 'Septemba';

  @override
  String get october => 'Oktoba';

  @override
  String get november => 'Novemba';

  @override
  String get december => 'Desemba';

  @override
  String get sun => 'JUM';

  @override
  String get mon => 'JAT';

  @override
  String get tue => 'JNU';

  @override
  String get wed => 'JMT';

  @override
  String get thu => 'ALH';

  @override
  String get fri => 'IJM';

  @override
  String get sat => 'JMO';

  @override
  String get personalinfotodo => 'Unda kazi zako hapa, zitaonekana kama orodha';

  @override
  String get calendarinfoyear => 'Bonyeza mwaka au piga mzunguko wa miaka';

  @override
  String get calendarinfomonth => 'Bonyeza mwezi au piga mzigogoro kupitia miezi';

  @override
  String get calendarinfodays => 'Bonyeza tarehe unayotaka';

  @override
  String get calendarinfoweekss => 'Bonyeza wiki unayotaka';

  @override
  String get personalinfoaccount => 'Andika/angalia akaunti ya kazi zako au unda kalenda';

  @override
  String get personalinfoassign => 'Tenga kazi za kufanywa na wengine katika mawasiliano yako';

  @override
  String get homeinfoassigned => 'Kazi zilizopewa na mawasiliano ya nyumbani zitaonekana hapa';

  @override
  String get workinfoassigned => 'Kazi zilizopewa na mawasiliano ya kazi zitaonekana hapa';

  @override
  String get disableInfo => 'Ili kulemaza vidokezo kutoka kwa programu yako, \nbonyeza ishara ya wasifu. Kwenye menyu ya wasifu inayoonekana. Geuza menyu ya vidokezo kuwa \'mbali\'.';

  @override
  String get info => 'Maelezo';

  @override
  String get hints => 'Wezesha vidokezo';

  @override
  String get effectchanges => 'Kufanya mabadiliko haya, programu itaanza upya. Ungependa kuendelea?';
}
