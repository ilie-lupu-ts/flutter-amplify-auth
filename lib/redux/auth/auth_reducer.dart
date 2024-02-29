import 'package:flutter_amplify_auth/redux/auth/auth_action.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_state.dart';

AuthState authReducer(AuthState state, dynamic action) {
  if (action is AuthLoadingEventAction) {
    return AuthLoadingState();
  } else if (action is GetAuthenticatedUserSuccessEventAction) {
    return AuthenticatedState(user: action.user);
  } else if (action is AuthErrorEventAction) {
    return AuthErrorState(errorType: action.errorType);
  } else if (action is SignInSuccessEventAction) {
    return AuthenticatedState(user: action.user);
  } else if (action is SignedOutEventAction) {
    return AuthInitialState();
  }

  return state;
}
