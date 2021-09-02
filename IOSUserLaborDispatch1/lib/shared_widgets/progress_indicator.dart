import 'package:flutter/material.dart';



Widget progressIndicator() {
  return Container(
    color: Colors.black.withOpacity(0.6),
    child: Center(
      child: SizedBox(
        width: 70,
        height: 70,
        child: Material(
          elevation: 15,
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    ),
  );
}

