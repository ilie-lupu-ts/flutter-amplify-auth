import 'package:flutter_amplify_auth/infrastructure/auth/auth_service.dart';
import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_action.dart';
import 'package:redux/redux.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  final AuthService authService;

  AuthMiddleware({required this.authService});

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is SignInCommandAction) {
      final response = await authService.signIn(
        username: action.username,
        password: action.password,
      );
    }

    if (action is SignOutCommandAction) {
      final response = await authService.signOut();
    }
  }
}
