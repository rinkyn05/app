import 'package:flutter/material.dart';

class RegistrationInputDecorationWidget extends StatelessWidget {
  final String labelText;
  final String hintext;
  final IconData? icon;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? initialValue;

  const RegistrationInputDecorationWidget({
    super.key,
    required this.labelText,
    required this.hintext,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.controller,
    this.obscureText,
    this.onChanged,
    this.keyboardType,
    this.maxLines,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color borderColor = theme.brightness == Brightness.light
        ? Colors.grey[300]!
        : theme.colorScheme.secondary;
    final Color textColor = theme.textTheme.bodyLarge!.color!;
    final Color hintColor = textColor.withOpacity(0.3);
    final Color iconColor = theme.iconTheme.color!;
    final Color errorColor = theme.colorScheme.error;

    return TextFormField(
      controller: controller,
      style: theme.textTheme.bodyLarge,
      obscureText: obscureText ?? false,
      readOnly: false,
      autocorrect: true,
      onTap: onChanged != null ? () => onChanged!(controller!.text) : null,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintext,
        errorStyle: TextStyle(
          color: errorColor,
          fontFamily: theme.textTheme.bodyLarge!.fontFamily,
        ),
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: iconColor) : null,
        suffixIcon: suffixIcon,
        icon: icon != null ? Icon(icon, color: iconColor) : null,
        labelStyle: theme.textTheme.bodyLarge,
        hintStyle: TextStyle(
          color: hintColor,
          fontFamily: theme.textTheme.bodyLarge!.fontFamily,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }
}
