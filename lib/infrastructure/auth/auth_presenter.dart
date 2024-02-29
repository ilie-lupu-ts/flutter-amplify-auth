import 'package:equatable/equatable.dart';
import 'package:flutter_amplify_auth/models/auth/User.dart';
import 'package:flutter_amplify_auth/models/auth/error_type.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_state.dart';

class AuthPresenter {
  static AuthViewModel present({required AuthState authState}) {
    if (authState is AuthenticatedState) {
      return AuthenticatedViewModel(user: authState.user);
    } else if (authState is AuthLoadingState) {
      return AuthLoadingViewModel();
    } else if (authState is AuthErrorState) {
      if (authState.errorType == AuthErrorType.notSignedIn) {
        return NotAuthenticatedViewModel();
      }

      return AuthErrorViewModel(errorType: authState.errorType);
    }

    return AuthInitialViewModel();
  }
}

abstract class AuthViewModel extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialViewModel extends AuthViewModel {}

class AuthLoadingViewModel extends AuthViewModel {}

class NotAuthenticatedViewModel extends AuthViewModel {}

class AuthErrorViewModel extends AuthViewModel {
  final AuthErrorType errorType;

  AuthErrorViewModel({required this.errorType});

  String get message {
    if (errorType == AuthErrorType.userNotFound) {
      return "This email address is not associated with any account";
    }

    return "An error occurred";
  }

  @override
  List<Object?> get props => [errorType];
}

class AuthenticatedViewModel extends AuthViewModel {
  final User user;

  AuthenticatedViewModel({required this.user});

  @override
  List<Object?> get props => [];
}
