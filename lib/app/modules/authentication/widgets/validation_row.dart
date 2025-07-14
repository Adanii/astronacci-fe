import 'package:flutter/material.dart';

Widget buildValidationRow(String label, bool ok) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  child: Row(
    children: [
      CircleAvatar(
        radius: 12,
        backgroundColor: ok ? Colors.green : Colors.red,
        child: Icon(
          ok ? Icons.check : Icons.close,
          color: Colors.white,
          size: 16,
        ),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          color: ok ? Colors.black : Colors.grey, // disabled look
          fontSize: 14,
        ),
      ),
    ],
  ),
);
