import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_amplify_auth/models/auth/User.dart';
import 'package:flutter_amplify_auth/models/auth/error_type.dart';

class AuthLoadingEventAction {}

class SignInCommandAction {
  final String username;
  final String password;

  SignInCommandAction({required this.username, required this.password});
}

class GetAuthenticatedUserCommandAction {}

class GetAuthenticatedUserSuccessEventAction {
  final User user;

  GetAuthenticatedUserSuccessEventAction({required this.user});
}

class SignOutCommandAction {}

class SignedOutEventAction {}

class SignInSuccessEventAction {
  final User user;

  SignInSuccessEventAction({required this.user});
}

class SignInNextStepEventAction {
  final AuthNextSignInStep nextStep;

  SignInNextStepEventAction({required this.nextStep});
}

class AuthErrorEventAction {
  final AuthErrorType errorType;

  AuthErrorEventAction({required this.errorType});
}
