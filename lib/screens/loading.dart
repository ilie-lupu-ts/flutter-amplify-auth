import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/infrastructure/auth/auth_presenter.dart';
import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_action.dart';
import 'package:flutter_amplify_auth/screens/auth/sign_in.dart';
import 'package:flutter_amplify_auth/screens/home.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoadingPage extends StatelessWidget {
  static const String routeName = '/';

  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthViewModel>(
        onInit: (store) => store.dispatch(GetAuthenticatedUserCommandAction()),
        converter: (store) => AuthPresenter.present(authState: store.state.authState),
        distinct: true,
        onWillChange: (previousViewModel, newViewModel) {
          if (newViewModel is AuthenticatedViewModel) {
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          } else if (newViewModel is NotAuthenticatedViewModel) {
            Navigator.pushReplacementNamed(context, SignInPage.routeName);
          }
        },
        builder: (context, vm) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
