import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_sw.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('sw')
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'refresh'**
  String get refresh;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'back'**
  String get back;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'menu'**
  String get menu;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @addtodo.
  ///
  /// In en, this message translates to:
  /// **'add new todo'**
  String get addtodo;

  /// No description provided for @addassign.
  ///
  /// In en, this message translates to:
  /// **'add new assignment'**
  String get addassign;

  /// No description provided for @navigateright.
  ///
  /// In en, this message translates to:
  /// **'navigate right'**
  String get navigateright;

  /// No description provided for @navigateleft.
  ///
  /// In en, this message translates to:
  /// **'navigate left'**
  String get navigateleft;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @passwordlinksent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link has been sent to your email.'**
  String get passwordlinksent;

  /// No description provided for @generic_error_prompt.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get generic_error_prompt;

  /// No description provided for @generic_error_prompt1.
  ///
  /// In en, this message translates to:
  /// **'There was an error submitting your request, kindly check your internet connection or verify your credetials before submission.'**
  String get generic_error_prompt1;

  /// No description provided for @login_error_cannot_find_user.
  ///
  /// In en, this message translates to:
  /// **'Cannot find a user with the entered credentials'**
  String get login_error_cannot_find_user;

  /// No description provided for @login_error_wrong_credentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong credentials'**
  String get login_error_wrong_credentials;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @letmein.
  ///
  /// In en, this message translates to:
  /// **'Let me in'**
  String get letmein;

  /// No description provided for @while_we_can.
  ///
  /// In en, this message translates to:
  /// **'While we can'**
  String get while_we_can;

  /// No description provided for @while_we_could.
  ///
  /// In en, this message translates to:
  /// **'While we could'**
  String get while_we_could;

  /// No description provided for @email_text_field_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email_text_field_placeholder;

  /// No description provided for @password_text_field_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_text_field_placeholder;

  /// No description provided for @sign_up_instead.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Instead ?'**
  String get sign_up_instead;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password ?'**
  String get forgot_password;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @signmeup.
  ///
  /// In en, this message translates to:
  /// **'Sign me Up'**
  String get signmeup;

  /// No description provided for @internet_error.
  ///
  /// In en, this message translates to:
  /// **'Interner connection error'**
  String get internet_error;

  /// No description provided for @account_disable.
  ///
  /// In en, this message translates to:
  /// **'Account is temporarily disabled'**
  String get account_disable;

  /// No description provided for @weak_password.
  ///
  /// In en, this message translates to:
  /// **'Weak Password'**
  String get weak_password;

  /// No description provided for @email_already_in_use.
  ///
  /// In en, this message translates to:
  /// **'Email already in use.'**
  String get email_already_in_use;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email.'**
  String get invalid_email;

  /// No description provided for @password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get password_mismatch;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @login_instead.
  ///
  /// In en, this message translates to:
  /// **'Login Instead ?'**
  String get login_instead;

  /// No description provided for @verify_email.
  ///
  /// In en, this message translates to:
  /// **'Vefify Email'**
  String get verify_email;

  /// No description provided for @verify_message.
  ///
  /// In en, this message translates to:
  /// **'An email has been sent to you for verification. Kindly, click the link to verify. Then, proceed to login.\nHowever, if  you have not received the email, press the resend button below to resend the link.\n\nThank you.'**
  String get verify_message;

  /// No description provided for @resend_link.
  ///
  /// In en, this message translates to:
  /// **'Resend Link'**
  String get resend_link;

  /// No description provided for @login_q.
  ///
  /// In en, this message translates to:
  /// **'Login ?'**
  String get login_q;

  /// No description provided for @sign_upq.
  ///
  /// In en, this message translates to:
  /// **'Sign Up ?'**
  String get sign_upq;

  /// No description provided for @forgot_message.
  ///
  /// In en, this message translates to:
  /// **'An email with the reset link will be sent to you.\n\n'**
  String get forgot_message;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @resetmypassword.
  ///
  /// In en, this message translates to:
  /// **'Reset my password'**
  String get resetmypassword;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @begin.
  ///
  /// In en, this message translates to:
  /// **'Begin'**
  String get begin;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @allday.
  ///
  /// In en, this message translates to:
  /// **'Allday'**
  String get allday;

  /// No description provided for @createalert.
  ///
  /// In en, this message translates to:
  /// **'Create alert'**
  String get createalert;

  /// No description provided for @beforetime.
  ///
  /// In en, this message translates to:
  /// **'before time'**
  String get beforetime;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @attach.
  ///
  /// In en, this message translates to:
  /// **'Attach a file'**
  String get attach;

  /// No description provided for @incorrectdate.
  ///
  /// In en, this message translates to:
  /// **'Incorrect date format'**
  String get incorrectdate;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'second'**
  String get second;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @once.
  ///
  /// In en, this message translates to:
  /// **'once'**
  String get once;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'monthly'**
  String get monthly;

  /// No description provided for @titleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleEmpty;

  /// No description provided for @beginEmpty.
  ///
  /// In en, this message translates to:
  /// **'Task begin time is required'**
  String get beginEmpty;

  /// No description provided for @finishEmpty.
  ///
  /// In en, this message translates to:
  /// **'Task finish time is required'**
  String get finishEmpty;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @diary.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get diary;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @abouttoday.
  ///
  /// In en, this message translates to:
  /// **'About today ...'**
  String get abouttoday;

  /// No description provided for @task.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No Task yet} =1{Task} other{Tasks}}'**
  String task(int count);

  /// No description provided for @accountforthistask.
  ///
  /// In en, this message translates to:
  /// **'Account for this task...'**
  String get accountforthistask;

  /// No description provided for @markascompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markascompleted;

  /// No description provided for @stillneedswork.
  ///
  /// In en, this message translates to:
  /// **'Still needs Work?'**
  String get stillneedswork;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @addnewcontact.
  ///
  /// In en, this message translates to:
  /// **'Add new contact'**
  String get addnewcontact;

  /// No description provided for @deletemyaccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deletemyaccount;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @accountname.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountname;

  /// No description provided for @accountemail.
  ///
  /// In en, this message translates to:
  /// **'Account email'**
  String get accountemail;

  /// No description provided for @greaterthan3mb.
  ///
  /// In en, this message translates to:
  /// **'Image selected is greater than 3Mb.'**
  String get greaterthan3mb;

  /// No description provided for @addnewcontact2.
  ///
  /// In en, this message translates to:
  /// **'Add New Contact'**
  String get addnewcontact2;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @couldnotfindContact.
  ///
  /// In en, this message translates to:
  /// **'Sorry, that contact could not be found'**
  String get couldnotfindContact;

  /// No description provided for @pleasewaitamoment.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment'**
  String get pleasewaitamoment;

  /// No description provided for @synchronizing.
  ///
  /// In en, this message translates to:
  /// **'Synchronizing'**
  String get synchronizing;

  /// No description provided for @editContactName.
  ///
  /// In en, this message translates to:
  /// **'Edit Contact Name'**
  String get editContactName;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'Contact Email'**
  String get contactEmail;

  /// No description provided for @saveContact.
  ///
  /// In en, this message translates to:
  /// **'Save Contact'**
  String get saveContact;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @may1.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may1;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get sep;

  /// No description provided for @oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get dec;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @assign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assign;

  /// No description provided for @uploadingtocloud.
  ///
  /// In en, this message translates to:
  /// **'Please wait, uploading files to cloud.'**
  String get uploadingtocloud;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @updateInfo.
  ///
  /// In en, this message translates to:
  /// **'Update Information'**
  String get updateInfo;

  /// No description provided for @hometowork.
  ///
  /// In en, this message translates to:
  /// **'This contact already exists in Home contacts.\nProceeding will move this contact from Home contacts to Work contacts'**
  String get hometowork;

  /// No description provided for @hometowork2.
  ///
  /// In en, this message translates to:
  /// **'Proceeding will move this contact from Home contacts to Work contacts'**
  String get hometowork2;

  /// No description provided for @worktohome.
  ///
  /// In en, this message translates to:
  /// **'This contact already exists in Work contacts.\nProceeding will move this contact from Work contacts to Home contacts'**
  String get worktohome;

  /// No description provided for @worktohome2.
  ///
  /// In en, this message translates to:
  /// **'Proceeding will move this contact from Work contacts to Home contacts'**
  String get worktohome2;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @homecontact.
  ///
  /// In en, this message translates to:
  /// **'Home Contacts'**
  String get homecontact;

  /// No description provided for @workcontact.
  ///
  /// In en, this message translates to:
  /// **'Work Contacts'**
  String get workcontact;

  /// No description provided for @deleteinfo.
  ///
  /// In en, this message translates to:
  /// **'Warning: proceeding will delete this contact permanently'**
  String get deleteinfo;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @tdo.
  ///
  /// In en, this message translates to:
  /// **'2-Do'**
  String get tdo;

  /// No description provided for @toaccount.
  ///
  /// In en, this message translates to:
  /// **'2-Account'**
  String get toaccount;

  /// No description provided for @todo.
  ///
  /// In en, this message translates to:
  /// **'Todo'**
  String get todo;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @declined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get declined;

  /// No description provided for @viewaccount.
  ///
  /// In en, this message translates to:
  /// **'View Account'**
  String get viewaccount;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @underway.
  ///
  /// In en, this message translates to:
  /// **'Underway'**
  String get underway;

  /// No description provided for @needswork.
  ///
  /// In en, this message translates to:
  /// **'Needs work?'**
  String get needswork;

  /// No description provided for @markdone.
  ///
  /// In en, this message translates to:
  /// **'Mark done?'**
  String get markdone;

  /// No description provided for @pendingapproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingapproval;

  /// No description provided for @filedoesnotexist.
  ///
  /// In en, this message translates to:
  /// **'The file does not exist.'**
  String get filedoesnotexist;

  /// No description provided for @couldnotdeletefile.
  ///
  /// In en, this message translates to:
  /// **'Error: Could not delete file'**
  String get couldnotdeletefile;

  /// No description provided for @deletefile.
  ///
  /// In en, this message translates to:
  /// **'Warning: proceeding will delete this file permanently'**
  String get deletefile;

  /// No description provided for @deletetask.
  ///
  /// In en, this message translates to:
  /// **'Warning: proceeding will delete this task permanently'**
  String get deletetask;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @deleteaccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteaccount;

  /// No description provided for @invalidcredentials.
  ///
  /// In en, this message translates to:
  /// **'Account deletion failed invalid credentials'**
  String get invalidcredentials;

  /// No description provided for @dailyassignlimit.
  ///
  /// In en, this message translates to:
  /// **'the daily assign limit is five'**
  String get dailyassignlimit;

  /// No description provided for @unabletofetchinternet.
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch contacts.\nKindly check your internet connection'**
  String get unabletofetchinternet;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @tassign.
  ///
  /// In en, this message translates to:
  /// **'2-Assign'**
  String get tassign;

  /// No description provided for @eraseall.
  ///
  /// In en, this message translates to:
  /// **'Warning! All you have gathered will be erased.\n\nThis is an irreversible action are you sure you want to proceed?'**
  String get eraseall;

  /// No description provided for @accountdelfailedinternet.
  ///
  /// In en, this message translates to:
  /// **'Account deletion failed kindly check your internet connection'**
  String get accountdelfailedinternet;

  /// No description provided for @maximumcloudsize.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, you have exceeded the maximum cloud upload size of 150Kb'**
  String get maximumcloudsize;

  /// No description provided for @failedrequestinternet.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit request.\nKindly check your internet connection'**
  String get failedrequestinternet;

  /// No description provided for @accountdoesnotexist.
  ///
  /// In en, this message translates to:
  /// **'Request failed\nThis user may have deleted their account or may have had their account suspended'**
  String get accountdoesnotexist;

  /// No description provided for @settimeperiod.
  ///
  /// In en, this message translates to:
  /// **'Kindly set the correct period\nBegin time cannot be equal to\nor after Finish time'**
  String get settimeperiod;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'SUN'**
  String get sun;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'MON'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'TUE'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'WED'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'THU'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'FRI'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'SAT'**
  String get sat;

  /// No description provided for @personalinfotodo.
  ///
  /// In en, this message translates to:
  /// **'Create your todo(s) here they will appear as a list'**
  String get personalinfotodo;

  /// No description provided for @calendarinfoyear.
  ///
  /// In en, this message translates to:
  /// **'Tap on year or scroll through the years'**
  String get calendarinfoyear;

  /// No description provided for @calendarinfomonth.
  ///
  /// In en, this message translates to:
  /// **'Tap on month or shuffle through the months'**
  String get calendarinfomonth;

  /// No description provided for @calendarinfodays.
  ///
  /// In en, this message translates to:
  /// **'Tap on the date of choice'**
  String get calendarinfodays;

  /// No description provided for @calendarinfoweekss.
  ///
  /// In en, this message translates to:
  /// **'Tap on the week of choice'**
  String get calendarinfoweekss;

  /// No description provided for @personalinfoaccount.
  ///
  /// In en, this message translates to:
  /// **'Write/view an account of your tasks or create a diary'**
  String get personalinfoaccount;

  /// No description provided for @personalinfoassign.
  ///
  /// In en, this message translates to:
  /// **'Assign work to be done by others in your contacts'**
  String get personalinfoassign;

  /// No description provided for @homeinfoassigned.
  ///
  /// In en, this message translates to:
  /// **'Tasks assigned to you by home contacts will appear here'**
  String get homeinfoassigned;

  /// No description provided for @workinfoassigned.
  ///
  /// In en, this message translates to:
  /// **'Tasks assigned to you by work contacts will appear here'**
  String get workinfoassigned;

  /// No description provided for @disableInfo.
  ///
  /// In en, this message translates to:
  /// **'To disable hints. Open the profile menu. Toggle the hints menu to \'off\'.'**
  String get disableInfo;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @hints.
  ///
  /// In en, this message translates to:
  /// **'Enable hints'**
  String get hints;

  /// No description provided for @effectchanges.
  ///
  /// In en, this message translates to:
  /// **'To effect this changes, the app will restart. Would you like to proceed?'**
  String get effectchanges;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'hi', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'sw': return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
