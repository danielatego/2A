import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:two_a/ads/ads_state.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/notifications/todonotifications.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/authentication/fireauth.dart';
import 'package:two_a/firebase/bloc/auth_bloc.dart';
import 'package:two_a/firebase/bloc/auth_event.dart';
import 'package:two_a/firebase/bloc/auth_state.dart';
import 'package:two_a/helpers/loading/loading_screen.dart';
import 'package:two_a/views/dateonpress2.dart';
import 'package:two_a/views/forgot_password_view.dart';
import 'package:two_a/views/login_view.dart';
import 'package:two_a/views/register_view.dart';
import 'package:two_a/views/verify_email_view.dart';

//
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  // RequestConfiguration configuration =
  //     RequestConfiguration(testDeviceIds: ["B82D505A5A97A0E266A9AD4A2FAECC3E"]);
  // MobileAds.instance.updateRequestConfiguration(configuration);

  const String navigationActionId = 'id_3';
  String? selectedNotificationPayload;
  bool payloadOnSelectedNotification = false;
  await configureLocalTimeZone();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
    if (selectedNotificationPayload != null) {
      payloadOnSelectedNotification = true;
    }
  }
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('notification');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        SelectNotificationStream.add(notificationResponse.payload);
        break;
      case NotificationResponseType.selectedNotificationAction:
        if (notificationResponse.actionId == navigationActionId) {
          SelectNotificationStream.add(notificationResponse.payload);
        }
        break;
    }
  });
//designed the to assign personal interface
  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => MaterialApp(
        color: const Colour().primary,
        title: '2A',
        theme: ThemeData(
          scaffoldBackgroundColor: const Colour().lbg,
          useMaterial3: false,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FireAuth()),
          child: HomePage2A(
            notificationPayload: selectedNotificationPayload,
            didNotificationLaunchApp: payloadOnSelectedNotification,
          ),
        ),
      ),
    ),
  );
}

class HomePage2A extends StatelessWidget {
  final String? notificationPayload;
  final bool didNotificationLaunchApp;
  const HomePage2A({
    required this.notificationPayload,
    required this.didNotificationLaunchApp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? context.loc.pleasewaitamoment);
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        //context.
        if (state is AuthStateLoggedIn) {
          return didNotificationLaunchApp
              ? ShowCaseWidget(
                  builder: Builder(
                  builder: (context) => DateOnPress2(
                    date: datenow(),
                    context: context,
                    main: true,
                  ),
                ))
              :
              // ShowCaseWidget(
              //     builder: Builder(
              //     builder: (context) =>
              DateOnPress2(
                  date: datenow(),
                  context: context,
                  main: true,
                ); //,
          // ));
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return Scaffold(
            body: Center(
              child: Text(context.loc.while_we_can,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyle(
                      context: context,
                      fontSz: 16,
                      fontWght: Fontweight.w300,
                      colour: FontColour.black,
                      normalSpacing: true)),
            ),
          );
        }
      },
    );
  }
}

DateTime datenow() {
  final date = DateTime.now();
  return DateTime(date.year, date.month, date.day);
}

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
