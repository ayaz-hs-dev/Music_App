import 'package:flutter/material.dart';
import 'package:music_app/app/theme/style.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;

  /// 🔹 New property for validation
  final bool isValidated;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.isValidated = false,
  });

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  String? _errorText;

  bool _validateInput(String value) {
    // regex: at least 8 chars, one lowercase, one digit, one special char
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
    );
    return regex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: tabColor),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: backgroundColor,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword,
        keyboardType: widget.keyboardType,
        onChanged: (value) {
          if (widget.isValidated) {
            setState(() {
              if (value.isEmpty) {
                _errorText = null; // no error if nothing is typed yet
              } else if (!_validateInput(value)) {
                _errorText =
                    "Must be 8+ chars, include lowercase, number & special char";
              } else {
                _errorText = null;
              }
            });
          }
          if (widget.onChanged != null) widget.onChanged!(value);
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Colors.grey[700])
              : null,
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  onPressed: widget.onSuffixTap,
                  icon: Icon(widget.suffixIcon),
                  color: tabColor,
                )
              : null,
          errorText: _errorText, // ✅ shows error if validation fails
        ),
      ),
    );
  }
}
