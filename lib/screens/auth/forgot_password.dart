import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/screens/auth/sign_in.dart';

class ForgotPasswordPage extends StatelessWidget {
  static const routeName = "/forgotPasswordPage";

  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, SignInPage.routeName);
              },
              child: const Text('To Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
