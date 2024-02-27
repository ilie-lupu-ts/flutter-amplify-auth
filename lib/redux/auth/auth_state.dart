import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {}
