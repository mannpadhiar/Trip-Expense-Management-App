import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hint, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: Colors.black, size: 22),
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400),
    filled: true,
    fillColor: Colors.grey.shade50,
    contentPadding: EdgeInsets.all(17),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.black),
    ),
  );
}
