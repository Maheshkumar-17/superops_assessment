import 'package:flutter/material.dart';
import 'package:superops_assessment/data/app_navigation/arguments_model/author_details_screen_args_model.dart';
import 'package:superops_assessment/presentation/colors/color_constants.dart';
import 'package:superops_assessment/presentation/screens/widgets/common/cached_image_widget.dart';
import 'package:superops_assessment/presentation/screens/widgets/common/favourite_icon_button_widget.dart';
import 'package:superops_assessment/presentation/strings/app_strings.dart';
import 'package:superops_assessment/presentation/styles/custom_text_styles.dart';

class AuthorDetailsScreen extends StatefulWidget {
  final AuthorDetailsScreenArguments authorItem;
  const AuthorDetailsScreen({super.key, required this.authorItem});

  @override
  State<AuthorDetailsScreen> createState() => _AuthorDetailsScreenState();
}

class _AuthorDetailsScreenState extends State<AuthorDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kPrimaryWhite,
      appBar: AppBar(
        title: _getAppBarTitleWidget(),
        leading: _getGoBackIconButton(),
        actions: [_getFavouriteIconButton()],
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getAuthorImageWidget(),
              _getNameWidget(),
              _getContentWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAuthorImageWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CachedImageWidget(
        photoUrl: widget.authorItem.authorDetails.photoUrl ?? '',
        width: 200,
      ),
    );
  }

  Widget _getNameWidget() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        widget.authorItem.authorDetails.name ?? '',
        style: custom20w800,
      ),
    );
  }

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget.authorItem.content,
        style: custom14w600,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _getGoBackIconButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back, size: 25, color: ColorConstants.kIOSRed),
      ),
    );
  }

  Widget _getFavouriteIconButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: FavouriteIconWidget(
        isFavourite: widget.authorItem.isFavourite,
        onTap: widget.authorItem.onFavouriteIconTapped,
        iconSize: 25,
      ),
    );
  }

  Widget _getAppBarTitleWidget() {
    return Text(AppStrings.details, style: custom18w800);
  }
}
