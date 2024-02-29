import 'package:flutter_amplify_auth/models/auth/User.dart';
import 'package:flutter_amplify_auth/models/auth/error_type.dart';

class AuthLoadingEventAction {}

class SignInCommandAction {
  final String username;
  final String password;

  SignInCommandAction({required this.username, required this.password});
}

class SignInSuccessEventAction {
  final User user;

  SignInSuccessEventAction({required this.user});
}

class SignUpCommandAction {
  final String email;
  final String password;

  SignUpCommandAction({required this.email, required this.password});
}

class SignUpSuccessEventAction {
  final String userId;
  final String password;
  final String codeDeliveryDestination;

  SignUpSuccessEventAction({required this.userId, required this.password, required this.codeDeliveryDestination});
}

class ConfirmSignUpCommandAction {
  final String confirmationCode;

  ConfirmSignUpCommandAction({required this.confirmationCode});
}

class SignUpConfirmLoadingEventAction {
  final String userId;
  final String codeDeliveryDestination;

  SignUpConfirmLoadingEventAction({required this.userId, required this.codeDeliveryDestination});
}

class SignUpConfirmErrorEventAction {
  final String userId;
  final String codeDeliveryDestination;
  final AuthErrorType errorType;

  SignUpConfirmErrorEventAction({required this.userId, required this.codeDeliveryDestination, required this.errorType});
}

class GetAuthenticatedUserCommandAction {}

class AuthenticatedUserEventAction {
  final User user;

  AuthenticatedUserEventAction({required this.user});
}

class SignOutCommandAction {}

class SignedOutEventAction {}

class AuthErrorEventAction {
  final AuthErrorType errorType;

  AuthErrorEventAction({required this.errorType});
}
