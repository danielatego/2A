import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:two_a/firebase/authentication/exceptions.dart';
import 'package:two_a/firebase/authentication/provider.dart';
import 'package:two_a/firebase/authentication/user.dart';
import 'package:two_a/firebase_options.dart';

class FireAuth implements Provider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotRegisteredInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
        name: 'bloc', options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await initialize();
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'user-disabled') {
        throw AccountDisabledAuthException();
      } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw WrongDetailsAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    //final usert = FirebaseAuth

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  Future<void> reauthenticateWithCredential(
      String email, String password) async {
    //final usert = FirebaseAuth

    final user = FirebaseAuth.instance.currentUser;
    var credential =
        EmailAuthProvider.credential(email: email, password: password);
    if (user != null) {
      await user.reauthenticateWithCredential(credential);
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  Future<void> delete(VoidCallback logout) async {
    //final usert = FirebaseAuth

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
      logout();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendPassWordReset({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'auth/user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
