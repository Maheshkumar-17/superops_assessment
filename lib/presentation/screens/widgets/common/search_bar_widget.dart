import 'package:flutter/material.dart';
import 'package:superops_assessment/presentation/colors/color_constants.dart';
import 'package:superops_assessment/presentation/strings/app_strings.dart';
import 'package:superops_assessment/presentation/styles/custom_text_styles.dart';

///Placing this widget in common folder because in future if we need search bar in any other screens we can reuse this.

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final int resultsCount;
  final TextEditingController searchBarTextController;

  const SearchBarWidget({
    super.key,
    required this.searchBarTextController,
    required this.onChanged,
    required this.resultsCount,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getsearchBarWidget(),
        if (widget.searchBarTextController.text.trim().isNotEmpty)
          _getSearchResultWidget(),
      ],
    );
  }

  Widget _getsearchBarWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: 80),
      decoration: BoxDecoration(
        color: ColorConstants.kPrimaryLightColor,
        borderRadius: BorderRadius.circular(35),
      ),
      child: TextField(
        style: custom16w600,
        cursorColor: ColorConstants.kDarkGrey,
        autofocus: false,
        controller: widget.searchBarTextController,
        onChanged: (value) {
          widget.onChanged(value);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          hintText: '${AppStrings.search}...',
          hintStyle: custom16w600.copyWith(color: ColorConstants.kDarkGrey),
          border: InputBorder.none,
          suffixIcon: GestureDetector(
            onTap: () {
              //To clear the text on tapping close button.
              if (widget.searchBarTextController.text.isNotEmpty) {
                widget.searchBarTextController.text = '';
                widget.onChanged('');
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: Icon(
              widget.searchBarTextController.text.isNotEmpty
                  ? Icons.close
                  : Icons.search_outlined,
              color: ColorConstants.kDarkGrey,
              size: 30,
            ),
          ),
        ),
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }

  Widget _getSearchResultWidget() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${AppStrings.search} ${AppStrings.result}',
            style: custom16w800.copyWith(color: ColorConstants.kDarkGrey),
          ),
          Text(
            '${widget.resultsCount} ${AppStrings.found}',
            style: custom16w800.copyWith(color: ColorConstants.kIOSRed),
          ),
        ],
      ),
    );
  }
}
