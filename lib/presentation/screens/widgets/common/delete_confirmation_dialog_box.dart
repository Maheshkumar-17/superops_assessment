import 'package:flutter/material.dart';
import 'package:superops_assessment/presentation/colors/color_constants.dart';
import 'package:superops_assessment/presentation/strings/app_strings.dart';
import 'package:superops_assessment/presentation/styles/custom_text_styles.dart';

///This widget is the Delete confirmation modal for confirming delete action. We can reuse this whenever needs.
///[userChosenItem] is optional paramtera because, sometimes we may don't want to show the item to be deleted. We may want to ask only confirmation.

class DeleteConfirmationDialogBox extends StatelessWidget {
  final String confirmationQuestion;
  final Widget? userChosenItem;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const DeleteConfirmationDialogBox({
    super.key,
    required this.confirmationQuestion,
    this.userChosenItem,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getTitleWidget(),
            _getSelectedItemWidget(),
            _getButtonsRow(),
          ],
        ),
      ),
    );
  }

  Widget _getTitleWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        confirmationQuestion,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _getSelectedItemWidget() {
    return userChosenItem ?? SizedBox.shrink();
  }

  Widget _getButtonsRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onCancel,
            child: Text(
              AppStrings.cancel,
              style: custom14w800.copyWith(color: Colors.black),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onDelete,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              AppStrings.delete,
              style: custom14w800.copyWith(color: ColorConstants.kIOSRed),
            ),
          ),
        ],
      ),
    );
  }
}
