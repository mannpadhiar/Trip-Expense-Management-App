import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hint, IconData icon) {
  return InputDecoration(
    prefixIcon: Container(
      margin: EdgeInsets.only(left: 12, right: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.black, size: 20),
    ),
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
