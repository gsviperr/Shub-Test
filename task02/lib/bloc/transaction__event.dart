part of 'transaction__bloc.dart';

abstract class TransactionEvent extends TransactionBloc {
  @override
  List<Object> get props => [];
}

class UpdateTransaction extends TransactionEvent {
  final DateTime time;
  final int quantity;
  final String reference;
  final int revenue;
  final int unitPrice;

  UpdateTransaction({
    required this.time,
    required this.quantity,
    required this.reference,
    required this.revenue,
    required this.unitPrice,
  });

  @override
  List<Object> get props => [time, quantity, reference, revenue, unitPrice];
}
