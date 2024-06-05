import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_a/database/cloud/cloud_user.dart';
import 'package:two_a/database/cloud/firebase_cloud_storage.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/database/local/database_tables/online_userTable.dart';
import 'package:two_a/firebase/authentication/provider.dart';
import 'package:two_a/firebase/bloc/auth_state.dart';
import 'package:two_a/views/homepage_view.dart';

import 'auth_event.dart';

FirebaseCloudStorage cloudService = FirebaseCloudStorage();
LocalDatabaseService localService = LocalDatabaseService();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(Provider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    //initialize
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(
            isLoading: false,
          ));
        } else {
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      },
    );
    //register
    on<AuthEventShouldRegister>(
      (event, emit) async {
        emit(const AuthStateRegistering(
          exception: null,
          isLoading: false,
        ));
      },
    );
    //Register
    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email.trim();
        final password = event.password.trim();
        try {
          await provider.createUser(
            email: email,
            password: password,
          );
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(
            isLoading: false,
          ));
        } on Exception catch (e) {
          emit(AuthStateRegistering(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
    //Login
    on<AuthEventLogin>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
          ),
        );
        final email = event.email.trim();
        final password = event.password.trim();
        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );
          if (!user.isEmailVerified) {
            emit(const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ));
            emit(const AuthStateNeedsVerification(
              isLoading: false,
            ));
          } else {
            emit(const AuthStateLoggedOut(
              exception: null,
              isLoading: true,
            ));
            await localService.getorCreateUser(email: user.email, id: user.id);
            final CloudUser cloudUser = await cloudService.getOrCreateCloudUser(
                cloudUserid: user.id, cloudUserEmail: user.email);
            final OnlineUser onlineUser =
                await localService.getorCreateOnlineUser(
                    email: user.email,
                    id: user.id,
                    documentId: cloudUser.documentId);
            await localService.updateOnlineUser(
              onlineUser: onlineUser,
              homeContacts: cloudUser.homeContacts,
              profilePicture: cloudUser.profilePicture,
              workContacts: cloudUser.workContacts,
            );
            profilePicture(user.id);
            emit(AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
    //Send email verification
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );
    //Forgot password
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(
          const AuthStateForgotPassword(
            exception: null,
            hasSentEmail: false,
            isLoading: false,
          ),
        );
        final email = event.email;
        if (email == null) {
          return;
        }
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: true,
        ));
        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPassWordReset(email: email.trim());
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }
        emit(AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ));
      },
    );
    //Log out
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
  }
}
