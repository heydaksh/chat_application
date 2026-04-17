import 'package:chat_application/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TextfieldAuth extends StatefulWidget {
  const TextfieldAuth({
    super.key,
    this.keyboardType,
    this.icon,
    this.labelText,
    this.controller,
    this.validator,
    this.obscureText,
    this.borderColor,
    this.labelColor,
    this.textColor,
    this.maxLength,
    this.maxLines,
    this.lableTextSize,
    this.cursorColor,
    this.suffixIcon,
  });

  final TextInputType? keyboardType;
  final IconData? icon;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final Color? borderColor;
  final Color? labelColor;
  final Color? textColor;
  final int? maxLength;
  final int? maxLines;
  final double? lableTextSize;
  final Color? cursorColor;
  final IconData? suffixIcon;

  @override
  State<TextfieldAuth> createState() => _TextfieldAuthState();
}

class _TextfieldAuthState extends State<TextfieldAuth> {
  late bool isObscure;

  @override
  void initState() {
    super.initState();
    isObscure = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.maxLength,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: isObscure,
      cursorColor: widget.cursorColor ?? Colors.white,
      keyboardType: widget.keyboardType,
      style: TextStyle(color: widget.textColor ?? Colors.white),
      decoration: InputDecoration(
        counterText: '',
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: widget.labelColor ?? Colors.white,
          fontSize: widget.lableTextSize ?? 16,
        ),

        /// PREFIX ICON
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: widget.labelColor ?? Colors.white)
            : null,

        ///  OBSCURE TOGGLE BUTTON
        suffixIcon: widget.obscureText == true
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              )
            : (widget.suffixIcon != null
                  ? Icon(
                      widget.suffixIcon,
                      color: widget.labelColor ?? Colors.white,
                    )
                  : null),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70, width: 2),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
      ),
    );
  }
}
