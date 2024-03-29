import 'package:equatable/equatable.dart';
import 'package:flutter_amplify_auth/models/auth/User.dart';
import 'package:flutter_amplify_auth/models/auth/error_type.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_state.dart';

class AuthPresenter {
  static AuthViewModel present({required AuthState authState}) {
    if (authState is AuthenticatedState) {
      return AuthenticatedViewModel(user: authState.user);
    } else if (authState is AuthSignUpState) {
      return SignUpViewModel(
        userId: authState.userId,
        codeDeliveryDestination: authState.codeDeliveryDestination,
        isLoading: authState.isLoading,
        isRequestingConfirmationCode: authState.isRequestingConfirmationCode,
        errorType: authState.errorType,
      );
    } else if (authState is AuthResetPasswordState) {
      return ResetPasswordViewModel(
        username: authState.username,
        isLoading: authState.isLoading,
        errorType: authState.errorType,
      );
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

  String get message => _mapErrorTypeToMessage(errorType);

  @override
  List<Object?> get props => [errorType];
}

class AuthenticatedViewModel extends AuthViewModel {
  final User user;

  AuthenticatedViewModel({required this.user});

  @override
  List<Object?> get props => [];
}

class SignUpViewModel extends AuthViewModel {
  final String userId;
  final String codeDeliveryDestination;
  final bool isLoading;
  final bool isRequestingConfirmationCode;
  final AuthErrorType? errorType;

  SignUpViewModel({
    required this.userId,
    required this.codeDeliveryDestination,
    required this.isLoading,
    required this.isRequestingConfirmationCode,
    this.errorType,
  });

  String get errorMessage => errorType != null ? _mapErrorTypeToMessage(errorType!) : "";

  bool get canRequestNewCode => !isRequestingConfirmationCode && !isLoading;

  @override
  List<Object?> get props => [userId, codeDeliveryDestination, isLoading, errorType, isRequestingConfirmationCode];
}

class ResetPasswordViewModel extends AuthViewModel {
  final String username;
  final bool isLoading;
  final AuthErrorType? errorType;

  ResetPasswordViewModel({
    required this.username,
    required this.isLoading,
    this.errorType,
  });

  String get errorMessage => _mapErrorTypeToMessage(errorType!);

  @override
  List<Object?> get props => [username, isLoading, errorType];
}

String _mapErrorTypeToMessage(AuthErrorType? errorType) {
  if (errorType == AuthErrorType.userNotFound) {
    return "This email address is not associated with any account";
  } else if (errorType == AuthErrorType.usernameExists) {
    return "This email address is already in use";
  } else if (errorType == AuthErrorType.wrongConfirmationCode) {
    return "The code you entered is incorrect";
  } else if (errorType == AuthErrorType.tryAgainLater) {
    return "An error has occurred. Please try again later";
  }

  return "An error has occurred";
}
