import 'package:flutter/material.dart';
import 'package:superops_assessment/data/network/endpoints.dart';
import 'package:superops_assessment/presentation/colors/color_constants.dart';
import 'package:superops_assessment/presentation/strings/app_strings.dart';
import 'package:superops_assessment/presentation/styles/custom_text_styles.dart';

///Placing this widget in common folder because if any screen needs this, we can reuse it.

class RetryWidget extends StatelessWidget {
  final VoidCallback onRetryTap;
  const RetryWidget({super.key, required this.onRetryTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${APIEndPoints.baseURL} ${AppStrings.notReachable}',
              textAlign: TextAlign.center,
              style: custom16w800.copyWith(color: ColorConstants.kDarkGrey),
            ),
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: ColorConstants.kIOSRed),
            shape: CircleBorder(),
          ),
          onPressed: onRetryTap,
          child: Icon(Icons.refresh, color: ColorConstants.kIOSRed, size: 30),
        ),
      ],
    );
  }
}
