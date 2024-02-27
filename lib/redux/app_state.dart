import 'package:equatable/equatable.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_state.dart';

class AppState extends Equatable {
  final AuthState authState;

  const AppState({
    required this.authState,
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthInitialState(),
    );
  }

  @override
  List<Object> get props => [authState];
}
