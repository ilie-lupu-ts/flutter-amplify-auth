import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/components/alert.dart';
import 'package:flutter_amplify_auth/design/components/amplify_password_field.dart';
import 'package:flutter_amplify_auth/design/components/amplify_text_field.dart';
import 'package:flutter_amplify_auth/design/components/button.dart';
import 'package:flutter_amplify_auth/design/components/screen_scrollable_view.dart';
import 'package:flutter_amplify_auth/design/constants/spacings.dart';
import 'package:flutter_amplify_auth/design/constants/text_styles.dart';
import 'package:flutter_amplify_auth/infrastructure/auth/auth_presenter.dart';
import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_action.dart';
import 'package:flutter_amplify_auth/screens/auth/sign_in.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ConfirmResetPasswordPage extends StatefulWidget {
  static const routeName = "/confirmResetPasswordPage";

  const ConfirmResetPasswordPage({super.key});

  @override
  State<ConfirmResetPasswordPage> createState() => _ConfirmResetPasswordPageState();
}

class _ConfirmResetPasswordPageState extends State<ConfirmResetPasswordPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _canSubmit = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthViewModel>(
      converter: (store) => AuthPresenter.present(authState: store.state.authState),
      distinct: true,
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel is AuthInitialViewModel) {
          Navigator.pushReplacementNamed(context, SignInPage.routeName);
        }
      },
      builder: (context, viewModel) {
        return Scaffold(
          body: ScreenScrollableView(
            padding: const EdgeInsets.symmetric(horizontal: Spacings.screenHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/logo.svg'),
                const SizedBox(height: Spacings.x_10),
                Text("Reset password", style: TextStyles.heading4),
                const SizedBox(height: Spacings.x_2_5),
                Text("Time to reset your password. Ensure your account stays safe with a fresh password.",
                    style: TextStyles.small, textAlign: TextAlign.center),
                const SizedBox(height: Spacings.x_10),
                if (viewModel is ResetPasswordViewModel && viewModel.errorType != null) ...[
                  Alert(variant: AlertVariant.error, message: viewModel.errorMessage),
                  const SizedBox(height: Spacings.x_10),
                ],
                FormBuilder(
                  key: _formKey,
                  onChanged: _onFormChanged,
                  child: Column(
                    children: [
                      FormBuilderField<String>(
                        name: 'confirmationCode',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        builder: (FormFieldState field) {
                          return AmplifyTextField(
                            errorText: field.errorText,
                            onChanged: (value) => field.didChange(value),
                            label: "Confirmation code",
                            placeholder: "Enter your code",
                          );
                        },
                      ),
                      const SizedBox(height: Spacings.x_4),
                      FormBuilderField<String>(
                        name: 'password',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: "",
                        onChanged: (_) => _validateConfirmPassword(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(8, errorText: "Password must be at least 8 characters"),
                        ]),
                        builder: (FormFieldState field) {
                          return AmplifyPasswordField(
                            errorText: field.errorText,
                            onChanged: (value) => field.didChange(value),
                            label: "Password",
                            placeholder: "Enter your password",
                          );
                        },
                      ),
                      const SizedBox(height: Spacings.x_4),
                      FormBuilderField<String>(
                        name: 'password_confirm',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: "",
                        onChanged: (_) => _validateConfirmPassword(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(8, errorText: "Password must be at least 8 characters"),
                        ]),
                        builder: (FormFieldState field) {
                          return AmplifyPasswordField(
                            errorText: field.errorText,
                            onChanged: (value) => field.didChange(value),
                            label: "Confirm password",
                            placeholder: "Enter your password",
                          );
                        },
                      ),
                      const SizedBox(height: Spacings.x_10),
                      ListenableBuilder(
                        listenable: _canSubmit,
                        builder: (context, child) => Button(
                          loading: viewModel is AuthLoadingViewModel,
                          onPressed: _canSubmit.value
                              ? () {
                                  if (viewModel is! ResetPasswordViewModel) {
                                    return;
                                  }

                                  final username = viewModel.username;
                                  final confirmationCode = _formKey.currentState?.fields['confirmationCode']?.value;
                                  final password = _formKey.currentState?.fields['password']?.value;

                                  StoreProvider.of<AppState>(context).dispatch(ConfirmResetPasswordCommandAction(
                                    username: username,
                                    password: password,
                                    confirmationCode: confirmationCode,
                                  ));
                                }
                              : null,
                          text: "Confirm",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onFormChanged() {
    final isValid = _formKey.currentState?.isValid ?? false;
    _canSubmit.value = isValid;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final isValid = _formKey.currentState?.isValid ?? false;
      _canSubmit.value = isValid;
    });
  }

  void _validateConfirmPassword() {
    final password = _formKey.currentState?.fields['password']?.value as String?;
    final confirmPassword = _formKey.currentState?.fields['password_confirm']?.value as String?;

    if (confirmPassword == null || confirmPassword.isEmpty) {
      return;
    }

    if (password == confirmPassword) {
      _formKey.currentState?.fields['password_confirm']?.validate(clearCustomError: true);
      return;
    }

    _formKey.currentState?.fields['password_confirm']?.invalidate("Passwords do not match", shouldFocus: false);
  }
}
