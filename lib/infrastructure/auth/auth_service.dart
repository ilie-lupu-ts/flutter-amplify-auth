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

      return SignInSuccessResponse(nextStep: signInResult.nextStep);
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

  AuthServiceResponse _processError(dynamic error) {
    if (error is UserNotFoundException || error is NotAuthorizedServiceException) {
      return AuthServiceErrorResponse(errorType: AuthErrorType.userNotFound);
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

class SignInSuccessResponse extends AuthServiceResponse {
  final User? user;
  final AuthNextSignInStep? nextStep;

  SignInSuccessResponse({this.user, this.nextStep});

  @override
  List<Object?> get props => [user, nextStep];
}

class SignOutSuccessResponse extends AuthServiceResponse {}

class AuthServiceErrorResponse extends AuthServiceResponse {
  final AuthErrorType errorType;

  AuthServiceErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}
