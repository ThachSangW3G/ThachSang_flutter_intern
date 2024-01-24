import 'package:equatable/equatable.dart';

class LocalException extends Equatable implements Exception {
  const LocalException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}
