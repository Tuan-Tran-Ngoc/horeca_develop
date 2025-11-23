import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/horeca_service.dart';

part 'customer_detail_state.dart';

class CustomerDetailCubit extends Cubit<CustomerDetailState> {
  CustomerDetailCubit() : super(CustomerDetailInitial());

  CustomerVisitProvider customerVisitProvider = CustomerVisitProvider();
  CustomerProvider customerProvider = CustomerProvider();
  Future<void> init(int customerId, int customerVisitId) async {
    // statusVisit: 00:not yet visit, 01: visiting, 02: visited, 03:cancel visit
    String statusVisit = '00';
    CustomerVisit? customerVisit =
        await customerVisitProvider.select(customerVisitId, null);

    //get customerName
    Customer? customer =
        (await customerProvider.select(customerId, null)).firstOrNull;

    if (customerVisit == null) {
      statusVisit = Constant.notYetVisit;
    } else if (customerVisit.endTime == null) {
      statusVisit = Constant.visiting;
    } else {
      statusVisit = Constant.visited;
    }

    emit(CustomerDetailInitSuccess(
        customerVisitId, customer!.customerName, statusVisit));
  }

  void clickMenu(index) {
    emit(LoadingItem());
    emit(ClickMenuSuccess(index));
  }
}
