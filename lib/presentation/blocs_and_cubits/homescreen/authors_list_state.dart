import 'package:equatable/equatable.dart';
import 'package:superops_assessment/data/models/authors_list_response_model.dart';

abstract class AuthorsListState extends Equatable {
  const AuthorsListState();
}

class AuthorsListInitialState extends AuthorsListState {
  @override
  List<Object> get props => [];
}

class AuthorsListLoadingState extends AuthorsListState {
  @override
  List<Object> get props => [];
}

class AuthorsListNetworkExceptionState extends AuthorsListState {
  @override
  List<Object> get props => [];
}

class AuthorsListExceptionState extends AuthorsListState {
  final String error;

  const AuthorsListExceptionState(this.error);
  @override
  List<Object> get props => [error];
}

class AuthorsListFetchSuccessState extends AuthorsListState {
  final List<AuthorsListItemModel> authorsList;

  const AuthorsListFetchSuccessState(this.authorsList);

  @override
  List<Object> get props => [authorsList];
}

class FilteredAuthorsListEmptyState extends AuthorsListState {
  const FilteredAuthorsListEmptyState();

  @override
  List<Object> get props => [];
}

class AuthorItemDeletedState extends AuthorsListState {
  final int authorId;
  const AuthorItemDeletedState(this.authorId);

  @override
  List<Object> get props => [authorId];
}

class AuthorsListSmallState extends AuthorsListState {
  final List<AuthorsListItemModel> authorsList;
  const AuthorsListSmallState(this.authorsList);

  @override
  List<Object> get props => [authorsList];
}
