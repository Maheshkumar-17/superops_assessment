import 'package:equatable/equatable.dart';

///Custom exception class.

class CustomException extends Equatable implements Exception {
  @override
  List<Object?> get props => [];
}

class NetWorkException extends CustomException {
  NetWorkException();

  @override
  String toString() => 'Please check your internet connection';

  @override
  List<Object?> get props => [];
}

class APIException extends CustomException {
  final String error;

  APIException(this.error);

  @override
  String toString() => error;

  @override
  List<Object?> get props => [error];
}
