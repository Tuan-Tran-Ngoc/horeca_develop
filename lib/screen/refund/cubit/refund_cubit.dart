import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'refund_state.dart';

class RefundCubit extends Cubit<RefundState> {
  RefundCubit() : super(RefundInitial());
  void init() {
    emit(RefundInitialSuccess());
  }

  void clickTab(isDTC) {
    emit(LoadingItem());
    emit(ClickTabSuccess(isDTC));
  }
}
