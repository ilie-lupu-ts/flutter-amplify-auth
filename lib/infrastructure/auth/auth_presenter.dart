import 'package:equatable/equatable.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_state.dart';

class AuthPresenter {
  static AuthViewModel present({required AuthState authState}) {
    return AuthInitialViewModel();
  }
}

abstract class AuthViewModel extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialViewModel extends AuthViewModel {}

class SignInLoadingViewModel extends AuthViewModel {}

class AuthenticatedViewModel extends AuthViewModel {}
