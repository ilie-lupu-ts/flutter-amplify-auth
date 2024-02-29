import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/components/label.dart';
import 'package:flutter_amplify_auth/design/theme/default.dart';

enum AmplifyPasswordFieldSize { small, medium, large }

class AmplifyPasswordField extends StatefulWidget {
  final String? label;
  final String placeholder;
  final String? errorText;
  final AmplifyPasswordFieldSize size;
  final void Function(String)? onChanged;

  const AmplifyPasswordField({
    super.key,
    this.label,
    this.placeholder = "",
    this.onChanged,
    this.errorText,
    this.size = AmplifyPasswordFieldSize.medium,
  });

  @override
  State<AmplifyPasswordField> createState() => _AmplifyPasswordFieldState();
}

class _AmplifyPasswordFieldState extends State<AmplifyPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final height = _getHeight();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Label(
              text: widget.label!, variant: widget.errorText != null ? LabelVariant.error : LabelVariant.defaultLabel),
          const SizedBox(height: 8),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: lightThemeColors.border.primary,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: CupertinoTextField.borderless(
                  placeholder: widget.placeholder,
                  obscureText: _obscureText,
                  placeholderStyle: const TextStyle(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Container(
                  height: height,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: lightThemeColors.border.primary,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Icon(
                    _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: lightThemeColors.font.tertiary,
                    size: 24,
                  ),
                ),
              )
            ],
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.error_outline_outlined,
                color: lightThemeColors.font.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Label(
                  text: widget.errorText!,
                  variant: LabelVariant.error,
                ),
              ),
            ],
          )
        ],
      ],
    );
  }

  double _getHeight() {
    if (widget.size == AmplifyPasswordFieldSize.small) {
      return 33;
    } else if (widget.size == AmplifyPasswordFieldSize.large) {
      return 46;
    } else {
      return 40;
    }
  }
}
