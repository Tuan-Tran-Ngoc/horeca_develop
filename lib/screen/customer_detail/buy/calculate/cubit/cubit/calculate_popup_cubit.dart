import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'calculate_popup_state.dart';

class CalculatePopupCubit extends Cubit<CalculatePopupState> {
  CalculatePopupCubit() : super(CalculatePopupInitial());

  Future<void> init() async {
    emit(LoadingInit());
  }
}
