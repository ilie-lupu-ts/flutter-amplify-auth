import 'package:equatable/equatable.dart';
import 'package:flutter_amplify_auth/models/auth/User.dart';
import 'package:flutter_amplify_auth/models/auth/error_type.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

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
