import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/components/alert.dart';
import 'package:flutter_amplify_auth/design/components/amplify_text_field.dart';
import 'package:flutter_amplify_auth/design/components/button.dart';
import 'package:flutter_amplify_auth/design/components/screen_scrollable_view.dart';
import 'package:flutter_amplify_auth/design/constants/spacings.dart';
import 'package:flutter_amplify_auth/design/constants/text_styles.dart';
import 'package:flutter_amplify_auth/design/theme/app_theme.dart';
import 'package:flutter_amplify_auth/infrastructure/auth/auth_presenter.dart';
import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_action.dart';
import 'package:flutter_amplify_auth/screens/home.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ConfirmSignUpPage extends StatefulWidget {
  static const String routeName = '/confirmSignUpPage';

  const ConfirmSignUpPage({super.key});

  @override
  State<ConfirmSignUpPage> createState() => _ConfirmSignUpPageState();
}

class _ConfirmSignUpPageState extends State<ConfirmSignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _canSubmit = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthViewModel>(
      converter: (store) => AuthPresenter.present(authState: store.state.authState),
      distinct: true,
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel is AuthenticatedViewModel) {
          Navigator.pushReplacementNamed(context, HomePage.routeName);
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
                Text("Confirm your email", style: TextStyles.heading4),
                const SizedBox(height: Spacings.x_2_5),
                if (viewModel is SignUpConfirmViewModel)
                  Text(
                    "Your code is on the way. To log in, enter the code we emailed you to ${viewModel.codeDeliveryDestination}. It may take a minute to arrive.",
                    style: TextStyles.small,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: Spacings.x_10),
                if (viewModel is SignUpConfirmViewModel && viewModel.errorType != null) ...[
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: viewModel is SignUpConfirmViewModel && !viewModel.isRequestingConfirmationCode
                                ? () {
                                    StoreProvider.of<AppState>(context).dispatch(
                                      RequestSignUpConfirmationCodeCommandAction(username: viewModel.userId),
                                    );
                                  }
                                : null,
                            child: Text(
                              "Request a new code",
                              style: TextStyles.link.copyWith(
                                  color: viewModel is SignUpConfirmViewModel && viewModel.canRequestNewCode
                                      ? AppTheme.getColors().font.interactive
                                      : AppTheme.getColors().font.disabled),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacings.x_10),
                      ListenableBuilder(
                        listenable: _canSubmit,
                        builder: (context, child) => Button(
                          loading: viewModel is SignUpConfirmViewModel && viewModel.isLoading,
                          onPressed: _canSubmit.value
                              ? () {
                                  final confirmationCode = _formKey.currentState?.fields['confirmationCode']?.value;

                                  StoreProvider.of<AppState>(context).dispatch(
                                    ConfirmSignUpCommandAction(confirmationCode: confirmationCode),
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
