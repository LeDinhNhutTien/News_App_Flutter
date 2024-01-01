import 'package:flutter/material.dart';

class MyButtonEdit extends StatelessWidget {
  final VoidCallback? onTap;

  const MyButtonEdit({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(10),
        /*margin*/
        margin: const EdgeInsets.symmetric(horizontal:10),
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Cập nhập",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}