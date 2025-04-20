import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superops_assessment/data/app_navigation/arguments_model/author_details_screen_args_model.dart';
import 'package:superops_assessment/data/app_navigation/i_navigation_manager.dart';
import 'package:superops_assessment/data/data_repository/i_data_repository.dart';
import 'package:superops_assessment/data/models/authors_list_response_model.dart';
import 'package:superops_assessment/di/service_locator.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/homescreen/authors_list_cubit.dart';
import 'package:superops_assessment/presentation/colors/color_constants.dart';
import 'package:superops_assessment/presentation/screens/widgets/common/cached_image_widget.dart';
import 'package:superops_assessment/presentation/screens/widgets/common/delete_confirmation_dialog_box.dart';
import 'package:superops_assessment/presentation/screens/widgets/common/favourite_icon_button_widget.dart';
import 'package:superops_assessment/presentation/strings/app_strings.dart';
import 'package:superops_assessment/presentation/styles/custom_text_styles.dart';

///This is the list item widget.
///The use of [showFavAndDelButton] property is to hide those buttons while showing this widget in delete confirmation model.

class AuthorsListItemWidget extends StatefulWidget {
  final AuthorsListItemModel authorModel;
  final bool showFavAndDelButton;
  const AuthorsListItemWidget({
    super.key,
    required this.authorModel,
    this.showFavAndDelButton = true,
  });

  @override
  State<AuthorsListItemWidget> createState() => _AuthorsListItemWidgetState();
}

class _AuthorsListItemWidgetState extends State<AuthorsListItemWidget> {
  late AuthorsListCubit _authorsListCubit;
  Set<int> favouriteAuthorIDs = {};
  late ValueNotifier<bool> _isFavourite;
  late ValueNotifier<bool> _isBeingDeleted;

  @override
  void initState() {
    _authorsListCubit = BlocProvider.of<AuthorsListCubit>(context);
    favouriteAuthorIDs = _authorsListCubit.favoriteAuthorIds;
    _isFavourite = ValueNotifier(
      _authorsListCubit.favoriteAuthorIds.contains(widget.authorModel.id),
    );
    _isBeingDeleted = ValueNotifier(false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isBeingDeleted,
      builder: (context, isBeingDeleted, child) {
        return AnimatedOpacity(
          opacity: isBeingDeleted ? 0.0 : 1.0,
          duration: Duration(milliseconds: 300),
          onEnd: () {
            if (isBeingDeleted) {
              _authorsListCubit.deleteAuthorById(widget.authorModel.id ?? 0);
            }
          },
          child: Container(
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border:
                  widget.showFavAndDelButton
                      ? Border.all(color: ColorConstants.kGreyShade100)
                      : null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: _navigateToAuthorDetailsScreen,
              child: Row(
                children: [
                  _getAvatarWidget(),
                  _getTitleAndSubtitleWidget(),
                  if (widget.showFavAndDelButton) ...[
                    _getFavouriteIcon(),
                    _getDeleteButton(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getAvatarWidget() {
    return CachedImageWidget(
      photoUrl: widget.authorModel.author?.photoUrl ?? '',
      width: 70,
    );
  }

  Widget _getTitleAndSubtitleWidget() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Text('${widget.authorModel.author?.name}', style: custom14w800),
          Text(widget.authorModel.timeAgo, style: custom12w600),
        ],
      ),
    );
  }

  Widget _getFavouriteIcon() {
    return FavouriteIconWidget(
      isFavourite: _isFavourite,
      onTap: _toggleFavourite,
      iconSize: 20,
    );
  }

  Widget _getDeleteButton() {
    return Container(
      padding: EdgeInsets.all(12),
      child: OutlinedButton(
        onPressed: _showDeleteConfirmationDialog,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: ColorConstants.kIOSRed, width: 2),
        ),
        child: Text(
          AppStrings.delete,
          style: custom14w800.copyWith(color: ColorConstants.kIOSRed),
        ),
      ),
    );
  }

  void _toggleFavourite() {
    _authorsListCubit.toggleFavorite(widget.authorModel.id ?? 0);
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => DeleteConfirmationDialogBox(
            onDelete: () {
              _isBeingDeleted.value = true;
              Navigator.pop(context);
            },
            onCancel: () {
              Navigator.pop(context);
            },
            confirmationQuestion: AppStrings.deleteAuthor,
            userChosenItem: BlocProvider(
              create:
                  (BuildContext context) =>
                      AuthorsListCubit(getIt.get<IDataRepository>()),
              child: AuthorsListItemWidget(
                authorModel: widget.authorModel,
                showFavAndDelButton: false,
              ),
            ),
          ),
    );
  }

  void _navigateToAuthorDetailsScreen() {
    getIt.get<INavigationManager>().navigateToAuthorDetailsScreen(
      context,
      AuthorDetailsScreenArguments(
        authorDetails: widget.authorModel.author ?? AuthorModel(),
        content: widget.authorModel.content ?? '',
        isFavourite: _isFavourite,
        onFavouriteIconTapped: _toggleFavourite,
      ),
    );
  }
}
