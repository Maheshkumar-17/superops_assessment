import 'package:flutter/material.dart';
import 'package:superops_assessment/presentation/colors/color_constants.dart';
import 'package:superops_assessment/presentation/styles/custom_text_styles.dart';

///This widget is to show any unexpected error alert and to do action.

class AlertBoxWidget extends StatelessWidget {
  final String alertTitle;
  final String alertMessage;
  final String actionName;
  final VoidCallback onAction;
  const AlertBoxWidget({
    super.key,
    required this.alertTitle,
    required this.alertMessage,
    required this.actionName,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorConstants.kLightGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(alertTitle, style: custom16w800),
      content: Text(alertMessage, style: custom14w800),
      actions: <Widget>[
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: ColorConstants.kIOSRed, width: 2),
          ),
          onPressed: onAction,
          child: Text(
            actionName,
            style: custom14w800.copyWith(color: ColorConstants.kIOSRed),
          ),
        ),
      ],
    );
  }
}
