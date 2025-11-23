import 'package:horeca_service/sqflite_database/dto/shift_visit_dto.dart';

class VisitService {
  List<ShiftVisitDto> mergeShiftVisit(List<ShiftVisitDto> lstShiftVisit) {
    List<ShiftVisitDto> lstCustomerTarget = [];

    //distinct customer
    DateTime now = DateTime.now();
    for (ShiftVisitDto visit in lstShiftVisit) {
      if (visit.visitDate == null) {
        int daysToAdd = (visit.dayOfWeek ?? 0) - now.weekday - 1;

        if (daysToAdd < 0) {
          daysToAdd += 7;
        }

        // plan working date
        DateTime planWorkingDate = now.add(Duration(days: daysToAdd));
        visit.visitDate = planWorkingDate.toString();
      }
    }

    lstShiftVisit.sort((a, b) {
      int isCompare = 0;
      isCompare = (a.customerId ?? 0).compareTo(b.customerId ?? 0);
      if (isCompare == 0) {
        isCompare =
            (b.customerVisitId ?? 0).compareTo((a.customerVisitId ?? 0));
      }
      if (isCompare == 0 && a.visitDate != null && b.visitDate != null) {
        DateTime dateB = DateTime.parse(b.visitDate ?? '');
        DateTime dateA = DateTime.parse(a.visitDate ?? '');
        isCompare = dateA.compareTo(dateB);
      }

      if (isCompare == 0) {
        isCompare = (a.shiftCode ?? '').compareTo((b.shiftCode ?? ''));
      }

      return isCompare;
    });

    int? prevCustomerId = 0;
    for (var shiftVisit in lstShiftVisit) {
      if (shiftVisit.customerId != prevCustomerId) {
        lstCustomerTarget.add(shiftVisit);
        prevCustomerId = shiftVisit.customerId;
      } else if (shiftVisit.customerId == prevCustomerId &&
          shiftVisit.customerVisitId != null &&
          shiftVisit.parentCustomerVisitId == null) {
        // customer visit first
        lstCustomerTarget[lstCustomerTarget.length - 1].startTime =
            shiftVisit.startTime;
      }
    }

    return lstCustomerTarget;
  }
}
