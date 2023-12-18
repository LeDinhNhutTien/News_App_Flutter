import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController controller; // Corrected spelling here
  final String hintText;
  final bool obscureText;

  const Input({
    super.key,
    required this.controller, // And here
    required this.hintText,
    this.obscureText = false, // Made `obscureText` not required with a default value of false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: controller, // Corrected spelling here
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}