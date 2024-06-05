import 'package:two_a/firebase/authentication/provider.dart';
import 'package:two_a/firebase/authentication/user.dart';

class Service implements Provider {
  final Provider provides;

  Service(this.provides);

  @override
  Future<AuthUser> createUser(
          {required String email, required String password}) =>
      provides.createUser(email: email, password: password);
  @override
  AuthUser? get currentUser => provides.currentUser;

  @override
  Future<void> initialize() => provides.initialize();

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provides.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provides.logOut();

  @override
  Future<void> sendEmailVerification() => provides.sendEmailVerification();

  @override
  Future<void> sendPassWordReset({required String email}) =>
      provides.sendPassWordReset(email: email);
}
