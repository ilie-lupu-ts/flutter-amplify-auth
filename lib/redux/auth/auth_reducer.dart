import 'package:flutter_amplify_auth/redux/auth/auth_action.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_state.dart';

AuthState authReducer(AuthState state, dynamic action) {
  if (action is AuthLoadingEventAction) {
    return AuthLoadingState();
  } else if (action is AuthenticatedUserEventAction) {
    return AuthenticatedState(user: action.user);
  } else if (action is AuthErrorEventAction) {
    return AuthErrorState(errorType: action.errorType);
  } else if (action is SignInSuccessEventAction) {
    return AuthenticatedState(user: action.user);
  } else if (action is SignUpSuccessEventAction) {
    return AuthSignUpState(
      userId: action.userId,
      password: action.password,
      codeDeliveryDestination: action.codeDeliveryDestination,
    );
  } else if (action is SignUpConfirmLoadingEventAction && state is AuthSignUpState) {
    return AuthSignUpState(
      userId: action.userId,
      password: state.password,
      codeDeliveryDestination: action.codeDeliveryDestination,
      isLoading: true,
    );
  } else if (action is SignUpConfirmErrorEventAction && state is AuthSignUpState) {
    return AuthSignUpState(
      userId: action.userId,
      password: state.password,
      codeDeliveryDestination: action.codeDeliveryDestination,
      errorType: action.errorType,
    );
  } else if (action is SignedOutEventAction) {
    return AuthInitialState();
  }

  return state;
}
