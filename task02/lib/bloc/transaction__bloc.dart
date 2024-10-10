import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transaction__event.dart';
part 'transaction__state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is UpdateTransaction) {
      if (event.time.isAfter(DateTime.now())) {
        yield timeError(errorText: "Thời gian không không hợp lệ");
      } else if (event.quantity <= 0) {
        yield quantityError(errorText: "Số lượng phải lớn hơn 0");
      } else if (event.reference.isEmpty) {
        yield referenceErrot(errorText: "Tham chiếu không được để trống");
      } else if (event.revenue <= 0) {
        yield revenueError(errorText: "Doanh thu phải lớn hơn 0");
      } else if (event.unitPrice <= 0) {
        yield unitPriceError(errorText: "Giá đơn vị phải lớn hơn 0");
      } else {
        yield TransactionUpdated();
      }
      yield TransactionUpdated();
    }
  }
}