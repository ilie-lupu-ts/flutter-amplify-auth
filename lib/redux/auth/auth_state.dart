import 'package:equatable/equatable.dart';
import 'package:flutter_amplify_auth/models/auth/User.dart';
import 'package:flutter_amplify_auth/models/auth/error_type.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSignUpState extends AuthState {
  final String userId;
  final String password;
  final String codeDeliveryDestination;
  final bool isLoading;
  final AuthErrorType? errorType;

  AuthSignUpState({
    required this.userId,
    required this.password,
    required this.codeDeliveryDestination,
    this.isLoading = false,
    this.errorType,
  });

  @override
  List<Object> get props => [userId, password, codeDeliveryDestination, isLoading];
}

class AuthenticatedState extends AuthState {
  final User user;

  AuthenticatedState({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthErrorState extends AuthState {
  final AuthErrorType errorType;

  AuthErrorState({required this.errorType});

  @override
  List<Object> get props => [errorType];
}
