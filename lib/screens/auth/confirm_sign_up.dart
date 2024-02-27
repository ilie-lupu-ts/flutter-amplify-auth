import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';

class ConfirmSignUpPage extends StatefulWidget {
  final AuthenticatorState authenticatorState;

  const ConfirmSignUpPage({
    super.key,
    required this.authenticatorState,
  });

  @override
  State<ConfirmSignUpPage> createState() => _ConfirmSignUpPageState();
}

class _ConfirmSignUpPageState extends State<ConfirmSignUpPage> {
  final TextEditingController _confirmationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Sign Up'),
      ),
      body: Center(
        child: Form(
          key: widget.authenticatorState.formKey,
          child: Column(
            children: [
              TextField(
                controller: _confirmationCodeController,
                onChanged: (value) => widget.authenticatorState.confirmationCode = value,
                decoration: const InputDecoration(
                  labelText: 'Confirmation Code',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await widget.authenticatorState.confirmSignUp();
                },
                child: const Text('Confirm Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
