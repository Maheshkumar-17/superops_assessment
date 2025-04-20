import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superops_assessment/data/models/authors_list_response_model.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/homescreen/authors_list_cubit.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/homescreen/authors_list_state.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/networkstatus/network_status_bloc.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/networkstatus/network_status_state.dart';
import 'package:superops_assessment/presentation/colors/color_constants.dart';
import 'package:superops_assessment/presentation/screens/widgets/authors_list_item_widget.dart';
import 'package:superops_assessment/presentation/screens/widgets/common/alert_dialog_box.dart';
import 'package:superops_assessment/presentation/screens/widgets/common/dialog_utils.dart';
import 'package:superops_assessment/presentation/screens/widgets/common/retry_widget.dart';
import 'package:superops_assessment/presentation/screens/widgets/common/search_bar_widget.dart';
import 'package:superops_assessment/presentation/strings/app_strings.dart';
import 'package:superops_assessment/presentation/styles/custom_text_styles.dart';

///This class is the initial screen of the app.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthorsListCubit _authorsListCubit;
  late ScrollController _scrollController;
  late TextEditingController _searchBarTextController;
  List<AuthorsListItemModel> _authorsList = [];
  bool _showAlertDialog = false;

  @override
  void initState() {
    _authorsListCubit = BlocProvider.of<AuthorsListCubit>(context);
    _scrollController = ScrollController();
    _searchBarTextController = TextEditingController();

    //Fetching authorslist initially.
    _fetchAuthorsList();

    //Added listener To handle pagination.
    _scrollController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent) {
            if (_authorsListCubit.isSearchTextEmpty) {
              _fetchAuthorsList();
            }
          }
        }
      });
    });
    super.initState();
  }

  void _onLastItemVisible() {
    _authorsListCubit.onLastItemVisible();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchBarTextController.dispose();
    super.dispose();
  }

  void _fetchAuthorsList() {
    _authorsListCubit.fetchAuthorsList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkStatusBloc, NetworkStatusState>(
      listener: (context, state) {
        //For auto reload once network is back if incase Network is offline at the time of opening the app.
        if (state is NetworkStatusOnlineState &&
            _authorsListCubit.isSearchTextEmpty &&
            _authorsListCubit.authorsList.isEmpty &&
            !_authorsListCubit.isFetching) {
          _fetchAuthorsList();
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstants.kPrimaryWhite,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: BlocBuilder<AuthorsListCubit, AuthorsListState>(
              builder: (context, state) {
                //If user starts search, we are scrolling to top.
                if (!_authorsListCubit.isSearchTextEmpty) {
                  if (_scrollController.hasClients &&
                      _scrollController.offset != 0) {
                    _scrollToTop();
                  }
                }
                if (state is AuthorsListFetchSuccessState) {
                  _authorsList = state.authorsList;
                  if (_authorsList.length < 10 &&
                      _authorsListCubit.isSearchTextEmpty) {
                    _onLastItemVisible();
                  }
                }

                //To handle cases when list is small initially(at the time of opening the app) due to deletion.
                if (state is AuthorsListSmallState &&
                    _authorsListCubit.isSearchTextEmpty) {
                  _authorsList = state.authorsList;
                }
                if (state is FilteredAuthorsListEmptyState) {
                  _authorsList.clear();
                }

                //Show retry widget only when list is empty and network is offline.
                if (state is AuthorsListNetworkExceptionState &&
                    _authorsList.isEmpty) {
                  return Center(child: _getRetryWidget());
                }

                if (state is AuthorsListExceptionState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!_showAlertDialog) {
                      _showDialog(state.error.toString());
                      _showAlertDialog = true;
                    }
                  });
                }
                return Column(
                  children: [
                    _getSearchBarWidget(),
                    if (state is AuthorsListLoadingState &&
                        _authorsList.isEmpty)
                      Expanded(child: _getCircularProgressIndicator())
                    else
                      _getAuthorsListViewWidget(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSearchBarWidget() {
    return SearchBarWidget(
      searchBarTextController: _searchBarTextController,
      onChanged: _authorsListCubit.onSearchChanged,
      resultsCount: _authorsList.length,
    );
  }

  Widget _getAuthorsListViewWidget() {
    return Expanded(
      child:
          _authorsList.isEmpty
              ? _getNoDataWidget()
              : ListView.builder(
                controller: _scrollController,
                itemCount:
                    _authorsListCubit.isSearchTextEmpty
                        ? _authorsList.length + 1
                        : _authorsList.length,
                itemBuilder: (context, index) {
                  if (_authorsListCubit.isSearchTextEmpty &&
                      index == _authorsList.length) {
                    return BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
                      builder: (context, state) {
                        if (state is NetworkStatusOnlineState) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: _getCircularProgressIndicator(),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    );
                  } else {
                    return AuthorsListItemWidget(
                      //This key handles the transition of list view after deleting an item.
                      key: ValueKey('${_authorsList[index].id}_$index'),
                      authorModel: _authorsList[index],
                    );
                  }
                },
              ),
    );
  }

  Widget _getCircularProgressIndicator() {
    return Center(child: CircularProgressIndicator(color: Colors.redAccent));
  }

  Widget _getNoDataWidget() {
    if (_authorsListCubit.isSearchTextEmpty &&
        _authorsListCubit.isFetching == false) {
      return Center(
        child: BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
          builder: (context, state) {
            return Text(
              state is! NetworkStatusOfflineState
                  ? AppStrings.noData
                  : AppStrings.checkInternet,
              style: custom16w600.copyWith(color: ColorConstants.kDarkGrey),
            );
          },
        ),
      );
    } else if (_authorsListCubit.isFetching) {
      return BlocBuilder<AuthorsListCubit, AuthorsListState>(
        builder: (context, state) {
          if (state is AuthorsListFetchSuccessState) {
            _authorsList = state.authorsList;
          }
          return _getCircularProgressIndicator();
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _getRetryWidget() {
    return RetryWidget(onRetryTap: _fetchAuthorsList);
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showDialog(String alertMessage) {
    DialogUtils.showDialogBox(
      context,
      dialogWidget: AlertBoxWidget(
        alertTitle: AppStrings.someError,
        alertMessage: alertMessage,
        actionName: AppStrings.retry,
        onAction: () {
          _fetchAuthorsList();
          _showAlertDialog = false;
          Navigator.pop(context);
        },
      ),
    );
  }
}
