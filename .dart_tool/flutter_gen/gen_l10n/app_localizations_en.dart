import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get refresh => 'refresh';

  @override
  String get back => 'back';

  @override
  String get menu => 'menu';

  @override
  String get ok => 'Ok';

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
  String get generic_error_prompt => 'An error occurred';

  @override
  String get generic_error_prompt1 => 'There was an error submitting your request, kindly check your internet connection or verify your credetials before submission.';

  @override
  String get login_error_cannot_find_user => 'Cannot find a user with the entered credentials';

  @override
  String get login_error_wrong_credentials => 'Wrong credentials';

  @override
  String get login => 'Login';

  @override
  String get letmein => 'Let me in';

  @override
  String get while_we_can => 'While we can';

  @override
  String get while_we_could => 'While we could';

  @override
  String get email_text_field_placeholder => 'Email address';

  @override
  String get password_text_field_placeholder => 'Password';

  @override
  String get sign_up_instead => 'Sign Up Instead ?';

  @override
  String get forgot_password => 'Forgot password ?';

  @override
  String get sign_up => 'Sign Up';

  @override
  String get signmeup => 'Sign me Up';

  @override
  String get internet_error => 'Interner connection error';

  @override
  String get account_disable => 'Account is temporarily disabled';

  @override
  String get weak_password => 'Weak Password';

  @override
  String get email_already_in_use => 'Email already in use.';

  @override
  String get invalid_email => 'Invalid email.';

  @override
  String get password_mismatch => 'Passwords do not match';

  @override
  String get confirm_password => 'Confirm Password';

  @override
  String get login_instead => 'Login Instead ?';

  @override
  String get verify_email => 'Vefify Email';

  @override
  String get verify_message => 'An email has been sent to you for verification. Kindly, click the link to verify. Then, proceed to login.\nHowever, if  you have not received the email, press the resend button below to resend the link.\n\nThank you.';

  @override
  String get resend_link => 'Resend Link';

  @override
  String get login_q => 'Login ?';

  @override
  String get sign_upq => 'Sign Up ?';

  @override
  String get forgot_message => 'An email with the reset link will be sent to you.\n\n';

  @override
  String get reset_password => 'Reset Password';

  @override
  String get resetmypassword => 'Reset my password';

  @override
  String get home => 'Home';

  @override
  String get work => 'Work';

  @override
  String get personal => 'Personal';

  @override
  String get title => 'Title';

  @override
  String get begin => 'Begin';

  @override
  String get finish => 'Finish';

  @override
  String get time => 'Time';

  @override
  String get allday => 'Allday';

  @override
  String get createalert => 'Create alert';

  @override
  String get beforetime => 'before time';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get alert => 'Alert';

  @override
  String get description => 'Description';

  @override
  String get attach => 'Attach a file';

  @override
  String get incorrectdate => 'Incorrect date format';

  @override
  String get second => 'second';

  @override
  String get minute => 'minute';

  @override
  String get hour => 'hour';

  @override
  String get day => 'day';

  @override
  String get week => 'week';

  @override
  String get month => 'month';

  @override
  String get once => 'once';

  @override
  String get daily => 'daily';

  @override
  String get weekly => 'weekly';

  @override
  String get monthly => 'monthly';

  @override
  String get titleEmpty => 'Title is required';

  @override
  String get beginEmpty => 'Task begin time is required';

  @override
  String get finishEmpty => 'Task finish time is required';

  @override
  String get delete => 'Delete';

  @override
  String get account => 'Account';

  @override
  String get all => 'All';

  @override
  String get open => 'Open';

  @override
  String get closed => 'Closed';

  @override
  String get archived => 'Archived';

  @override
  String get diary => 'Diary';

  @override
  String get tasks => 'Tasks';

  @override
  String get abouttoday => 'About today ...';

  @override
  String task(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tasks',
      one: 'Task',
      zero: 'No Task yet',
    );
    return '$_temp0';
  }

  @override
  String get accountforthistask => 'Account for this task...';

  @override
  String get markascompleted => 'Mark as Completed';

  @override
  String get stillneedswork => 'Still needs Work?';

  @override
  String get profile => 'Profile';

  @override
  String get notification => 'Notification';

  @override
  String get addnewcontact => 'Add new contact';

  @override
  String get deletemyaccount => 'Delete my account';

  @override
  String get logout => 'Logout';

  @override
  String get accountname => 'Account name';

  @override
  String get accountemail => 'Account email';

  @override
  String get greaterthan3mb => 'Image selected is greater than 3Mb.';

  @override
  String get addnewcontact2 => 'Add New Contact';

  @override
  String get search => 'Search';

  @override
  String get couldnotfindContact => 'Sorry, that contact could not be found';

  @override
  String get pleasewaitamoment => 'Please wait a moment';

  @override
  String get synchronizing => 'Synchronizing';

  @override
  String get editContactName => 'Edit Contact Name';

  @override
  String get contactEmail => 'Contact Email';

  @override
  String get saveContact => 'Save Contact';

  @override
  String get jan => 'Jan';

  @override
  String get feb => 'Feb';

  @override
  String get mar => 'Mar';

  @override
  String get apr => 'Apr';

  @override
  String get may1 => 'May';

  @override
  String get jun => 'Jun';

  @override
  String get jul => 'Jul';

  @override
  String get aug => 'Aug';

  @override
  String get sep => 'Sep';

  @override
  String get oct => 'Oct';

  @override
  String get nov => 'Nov';

  @override
  String get dec => 'Dec';

  @override
  String get today => 'Today';

  @override
  String get set => 'Set';

  @override
  String get assign => 'Assign';

  @override
  String get uploadingtocloud => 'Please wait, uploading files to cloud.';

  @override
  String get message => 'Message';

  @override
  String get updateInfo => 'Update Information';

  @override
  String get hometowork => 'This contact already exists in Home contacts.\nProceeding will move this contact from Home contacts to Work contacts';

  @override
  String get hometowork2 => 'Proceeding will move this contact from Home contacts to Work contacts';

  @override
  String get worktohome => 'This contact already exists in Work contacts.\nProceeding will move this contact from Work contacts to Home contacts';

  @override
  String get worktohome2 => 'Proceeding will move this contact from Work contacts to Home contacts';

  @override
  String get contacts => 'Contacts';

  @override
  String get homecontact => 'Home Contacts';

  @override
  String get workcontact => 'Work Contacts';

  @override
  String get deleteinfo => 'Warning: proceeding will delete this contact permanently';

  @override
  String get update => 'Update';

  @override
  String get save => 'Save';

  @override
  String get tdo => '2-Do';

  @override
  String get toaccount => '2-Account';

  @override
  String get todo => 'Todo';

  @override
  String get pending => 'Pending';

  @override
  String get done => 'Done';

  @override
  String get archive => 'Archive';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get declined => 'Declined';

  @override
  String get viewaccount => 'View Account';

  @override
  String get submit => 'Submit';

  @override
  String get completed => 'Completed';

  @override
  String get underway => 'Underway';

  @override
  String get needswork => 'Needs work?';

  @override
  String get markdone => 'Mark done?';

  @override
  String get pendingapproval => 'Pending Approval';

  @override
  String get filedoesnotexist => 'The file does not exist.';

  @override
  String get couldnotdeletefile => 'Error: Could not delete file';

  @override
  String get deletefile => 'Warning: proceeding will delete this file permanently';

  @override
  String get deletetask => 'Warning: proceeding will delete this task permanently';

  @override
  String get calendar => 'Calendar';

  @override
  String get deleteaccount => 'Delete Account';

  @override
  String get invalidcredentials => 'Account deletion failed invalid credentials';

  @override
  String get dailyassignlimit => 'the daily assign limit is five';

  @override
  String get unabletofetchinternet => 'Unable to fetch contacts.\nKindly check your internet connection';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get tassign => '2-Assign';

  @override
  String get eraseall => 'Warning! All you have gathered will be erased.\n\nThis is an irreversible action are you sure you want to proceed?';

  @override
  String get accountdelfailedinternet => 'Account deletion failed kindly check your internet connection';

  @override
  String get maximumcloudsize => 'Unfortunately, you have exceeded the maximum cloud upload size of 150Kb';

  @override
  String get failedrequestinternet => 'Failed to submit request.\nKindly check your internet connection';

  @override
  String get accountdoesnotexist => 'Request failed\nThis user may have deleted their account or may have had their account suspended';

  @override
  String get settimeperiod => 'Kindly set the correct period\nBegin time cannot be equal to\nor after Finish time';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get sun => 'SUN';

  @override
  String get mon => 'MON';

  @override
  String get tue => 'TUE';

  @override
  String get wed => 'WED';

  @override
  String get thu => 'THU';

  @override
  String get fri => 'FRI';

  @override
  String get sat => 'SAT';

  @override
  String get personalinfotodo => 'Create your todo(s) here they will appear as a list';

  @override
  String get calendarinfoyear => 'Tap on year or scroll through the years';

  @override
  String get calendarinfomonth => 'Tap on month or shuffle through the months';

  @override
  String get calendarinfodays => 'Tap on the date of choice';

  @override
  String get calendarinfoweekss => 'Tap on the week of choice';

  @override
  String get personalinfoaccount => 'Write/view an account of your tasks or create a diary';

  @override
  String get personalinfoassign => 'Assign work to be done by others in your contacts';

  @override
  String get homeinfoassigned => 'Tasks assigned to you by home contacts will appear here';

  @override
  String get workinfoassigned => 'Tasks assigned to you by work contacts will appear here';

  @override
  String get disableInfo => 'To disable hints. Open the profile menu. Toggle the hints menu to \'off\'.';

  @override
  String get info => 'Info';

  @override
  String get hints => 'Enable hints';

  @override
  String get effectchanges => 'To effect this changes, the app will restart. Would you like to proceed?';
}
