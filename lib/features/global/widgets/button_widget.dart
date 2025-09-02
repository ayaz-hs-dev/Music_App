import 'package:flutter/material.dart';
import 'package:music_app/app/theme/style.dart';

Widget buttonWidget({String? buttonName, VoidCallback? onPressed}) {
  return SizedBox(
    width: 175,
    height: 60,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return greyColor;
          return tabColor;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      child: Text(
        "$buttonName",
        style: TextStyle(fontSize: 17, color: whiteColor),
      ),
    ),
  );
}
