import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superops_assessment/data/data_repository/i_data_repository.dart';
import 'package:superops_assessment/data/localstorage/pref_key.dart';
import 'package:superops_assessment/data/localstorage/shared_prefs.dart';
import 'package:superops_assessment/data/models/authors_list_response_model.dart';
import 'package:superops_assessment/data/network/dio_utils/custom_exception.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/homescreen/authors_list_state.dart';

class AuthorsListCubit extends Cubit<AuthorsListState> {
  final IDataRepository _iDataRepository;

  AuthorsListCubit(this._iDataRepository) : super(AuthorsListInitialState()) {
    _loadFromStorage();
  }

  final List<AuthorsListItemModel> _authorsList = [];
  final List<AuthorsListItemModel> _filteredAuthorsList = [];

  String? _pageToken;

  bool _isFetching = false;
  bool _hasMore = true;
  String _searchQuery = '';
  final Set<int> _favoriteAuthorIds = {};
  final Set<int> _deletedAuthorIds = {};

  List<AuthorsListItemModel> get authorsList =>
      _searchQuery.isEmpty ? _authorsList : _filteredAuthorsList;

  bool get isSearchTextEmpty => _searchQuery.isEmpty;

  bool get isFetching => _isFetching;

  bool get hasMore => _hasMore;

  Set<int> get favoriteAuthorIds => _favoriteAuthorIds;

  Future<void> _loadFromStorage() async {
    final favouriteIDs = SharedPrefs().getStringListValue(
      PrefKey.favouriteIDsList,
    );
    _favoriteAuthorIds.addAll(favouriteIDs.map(int.parse));

    final deletedIDs = SharedPrefs().getStringListValue(PrefKey.deletedIDsList);
    _deletedAuthorIds.addAll(deletedIDs.map(int.parse));
  }

  void toggleFavorite(int authorId) async {
    if (_favoriteAuthorIds.contains(authorId)) {
      _favoriteAuthorIds.remove(authorId);
    } else {
      _favoriteAuthorIds.add(authorId);
    }
    await SharedPrefs().putStringListValue(
      PrefKey.favouriteIDsList,
      _favoriteAuthorIds.map((e) => e.toString()).toList(),
    );
  }

  void fetchAuthorsList() async {
    if ((_isFetching || !_hasMore)) return;

    _isFetching = true;
    emit(AuthorsListLoadingState());

    var result = await _iDataRepository.fetchAuthorsList(
      pageToken: _pageToken ?? '',
    );

    result.fold(
      (exception) {
        _isFetching = false;
        if (exception is NetWorkException) {
          emit(AuthorsListNetworkExceptionState());
        } else if (exception is APIException) {
          emit(AuthorsListExceptionState(exception.error));
        } else {
          emit(AuthorsListExceptionState(exception.toString()));
        }
      },
      (response) {
        _isFetching = false;
        _hasMore = response.pageToken != null && response.pageToken!.isNotEmpty;
        _pageToken = response.pageToken ?? '';
        _authorsList.addAll(response.authorsList ?? []);
        _applySearch(_searchQuery);
        if (_searchQuery.isEmpty) {
          _removeDeletedItemsIfAny();
        }
        emit(AuthorsListFetchSuccessState(_authorsList));
        if (_authorsList.isEmpty || _authorsList.length < 10) {
          fetchAuthorsList();
        }
      },
    );
  }

  void resetList() {
    _authorsList.clear();
    _pageToken = null;
    _hasMore = true;
    emit(AuthorsListInitialState());
    fetchAuthorsList();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _applySearch(_searchQuery);
  }

  void _applySearch(String query) {
    if (query.trim().isEmpty) {
      _filteredAuthorsList.clear();
      emit(AuthorsListFetchSuccessState(authorsList));
    } else {
      final searchTerm = query.replaceAll(' ', '').toLowerCase();
      _filteredAuthorsList
        ..clear()
        ..addAll(
          _authorsList.where((item) {
            final name =
                (item.author?.name ?? '').replaceAll(' ', '').toLowerCase();
            return name.startsWith(searchTerm);
          }),
        );

      if (_filteredAuthorsList.isEmpty) {
        emit(FilteredAuthorsListEmptyState());
      }

      emit(AuthorsListFetchSuccessState(_filteredAuthorsList));
    }
  }

  void deleteAuthorById(int id) async {
    _deletedAuthorIds.add(id);
    final currentList = List<AuthorsListItemModel>.from(authorsList);
    currentList.removeWhere((item) => item.id == id);

    if (_searchQuery.isEmpty) {
      _authorsList.removeWhere((item) => item.id == id);
    } else {
      _filteredAuthorsList.removeWhere((item) => item.id == id);
    }
    emit(AuthorItemDeletedState(id));
    await SharedPrefs().putStringListValue(
      PrefKey.deletedIDsList,
      _deletedAuthorIds.map((e) => e.toString()).toList(),
    );
  }

  void _removeDeletedItemsIfAny() {
    _authorsList.removeWhere((item) => _deletedAuthorIds.contains(item.id));
    emit(AuthorsListFetchSuccessState(_authorsList));
  }

  void onLastItemVisible() {
    if (hasMore && _authorsList.length < 10) {
      fetchAuthorsList();
    }
    emit(AuthorsListSmallState(_authorsList));
  }
}
