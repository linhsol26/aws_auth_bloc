import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:aws_auth_bloc/models/user.dart';

class ApiProvider {
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final awsUser = await Amplify.Auth.getCurrentUser();
      return User(name: awsUser.username, email: awsUser.userId);
    } catch (e) {
      return User(name: '', email: '');
    }
  }

  Future<void> signUpWithEmailPassword(String email, String password) async {
    try {
      final CognitoSignUpOptions options =
          CognitoSignUpOptions(userAttributes: {'email': email});
      await Amplify.Auth.signUp(
          username: 'nhglinh263@gmail.com',
          password: password,
          options: options);
    } on Exception {
      rethrow;
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      await Amplify.Auth.signIn(username: email, password: password);
    } on Exception {
      rethrow;
    }
  }
}
