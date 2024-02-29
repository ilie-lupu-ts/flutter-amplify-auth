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

    if (action is GetAuthenticatedUserCommandAction) {
      final response = await authService.getAuthenticatedUser();

      if (response is GetAuthenticatedUserSuccessResponse) {
        store.dispatch(GetAuthenticatedUserSuccessEventAction(user: response.user));
      } else if (response is AuthServiceErrorResponse) {
        store.dispatch(AuthErrorEventAction(errorType: response.errorType));
      }
    }

    if (action is SignInCommandAction) {
      store.dispatch(AuthLoadingEventAction());

      final response = await authService.signIn(
        username: action.username,
        password: action.password,
      );

      if (response is SignInSuccessResponse) {
        if (response.user != null) {
          store.dispatch(SignInSuccessEventAction(user: response.user!));
          return;
        }

        store.dispatch(SignInNextStepEventAction(nextStep: response.nextStep!));
      } else if (response is AuthServiceErrorResponse) {
        store.dispatch(AuthErrorEventAction(errorType: response.errorType));
      }
    }

    if (action is SignOutCommandAction) {
      store.dispatch(AuthLoadingEventAction());

      final response = await authService.signOut();
      if (response is SignOutSuccessResponse) {
        store.dispatch(SignedOutEventAction());
      } else if (response is AuthServiceErrorResponse) {
        store.dispatch(AuthErrorEventAction(errorType: response.errorType));
      }
    }
  }
}
