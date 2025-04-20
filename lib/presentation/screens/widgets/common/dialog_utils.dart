import 'package:flutter/material.dart';

///We can add methods and other properties in this class that are required for showing a dialog box.

class DialogUtils {
  static void showDialogBox(
    BuildContext context, {
    required Widget dialogWidget,
  }) {
    showDialog(context: context, builder: (context) => dialogWidget);
  }
}
