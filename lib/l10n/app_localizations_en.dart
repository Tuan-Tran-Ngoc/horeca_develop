// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get account => 'Account';

  @override
  String get password => 'Password';

  @override
  String get enterAccount => 'Please enter account';

  @override
  String get enterPassword => 'Please enter password';

  @override
  String enter(Object object) {
    return 'Please enter $object';
  }

  @override
  String get shift => 'Shift';

  @override
  String get visit => 'Visit';

  @override
  String get storage => 'Storage';

  @override
  String get system => 'System';

  @override
  String get sync => 'Synchronize';

  @override
  String get startTime => 'Start time';

  @override
  String get endTime => 'End time';

  @override
  String get numberVisitor => 'Total number of visitor';

  @override
  String get numberCancelVisitor => 'Total number of cancel visitors';

  @override
  String get numberOfflineVisitor => 'Total number of offline visitors';

  @override
  String get totalOrderShift => 'Total orders in shift';

  @override
  String get totalProductPurchase => 'Total products purchased';

  @override
  String get totalOrderAmount => 'Total order amount';

  @override
  String get no => 'No';

  @override
  String get productCode => 'Product code';

  @override
  String get productName => 'Product name';

  @override
  String get totalQuantity => 'Total quantity';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get orderNo => 'Order no';

  @override
  String get customerName => 'Customer name';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String workShift(Object date) {
    return 'Work shift on $date';
  }

  @override
  String get finishShift => 'Finish shift';

  @override
  String cannotSynchronize(Object object) {
    return 'Cannot synchronize $object';
  }

  @override
  String get list => 'List';

  @override
  String listOf(Object object) {
    return 'List of $object';
  }

  @override
  String get productPrice => 'Price of product';

  @override
  String get discount => 'Discount';

  @override
  String get promotion => 'Promotion';

  @override
  String get order => 'Order';

  @override
  String get salesInventory => 'Sales inventory';

  @override
  String get update => 'Update';

  @override
  String get updateData => 'Update data';

  @override
  String get success => 'Successfully';

  @override
  String get unsucess => 'Unsuccessfully';

  @override
  String get failed => 'Failed';

  @override
  String notFound(Object object) {
    return '$object does not exist';
  }

  @override
  String get createOrder => 'Create order';

  @override
  String get productPromotionCriteria =>
      'The product is not eligible for promotion';

  @override
  String get planDeliveryDate => 'Plan of delivery date';

  @override
  String get information => 'Information';

  @override
  String get please => 'Please';

  @override
  String get customerVisitAddress => 'Customer visit address';

  @override
  String get employee => 'Employee';

  @override
  String get doSurvey => 'Do a survey';

  @override
  String get endVisit => 'End visit';

  @override
  String get startVisit => 'Start visit';

  @override
  String get cancelVisit => 'Cancel visit';

  @override
  String turnOnInternet(Object object) {
    return 'Please connect to the Internet before to do $object';
  }

  @override
  String isNotBlank(Object object) {
    return '$object must not be blank';
  }

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get oldPassword => 'Old password';

  @override
  String get confirmPassword => 'Password confirmation';

  @override
  String get tryAgain => 'Please try again!';

  @override
  String get wrongCurrentPassword => 'Current password was wrong';

  @override
  String get wrongConfirmPassword => 'Confirmation password was wrong';

  @override
  String get startShift => 'Start shift';

  @override
  String get endShift => 'End shift';

  @override
  String get homeScreen => 'Home screen';

  @override
  String get customerCode => 'Customer code';

  @override
  String get visitDate => 'Visit date';

  @override
  String get numberOfVisits => 'Number of visits';

  @override
  String get customer => 'Customer';

  @override
  String get shfitManagement => 'Shift management';

  @override
  String get product => 'Product';

  @override
  String get brand => 'Brand';

  @override
  String get company => 'Company';

  @override
  String get unit => 'Unit';

  @override
  String get allocation => 'Allocation';

  @override
  String get initAllocation => 'Initial allocation';

  @override
  String get usedAllocation => 'Used allocation';

  @override
  String get availableAllocation => 'Available allocation';

  @override
  String get userInfo => 'User information';

  @override
  String get appInfo => 'Application information';

  @override
  String get changePassword => 'Change password';

  @override
  String get submit => 'Submit';

  @override
  String get version => 'Version';

  @override
  String get server => 'Server';

  @override
  String get imeiDevice => 'Imei Deivce';

  @override
  String get ui => 'User interface';

  @override
  String get lang => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get merchandise => 'Merchandise';

  @override
  String get purchase => 'Purchase';

  @override
  String get summary => 'Summary';

  @override
  String get gallery => 'Gallery';

  @override
  String get stockSalesStaff => 'Stock of sales staff';

  @override
  String get type => 'Type';

  @override
  String get priceAtPointSales => 'Price at point of sales';

  @override
  String get quantity => 'Quantity';

  @override
  String get addNew => 'Add new';

  @override
  String get promotionProgram => 'Promotion program';

  @override
  String get discountProgram => 'Discount program';

  @override
  String get exportDatabase => 'Export Database';

  @override
  String get databaseExported => 'Database exported successfully';

  @override
  String exportFailed(Object error) {
    return 'Export failed: $error';
  }

  @override
  String get pleaseWaitForCalculation =>
      'Please wait for order calculation to complete before saving';

  @override
  String get promotionCode => 'Promotion code';

  @override
  String get promotionName => 'Promotion name';

  @override
  String get fromDate => 'From date';

  @override
  String get toDate => 'To date';

  @override
  String get accumulated => 'Accoumulated';

  @override
  String get discountCode => 'Discount code';

  @override
  String get discountName => 'Discount Name';

  @override
  String get salesDate => 'Sales date';

  @override
  String get status => 'Status';

  @override
  String get survey => 'Survey';

  @override
  String get surverProgram => 'Survey program';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get surveryed => 'Surveryed';

  @override
  String get debtLimit => 'Limit of debt';

  @override
  String get availableDebt => 'Available debt';

  @override
  String get daysOfWeek => 'Days of week';

  @override
  String get allDaysOfWeek => 'All days of week';

  @override
  String get morningShift => 'Morning shift';

  @override
  String get eveningShift => 'Evening shift';

  @override
  String get nightShift => 'Night shift';

  @override
  String get search => 'Search';

  @override
  String get program => 'Program';

  @override
  String get enterKeyWordForSearching => 'Enter key word for searching';

  @override
  String get syncManagement => 'Synchronize management';

  @override
  String get contentSync => 'Content of synchronize';

  @override
  String get priceOfCompany => 'Price of company';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get all => 'All';

  @override
  String get creditBalanceExceeded => 'Credit balance has been exceeded';

  @override
  String doYouWant(Object object) {
    return 'Do you want to $object ?';
  }

  @override
  String get loginAgain => 'Please login again';

  @override
  String syncNotYetAndDo(Object object) {
    return '$object was not synchornized yet, please synchronize $object first';
  }

  @override
  String get revisit => 'Re-visit';

  @override
  String errorOccur(Object object) {
    return 'An error occurred during process $object';
  }

  @override
  String get data => 'Data';

  @override
  String get sendRequest => 'Send request';

  @override
  String get initialData => 'Initial data';

  @override
  String get initializingData => 'Initializing data';

  @override
  String get waiting => 'Please waiting …';

  @override
  String get changeLanguageSuccess => 'Language changed successfully';

  @override
  String get notification => 'Notification';

  @override
  String get discountManagement => 'Discount management';

  @override
  String get select => 'Select';

  @override
  String get unitPriceBeforeVAT => 'Unit price before VAT';

  @override
  String get discountRate => 'Discount rate';

  @override
  String get discountUnitPrice => 'Discounted unit price';

  @override
  String get promotionalProduct => 'Promotional products';

  @override
  String get note => 'Note';

  @override
  String get totalDiscount => 'Total discount';

  @override
  String get total => 'Total';

  @override
  String get salesDetails => 'Sales details';

  @override
  String get grandTotalAmount => 'Grand total amount';

  @override
  String get totalPromotionValue => 'Total promotion value';

  @override
  String get totalVATValue => 'Total VAT value';

  @override
  String get finish => 'Finish';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get noPromotionsApplyOrder =>
      'There are no promotions applicable to this order';

  @override
  String get noDiscountsApplyOrder =>
      'There are no discounts applicable to this order';

  @override
  String get maxCreditAmount => 'Maximum credit amount (VND)';

  @override
  String get currentCreditBalance => 'Current credit balance (VND)';

  @override
  String get address => 'Address';

  @override
  String get orderType => 'Order type';

  @override
  String get draft => 'Draft';

  @override
  String get selectDate => 'Select date';

  @override
  String get poNumber => 'PO number';

  @override
  String get add => 'Add';

  @override
  String get confirmedQuantity => 'Confirmed quantity';

  @override
  String get orderedQuantity => 'Ordered quantity';

  @override
  String get deliveryDate => 'Delivery date';

  @override
  String get truckCode => 'Truck code';

  @override
  String get shippingCode => 'Shipping code';

  @override
  String get shippingStatus => 'Shipping status';

  @override
  String get selectReasonCancelVisit => 'Select a reason for cancelling visit';

  @override
  String get edit => 'Edit';

  @override
  String get price => 'Price';

  @override
  String get detail => 'Detail';

  @override
  String get numberOfPointOfSales => 'Number of points of sale';

  @override
  String get numberOfDTC => 'Number of DTC';

  @override
  String get amoutPaidToPointOfSalse => 'Amount paid to point of sale';

  @override
  String get amoutPaidToManager => 'Amount paid to manager';

  @override
  String get discountAmount => 'Discount amount';

  @override
  String get surveyContent => 'Survey content';

  @override
  String get customerStock => 'Customer stock';

  @override
  String get synced => 'Synchronized';

  @override
  String get notSynced => 'Not synchronized yet';

  @override
  String get updatingData => 'Updating data';

  @override
  String inventoryIsNotEnough(Object object) {
    return 'Inventory of \"$object\" products is not enough';
  }

  @override
  String get logout => 'Logout';

  @override
  String get planDeliveryDateMustBeFuture =>
      'Plan of delivery date must be in future';

  @override
  String get noProductsPurchased => 'No products were purchased';

  @override
  String get horecaStatus => 'Horeca status';

  @override
  String get productInformation => 'Product Information';

  @override
  String get stock => 'Stock';

  @override
  String get waringBackOrder =>
      'Your order has not been saved\nDo you want to stay?';

  @override
  String get yesAnswer => 'Yes';

  @override
  String get noAnswer => 'No';

  @override
  String get warningCustomerVisitting => 'There is a customer visiting';

  @override
  String get upgradeAppInfo => 'Application Update Information';

  @override
  String get currentVersion => 'Current Version';

  @override
  String get newVersion => 'New version';

  @override
  String get msgCheckSync =>
      'Please synchronize the data before performing another task';

  @override
  String get defaultSetting => 'Default';

  @override
  String get confirmInvetory =>
      'Please confirm the inventory at the selling point';

  @override
  String get loginFail => 'Invalid username or password';

  @override
  String get errMsgNotPriceProduct =>
      'The product has not been priced yet, this product cannot be ordered';

  @override
  String get waringInitialData =>
      'Unsynchronized data will be deleted on startup.\nYou want to continue?';

  @override
  String get ok => 'Ok';

  @override
  String get msgGetInfoLastestUpdate =>
      'Retrieving last updated information failed';

  @override
  String get errorNoInternet =>
      'No internet connection. Please check your network settings.';

  @override
  String get errorTimeout => 'Request timeout. Please try again.';

  @override
  String get errorBadRequest => 'Bad request. Please check your input.';

  @override
  String get errorUnauthorized => 'Unauthorized. Please login again.';

  @override
  String get errorForbidden => 'Access forbidden. You don\'t have permission.';

  @override
  String get errorNotFound => 'Resource not found. Please check the URL.';

  @override
  String get errorServer => 'Internal server error. Please try again later.';

  @override
  String get errorServiceUnavailable =>
      'Service temporarily unavailable. Please try again later.';

  @override
  String get errorParse => 'Unable to parse response. Please contact support.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get errorSlowResponse =>
      'Server response is too slow. Please check your connection.';

  @override
  String get startVisitSuccess => 'Visit started successfully';
}
