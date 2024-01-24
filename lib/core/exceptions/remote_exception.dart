import 'package:equatable/equatable.dart';

class RemoteException extends Equatable implements Exception {
  const RemoteException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}
