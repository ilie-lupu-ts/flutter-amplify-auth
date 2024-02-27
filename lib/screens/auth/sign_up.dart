import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final AuthenticatorState authenticatorState;

  const SignUpPage({super.key, required this.authenticatorState});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: widget.authenticatorState.formKey,
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    onChanged: (value) => widget.authenticatorState.username = value,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    onChanged: (value) => widget.authenticatorState.password = value,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    onChanged: (value) => widget.authenticatorState.passwordConfirmation = value,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        print(widget.authenticatorState.username);
                        await widget.authenticatorState.signUp();
                      } catch (error) {
                        print("Error signing up: $error");
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.authenticatorState.changeStep(AuthenticatorStep.signIn);
                    },
                    child: const Text('To sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    try {
      final username = _emailController.text;
      final result = await Amplify.Auth.signUp(
        username: username,
        password: _passwordController.text,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: _emailController.text,
          },
        ),
      );
      if (result.nextStep.signUpStep == AuthSignUpStep.confirmSignUp) {
        widget.authenticatorState.username = username;
        widget.authenticatorState.changeStep(AuthenticatorStep.confirmSignUp);
      }
    } catch (error) {
      print("Login error: $error");
    }
  }
}
