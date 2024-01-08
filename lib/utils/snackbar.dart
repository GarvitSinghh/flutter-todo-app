// Helper function to show Snackbar

import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, {bool fromModal = false}) {
  SnackBar snackbar = SnackBar(
    showCloseIcon: true,
    dismissDirection: DismissDirection.horizontal,
    content: SizedBox(
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    backgroundColor: const Color(0xff2c2f33),
    margin: EdgeInsets.only(
      bottom: fromModal ? MediaQuery.of(context).size.height - 200 : MediaQuery.of(context).size.height - 100,
      right: 20,
      left: 20,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
