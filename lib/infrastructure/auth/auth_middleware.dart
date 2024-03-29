import 'package:flutter_amplify_auth/infrastructure/auth/auth_service.dart';
import 'package:flutter_amplify_auth/models/auth/error_type.dart';
import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_action.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_state.dart';
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
        store.dispatch(AuthenticatedUserEventAction(user: response.user));
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
        store.dispatch(SignInSuccessEventAction(user: response.user));
        return;
      }

      if (response is AuthServiceErrorResponse && response.errorType != AuthErrorType.userNotConfirmed) {
        store.dispatch(AuthErrorEventAction(errorType: response.errorType));
        return;
      }

      if (response is AuthServiceErrorResponse && response.errorType == AuthErrorType.userNotConfirmed) {
        final confirmationCodeResponse = await authService.sendSignUpCode(username: action.username);

        if (confirmationCodeResponse is SendSignUpCodeSuccessResponse) {
          store.dispatch(SignUpSuccessEventAction(
            userId: action.username,
            password: action.password,
            codeDeliveryDestination: confirmationCodeResponse.codeDeliveryDestination,
          ));
        } else if (confirmationCodeResponse is AuthServiceErrorResponse) {
          store.dispatch(AuthErrorEventAction(errorType: confirmationCodeResponse.errorType));
        }
      }
    }

    if (action is SignUpCommandAction) {
      store.dispatch(AuthLoadingEventAction());

      final response = await authService.signUp(email: action.email, password: action.password);

      if (response is SignUpSuccessResponse) {
        store.dispatch(SignUpSuccessEventAction(
          userId: response.userId,
          password: action.password,
          codeDeliveryDestination: response.codeDeliveryDestination,
        ));
      } else if (response is AuthServiceErrorResponse) {
        store.dispatch(AuthErrorEventAction(errorType: response.errorType));
      }
    }

    if (action is ConfirmSignUpCommandAction) {
      if (store.state.authState is! AuthSignUpState) {
        store.dispatch(AuthErrorEventAction(errorType: AuthErrorType.unknown));
        return;
      }

      final state = store.state.authState as AuthSignUpState;

      store.dispatch(SignUpConfirmLoadingEventAction(
        userId: state.userId,
        codeDeliveryDestination: state.codeDeliveryDestination,
        requestedNewConfirmationCode: false,
      ));

      final response = await authService.confirmSignUp(
        username: state.userId,
        confirmationCode: action.confirmationCode,
      );

      if (response is SignUpConfirmSuccessResponse) {
        final signIn = await authService.signIn(
          username: state.userId,
          password: state.password,
        );

        if (signIn is SignInSuccessResponse) {
          store.dispatch(SignInSuccessEventAction(user: signIn.user));
          return;
        } else if (signIn is AuthServiceErrorResponse) {
          store.dispatch(SignUpConfirmErrorEventAction(
            userId: state.userId,
            codeDeliveryDestination: state.codeDeliveryDestination,
            errorType: signIn.errorType,
          ));
        }
      } else if (response is AuthServiceErrorResponse) {
        store.dispatch(SignUpConfirmErrorEventAction(
          userId: state.userId,
          codeDeliveryDestination: state.codeDeliveryDestination,
          errorType: response.errorType,
        ));
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

    if (action is RequestSignUpConfirmationCodeCommandAction) {
      if (store.state.authState is! AuthSignUpState) {
        store.dispatch(AuthErrorEventAction(errorType: AuthErrorType.unknown));
        return;
      }

      final state = store.state.authState as AuthSignUpState;
      store.dispatch(SignUpConfirmLoadingEventAction(
        userId: state.userId,
        codeDeliveryDestination: state.codeDeliveryDestination,
        requestedNewConfirmationCode: true,
      ));

      final response = await authService.sendSignUpCode(username: action.username);

      if (response is SendSignUpCodeSuccessResponse) {
        store.dispatch(SignUpSuccessEventAction(
          userId: action.username,
          password: state.password,
          codeDeliveryDestination: response.codeDeliveryDestination,
        ));
      } else if (response is AuthServiceErrorResponse) {
        store.dispatch(AuthErrorEventAction(errorType: response.errorType));
      }
    }

    if (action is RequestResetPasswordCommandAction) {
      store.dispatch(AuthLoadingEventAction());

      final response = await authService.resetPassword(username: action.username);

      if (response is ResetPasswordSuccessResponse) {
        store.dispatch(ResetPasswordSuccessEventAction(
          username: response.username,
        ));
      } else if (response is AuthServiceErrorResponse) {
        store.dispatch(AuthErrorEventAction(errorType: response.errorType));
      }
    }

    if (action is ConfirmResetPasswordCommandAction) {
      store.dispatch(AuthLoadingEventAction());

      final response = await authService.confirmResetPassword(
        username: action.username,
        newPassword: action.password,
        confirmationCode: action.confirmationCode,
      );

      if (response is ConfirmPasswordResetSuccessResponse) {
        store.dispatch(PasswordResetConfirmedEventAction());
      } else if (response is AuthServiceErrorResponse) {
        store.dispatch(ResetPasswordErrorEventAction(
          username: action.username,
          errorType: response.errorType,
        ));
      }
    }
  }
}
