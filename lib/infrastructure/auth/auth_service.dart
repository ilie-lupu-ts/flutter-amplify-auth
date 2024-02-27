import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:equatable/equatable.dart';

class AuthService {
  final AuthCategory amplifyAuth;

  AuthService({required this.amplifyAuth});

  Future<AuthServiceResponse> signIn({required String username, required String password}) async {
    try {
      final result = await amplifyAuth.signIn(
        username: username,
        password: password,
      );

      return SignInSuccessResponse(nextStep: result.nextStep);
    } catch (error) {
      return AuthServiceFailureResponse();
    }
  }

  Future<AuthServiceResponse> signOut() async {
    try {
      await amplifyAuth.signOut();

      return SignOutSuccessResponse();
    } catch (error) {
      return AuthServiceFailureResponse();
    }
  }
}

abstract class AuthServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInSuccessResponse extends AuthServiceResponse {
  final AuthNextSignInStep nextStep;

  SignInSuccessResponse({required this.nextStep});

  @override
  List<Object?> get props => [nextStep];
}

class SignOutSuccessResponse extends AuthServiceResponse {}

class AuthServiceFailureResponse extends AuthServiceResponse {}
