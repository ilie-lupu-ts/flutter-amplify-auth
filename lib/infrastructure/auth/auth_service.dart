import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_amplify_auth/models/auth/User.dart';
import 'package:flutter_amplify_auth/models/auth/error_type.dart';

class AuthService {
  final AuthCategory amplifyAuth;

  AuthService({required this.amplifyAuth});

  Future<AuthServiceResponse> getAuthenticatedUser() async {
    try {
      final session = await amplifyAuth.fetchAuthSession();

      if (session is CognitoAuthSession && session.isSignedIn) {
        final userId = session.userSubResult.value;
        final user = User(id: userId);

        return GetAuthenticatedUserSuccessResponse(user: user);
      }

      return AuthServiceErrorResponse(errorType: AuthErrorType.notSignedIn);
    } catch (error) {
      return AuthServiceErrorResponse(errorType: AuthErrorType.notSignedIn);
    }
  }

  Future<AuthServiceResponse> signUp({required String email, required String password}) async {
    try {
      final signUpResult = await amplifyAuth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: email,
          },
        ),
      );

      if (signUpResult.nextStep.signUpStep == AuthSignUpStep.confirmSignUp) {
        final userId = signUpResult.userId ?? "";
        final codeDeliveryAddress = signUpResult.nextStep.codeDeliveryDetails?.destination ?? "";

        return SignUpSuccessResponse(userId: userId, codeDeliveryDestination: codeDeliveryAddress);
      }

      return AuthServiceErrorResponse(errorType: AuthErrorType.unknown);
    } catch (error) {
      return _processError(error);
    }
  }

  Future<AuthServiceResponse> confirmSignUp({required String username, required String confirmationCode}) async {
    try {
      final confirmSignUpResult = await amplifyAuth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode,
      );

      if (confirmSignUpResult.nextStep.signUpStep == AuthSignUpStep.done && confirmSignUpResult.isSignUpComplete) {
        return SignUpConfirmSuccessResponse(userId: username);
      }

      return AuthServiceErrorResponse(errorType: AuthErrorType.unknown);
    } catch (error) {
      return _processError(error);
    }
  }

  Future<AuthServiceResponse> signIn({required String username, required String password}) async {
    try {
      final signInResult = await amplifyAuth.signIn(
        username: username,
        password: password,
      );

      if (signInResult.nextStep.signInStep == AuthSignInStep.done) {
        final userDetails = await amplifyAuth.getCurrentUser();
        final user = User(id: userDetails.userId);

        return SignInSuccessResponse(user: user);
      }

      return AuthServiceErrorResponse(errorType: AuthErrorType.userNotConfirmed);
    } catch (error) {
      return _processError(error);
    }
  }

  Future<AuthServiceResponse> signOut() async {
    try {
      await amplifyAuth.signOut();

      return SignOutSuccessResponse();
    } catch (error) {
      return AuthServiceErrorResponse(errorType: AuthErrorType.unknown);
    }
  }

  Future<AuthServiceResponse> sendSignUpCode({required String username}) async {
    try {
      final response = await amplifyAuth.resendSignUpCode(username: username);
      final codeDeliveryDestination = response.codeDeliveryDetails.destination ?? "";

      return SendSignUpCodeSuccessResponse(codeDeliveryDestination: codeDeliveryDestination);
    } catch (error) {
      return _processError(error);
    }
  }

  Future<AuthServiceResponse> resetPassword({required String username}) async {
    try {
      final response = await amplifyAuth.resetPassword(username: username);

      if (response.nextStep.updateStep == AuthResetPasswordStep.confirmResetPasswordWithCode) {
        final codeDeliveryDestination = response.nextStep.codeDeliveryDetails?.destination ?? "";

        return ResetPasswordSuccessResponse(username: username, codeDeliveryDestination: codeDeliveryDestination);
      }

      return AuthServiceErrorResponse(errorType: AuthErrorType.unknown);
    } catch (error) {
      return _processError(error);
    }
  }

  Future<AuthServiceResponse> confirmResetPassword({
    required String username,
    required String confirmationCode,
    required String newPassword,
  }) async {
    try {
      await amplifyAuth.confirmResetPassword(
        username: username,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );

      return ConfirmPasswordResetSuccessResponse();
    } catch (error) {
      return _processError(error);
    }
  }

  AuthServiceResponse _processError(dynamic error) {
    if (error is UserNotFoundException) {
      return AuthServiceErrorResponse(errorType: AuthErrorType.userNotFound);
    } else if (error is NotAuthorizedServiceException) {
      return AuthServiceErrorResponse(errorType: AuthErrorType.notSignedIn);
    } else if (error is UsernameExistsException) {
      return AuthServiceErrorResponse(errorType: AuthErrorType.usernameExists);
    } else if (error is CodeMismatchException) {
      return AuthServiceErrorResponse(errorType: AuthErrorType.wrongConfirmationCode);
    } else if (error is LimitExceededException) {
      return AuthServiceErrorResponse(errorType: AuthErrorType.tryAgainLater);
    }

    return AuthServiceErrorResponse(errorType: AuthErrorType.unknown);
  }
}

abstract class AuthServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAuthenticatedUserSuccessResponse extends AuthServiceResponse {
  final User user;

  GetAuthenticatedUserSuccessResponse({required this.user});

  @override
  List<Object?> get props => [user];
}

class SignUpSuccessResponse extends AuthServiceResponse {
  final String userId;
  final String codeDeliveryDestination;

  SignUpSuccessResponse({required this.userId, required this.codeDeliveryDestination});

  @override
  List<Object?> get props => [userId, codeDeliveryDestination];
}

class SignInSuccessResponse extends AuthServiceResponse {
  final User user;

  SignInSuccessResponse({required this.user});

  @override
  List<Object?> get props => [user];
}

class SignUpConfirmSuccessResponse extends AuthServiceResponse {
  final String userId;

  SignUpConfirmSuccessResponse({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class SendSignUpCodeSuccessResponse extends AuthServiceResponse {
  final String codeDeliveryDestination;

  SendSignUpCodeSuccessResponse({required this.codeDeliveryDestination});

  @override
  List<Object?> get props => [codeDeliveryDestination];
}

class SignOutSuccessResponse extends AuthServiceResponse {}

class AuthServiceErrorResponse extends AuthServiceResponse {
  final AuthErrorType errorType;

  AuthServiceErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}

class ResetPasswordSuccessResponse extends AuthServiceResponse {
  final String username;
  final String codeDeliveryDestination;

  ResetPasswordSuccessResponse({required this.username, required this.codeDeliveryDestination});

  @override
  List<Object?> get props => [username, codeDeliveryDestination];
}

class ConfirmPasswordResetSuccessResponse extends AuthServiceResponse {}
