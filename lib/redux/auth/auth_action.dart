import 'package:flutter_amplify_auth/models/auth/User.dart';
import 'package:flutter_amplify_auth/models/auth/error_type.dart';

class AuthLoadingEventAction {}

class GetAuthenticatedUserCommandAction {}

class SignOutCommandAction {}

class SignedOutEventAction {}

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
  final bool requestedNewConfirmationCode;

  SignUpConfirmLoadingEventAction({
    required this.userId,
    required this.codeDeliveryDestination,
    required this.requestedNewConfirmationCode,
  });
}

class SignUpConfirmErrorEventAction {
  final String userId;
  final String codeDeliveryDestination;
  final AuthErrorType errorType;

  SignUpConfirmErrorEventAction({required this.userId, required this.codeDeliveryDestination, required this.errorType});
}

class RequestSignUpConfirmationCodeCommandAction {
  final String username;

  RequestSignUpConfirmationCodeCommandAction({required this.username});
}

class RequestResetPasswordCommandAction {
  final String username;

  RequestResetPasswordCommandAction({required this.username});
}

class ResetPasswordSuccessEventAction {
  final String username;

  ResetPasswordSuccessEventAction({required this.username});
}

class ResetPasswordErrorEventAction {
  final String username;
  final AuthErrorType errorType;

  ResetPasswordErrorEventAction({
    required this.username,
    required this.errorType,
  });
}

class ConfirmResetPasswordCommandAction {
  final String confirmationCode;
  final String username;
  final String password;

  ConfirmResetPasswordCommandAction({
    required this.confirmationCode,
    required this.username,
    required this.password,
  });
}

class PasswordResetConfirmedEventAction {}

class AuthenticatedUserEventAction {
  final User user;

  AuthenticatedUserEventAction({required this.user});
}

class AuthErrorEventAction {
  final AuthErrorType errorType;

  AuthErrorEventAction({required this.errorType});
}
