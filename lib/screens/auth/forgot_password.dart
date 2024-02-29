import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/components/alert.dart';
import 'package:flutter_amplify_auth/design/components/amplify_text_field.dart';
import 'package:flutter_amplify_auth/design/components/button.dart';
import 'package:flutter_amplify_auth/design/components/screen_scrollable_view.dart';
import 'package:flutter_amplify_auth/design/constants/spacings.dart';
import 'package:flutter_amplify_auth/design/constants/text_styles.dart';
import 'package:flutter_amplify_auth/infrastructure/auth/auth_presenter.dart';
import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_action.dart';
import 'package:flutter_amplify_auth/screens/auth/confirm_forgot_password.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = "/forgotPasswordPage";

  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _canSubmit = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthViewModel>(
      converter: (store) => AuthPresenter.present(authState: store.state.authState),
      distinct: true,
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel is ResetPasswordViewModel) {
          Navigator.pushReplacementNamed(context, ConfirmResetPasswordPage.routeName);
        }
      },
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(),
          body: ScreenScrollableView(
            padding: const EdgeInsets.symmetric(horizontal: Spacings.screenHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/logo.svg'),
                const SizedBox(height: Spacings.x_10),
                Text("Forgot your password?", style: TextStyles.heading4),
                const SizedBox(height: Spacings.x_2_5),
                Text("Oh no! It happens to the best of us.", style: TextStyles.small),
                const SizedBox(height: Spacings.x_10),
                if (viewModel is AuthErrorViewModel) ...[
                  Alert(variant: AlertVariant.error, message: viewModel.message),
                  const SizedBox(height: Spacings.x_10),
                ],
                FormBuilder(
                  key: _formKey,
                  onChanged: _onFormChanged,
                  child: Column(
                    children: [
                      FormBuilderField<String>(
                        name: 'email',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                        builder: (FormFieldState field) {
                          return AmplifyTextField(
                            errorText: field.errorText,
                            onChanged: (value) => field.didChange(value),
                            label: "Email",
                            placeholder: "Enter your email address",
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
                                  final email = _formKey.currentState?.fields['email']?.value;

                                  StoreProvider.of<AppState>(context).dispatch(
                                    RequestResetPasswordCommandAction(username: email),
                                  );
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
}
