part of 'transaction__bloc.dart';

abstract class TransactionState extends TransactionBloc {
  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionUpdated extends TransactionState {}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);

  @override
  List<Object> get props => [message];
}
class timeError extends TransactionState {
  final String errorText;

  timeError({required this.errorText});

  @override
  List<Object> get props => [errorText];
}
class quantityError extends TransactionState {
  final String errorText;

  quantityError({required this.errorText});

  @override
  List<Object> get props => [errorText];
}

class referenceErrot extends TransactionState {
  final String errorText;

  referenceErrot({required this.errorText});

  @override
  List<Object> get props => [errorText];
}

class revenueError extends TransactionState {
  final String errorText;

  revenueError({required this.errorText});

  @override
  List<Object> get props => [errorText];
}

class unitPriceError extends TransactionState {
  final String errorText;

  unitPriceError({required this.errorText});

  @override
  List<Object> get props => [errorText];
}