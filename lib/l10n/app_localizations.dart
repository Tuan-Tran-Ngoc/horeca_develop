import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterAccount.
  ///
  /// In en, this message translates to:
  /// **'Please enter account'**
  String get enterAccount;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get enterPassword;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Please enter {object}'**
  String enter(Object object);

  /// No description provided for @shift.
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get shift;

  /// No description provided for @visit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get visit;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Synchronize'**
  String get sync;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get endTime;

  /// No description provided for @numberVisitor.
  ///
  /// In en, this message translates to:
  /// **'Total number of visitor'**
  String get numberVisitor;

  /// No description provided for @numberCancelVisitor.
  ///
  /// In en, this message translates to:
  /// **'Total number of cancel visitors'**
  String get numberCancelVisitor;

  /// No description provided for @numberOfflineVisitor.
  ///
  /// In en, this message translates to:
  /// **'Total number of offline visitors'**
  String get numberOfflineVisitor;

  /// No description provided for @totalOrderShift.
  ///
  /// In en, this message translates to:
  /// **'Total orders in shift'**
  String get totalOrderShift;

  /// No description provided for @totalProductPurchase.
  ///
  /// In en, this message translates to:
  /// **'Total products purchased'**
  String get totalProductPurchase;

  /// No description provided for @totalOrderAmount.
  ///
  /// In en, this message translates to:
  /// **'Total order amount'**
  String get totalOrderAmount;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @productCode.
  ///
  /// In en, this message translates to:
  /// **'Product code'**
  String get productCode;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productName;

  /// No description provided for @totalQuantity.
  ///
  /// In en, this message translates to:
  /// **'Total quantity'**
  String get totalQuantity;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @orderNo.
  ///
  /// In en, this message translates to:
  /// **'Order no'**
  String get orderNo;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get customerName;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get deliveryAddress;

  /// No description provided for @workShift.
  ///
  /// In en, this message translates to:
  /// **'Work shift on {date}'**
  String workShift(Object date);

  /// No description provided for @finishShift.
  ///
  /// In en, this message translates to:
  /// **'Finish shift'**
  String get finishShift;

  /// No description provided for @cannotSynchronize.
  ///
  /// In en, this message translates to:
  /// **'Cannot synchronize {object}'**
  String cannotSynchronize(Object object);

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @listOf.
  ///
  /// In en, this message translates to:
  /// **'List of {object}'**
  String listOf(Object object);

  /// No description provided for @productPrice.
  ///
  /// In en, this message translates to:
  /// **'Price of product'**
  String get productPrice;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @promotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get promotion;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @salesInventory.
  ///
  /// In en, this message translates to:
  /// **'Sales inventory'**
  String get salesInventory;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @updateData.
  ///
  /// In en, this message translates to:
  /// **'Update data'**
  String get updateData;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Successfully'**
  String get success;

  /// No description provided for @unsucess.
  ///
  /// In en, this message translates to:
  /// **'Unsuccessfully'**
  String get unsucess;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'{object} does not exist'**
  String notFound(Object object);

  /// No description provided for @createOrder.
  ///
  /// In en, this message translates to:
  /// **'Create order'**
  String get createOrder;

  /// No description provided for @productPromotionCriteria.
  ///
  /// In en, this message translates to:
  /// **'The product is not eligible for promotion'**
  String get productPromotionCriteria;

  /// No description provided for @planDeliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Plan of delivery date'**
  String get planDeliveryDate;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @please.
  ///
  /// In en, this message translates to:
  /// **'Please'**
  String get please;

  /// No description provided for @customerVisitAddress.
  ///
  /// In en, this message translates to:
  /// **'Customer visit address'**
  String get customerVisitAddress;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @doSurvey.
  ///
  /// In en, this message translates to:
  /// **'Do a survey'**
  String get doSurvey;

  /// No description provided for @endVisit.
  ///
  /// In en, this message translates to:
  /// **'End visit'**
  String get endVisit;

  /// No description provided for @startVisit.
  ///
  /// In en, this message translates to:
  /// **'Start visit'**
  String get startVisit;

  /// No description provided for @cancelVisit.
  ///
  /// In en, this message translates to:
  /// **'Cancel visit'**
  String get cancelVisit;

  /// No description provided for @turnOnInternet.
  ///
  /// In en, this message translates to:
  /// **'Please connect to the Internet before to do {object}'**
  String turnOnInternet(Object object);

  /// No description provided for @isNotBlank.
  ///
  /// In en, this message translates to:
  /// **'{object} must not be blank'**
  String isNotBlank(Object object);

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation'**
  String get confirmPassword;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again!'**
  String get tryAgain;

  /// No description provided for @wrongCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password was wrong'**
  String get wrongCurrentPassword;

  /// No description provided for @wrongConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirmation password was wrong'**
  String get wrongConfirmPassword;

  /// No description provided for @startShift.
  ///
  /// In en, this message translates to:
  /// **'Start shift'**
  String get startShift;

  /// No description provided for @endShift.
  ///
  /// In en, this message translates to:
  /// **'End shift'**
  String get endShift;

  /// No description provided for @homeScreen.
  ///
  /// In en, this message translates to:
  /// **'Home screen'**
  String get homeScreen;

  /// No description provided for @customerCode.
  ///
  /// In en, this message translates to:
  /// **'Customer code'**
  String get customerCode;

  /// No description provided for @visitDate.
  ///
  /// In en, this message translates to:
  /// **'Visit date'**
  String get visitDate;

  /// No description provided for @numberOfVisits.
  ///
  /// In en, this message translates to:
  /// **'Number of visits'**
  String get numberOfVisits;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @shfitManagement.
  ///
  /// In en, this message translates to:
  /// **'Shift management'**
  String get shfitManagement;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @allocation.
  ///
  /// In en, this message translates to:
  /// **'Allocation'**
  String get allocation;

  /// No description provided for @initAllocation.
  ///
  /// In en, this message translates to:
  /// **'Initial allocation'**
  String get initAllocation;

  /// No description provided for @usedAllocation.
  ///
  /// In en, this message translates to:
  /// **'Used allocation'**
  String get usedAllocation;

  /// No description provided for @availableAllocation.
  ///
  /// In en, this message translates to:
  /// **'Available allocation'**
  String get availableAllocation;

  /// No description provided for @userInfo.
  ///
  /// In en, this message translates to:
  /// **'User information'**
  String get userInfo;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'Application information'**
  String get appInfo;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @imeiDevice.
  ///
  /// In en, this message translates to:
  /// **'Imei Deivce'**
  String get imeiDevice;

  /// No description provided for @ui.
  ///
  /// In en, this message translates to:
  /// **'User interface'**
  String get ui;

  /// No description provided for @lang.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get lang;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @merchandise.
  ///
  /// In en, this message translates to:
  /// **'Merchandise'**
  String get merchandise;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @stockSalesStaff.
  ///
  /// In en, this message translates to:
  /// **'Stock of sales staff'**
  String get stockSalesStaff;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @priceAtPointSales.
  ///
  /// In en, this message translates to:
  /// **'Price at point of sales'**
  String get priceAtPointSales;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get addNew;

  /// No description provided for @promotionProgram.
  ///
  /// In en, this message translates to:
  /// **'Promotion program'**
  String get promotionProgram;

  /// No description provided for @discountProgram.
  ///
  /// In en, this message translates to:
  /// **'Discount program'**
  String get discountProgram;

  /// No description provided for @exportDatabase.
  ///
  /// In en, this message translates to:
  /// **'Export Database'**
  String get exportDatabase;

  /// No description provided for @databaseExported.
  ///
  /// In en, this message translates to:
  /// **'Database exported successfully'**
  String get databaseExported;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(Object error);

  /// No description provided for @pleaseWaitForCalculation.
  ///
  /// In en, this message translates to:
  /// **'Please wait for order calculation to complete before saving'**
  String get pleaseWaitForCalculation;

  /// No description provided for @promotionCode.
  ///
  /// In en, this message translates to:
  /// **'Promotion code'**
  String get promotionCode;

  /// No description provided for @promotionName.
  ///
  /// In en, this message translates to:
  /// **'Promotion name'**
  String get promotionName;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To date'**
  String get toDate;

  /// No description provided for @accumulated.
  ///
  /// In en, this message translates to:
  /// **'Accoumulated'**
  String get accumulated;

  /// No description provided for @discountCode.
  ///
  /// In en, this message translates to:
  /// **'Discount code'**
  String get discountCode;

  /// No description provided for @discountName.
  ///
  /// In en, this message translates to:
  /// **'Discount Name'**
  String get discountName;

  /// No description provided for @salesDate.
  ///
  /// In en, this message translates to:
  /// **'Sales date'**
  String get salesDate;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @survey.
  ///
  /// In en, this message translates to:
  /// **'Survey'**
  String get survey;

  /// No description provided for @surverProgram.
  ///
  /// In en, this message translates to:
  /// **'Survey program'**
  String get surverProgram;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @surveryed.
  ///
  /// In en, this message translates to:
  /// **'Surveryed'**
  String get surveryed;

  /// No description provided for @debtLimit.
  ///
  /// In en, this message translates to:
  /// **'Limit of debt'**
  String get debtLimit;

  /// No description provided for @availableDebt.
  ///
  /// In en, this message translates to:
  /// **'Available debt'**
  String get availableDebt;

  /// No description provided for @daysOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Days of week'**
  String get daysOfWeek;

  /// No description provided for @allDaysOfWeek.
  ///
  /// In en, this message translates to:
  /// **'All days of week'**
  String get allDaysOfWeek;

  /// No description provided for @morningShift.
  ///
  /// In en, this message translates to:
  /// **'Morning shift'**
  String get morningShift;

  /// No description provided for @eveningShift.
  ///
  /// In en, this message translates to:
  /// **'Evening shift'**
  String get eveningShift;

  /// No description provided for @nightShift.
  ///
  /// In en, this message translates to:
  /// **'Night shift'**
  String get nightShift;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @program.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get program;

  /// No description provided for @enterKeyWordForSearching.
  ///
  /// In en, this message translates to:
  /// **'Enter key word for searching'**
  String get enterKeyWordForSearching;

  /// No description provided for @syncManagement.
  ///
  /// In en, this message translates to:
  /// **'Synchronize management'**
  String get syncManagement;

  /// No description provided for @contentSync.
  ///
  /// In en, this message translates to:
  /// **'Content of synchronize'**
  String get contentSync;

  /// No description provided for @priceOfCompany.
  ///
  /// In en, this message translates to:
  /// **'Price of company'**
  String get priceOfCompany;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @creditBalanceExceeded.
  ///
  /// In en, this message translates to:
  /// **'Credit balance has been exceeded'**
  String get creditBalanceExceeded;

  /// No description provided for @doYouWant.
  ///
  /// In en, this message translates to:
  /// **'Do you want to {object} ?'**
  String doYouWant(Object object);

  /// No description provided for @loginAgain.
  ///
  /// In en, this message translates to:
  /// **'Please login again'**
  String get loginAgain;

  /// No description provided for @syncNotYetAndDo.
  ///
  /// In en, this message translates to:
  /// **'{object} was not synchornized yet, please synchronize {object} first'**
  String syncNotYetAndDo(Object object);

  /// No description provided for @revisit.
  ///
  /// In en, this message translates to:
  /// **'Re-visit'**
  String get revisit;

  /// No description provided for @errorOccur.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during process {object}'**
  String errorOccur(Object object);

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get sendRequest;

  /// No description provided for @initialData.
  ///
  /// In en, this message translates to:
  /// **'Initial data'**
  String get initialData;

  /// No description provided for @initializingData.
  ///
  /// In en, this message translates to:
  /// **'Initializing data'**
  String get initializingData;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Please waiting …'**
  String get waiting;

  /// No description provided for @changeLanguageSuccess.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get changeLanguageSuccess;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @discountManagement.
  ///
  /// In en, this message translates to:
  /// **'Discount management'**
  String get discountManagement;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @unitPriceBeforeVAT.
  ///
  /// In en, this message translates to:
  /// **'Unit price before VAT'**
  String get unitPriceBeforeVAT;

  /// No description provided for @discountRate.
  ///
  /// In en, this message translates to:
  /// **'Discount rate'**
  String get discountRate;

  /// No description provided for @discountUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Discounted unit price'**
  String get discountUnitPrice;

  /// No description provided for @promotionalProduct.
  ///
  /// In en, this message translates to:
  /// **'Promotional products'**
  String get promotionalProduct;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @totalDiscount.
  ///
  /// In en, this message translates to:
  /// **'Total discount'**
  String get totalDiscount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @salesDetails.
  ///
  /// In en, this message translates to:
  /// **'Sales details'**
  String get salesDetails;

  /// No description provided for @grandTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Grand total amount'**
  String get grandTotalAmount;

  /// No description provided for @totalPromotionValue.
  ///
  /// In en, this message translates to:
  /// **'Total promotion value'**
  String get totalPromotionValue;

  /// No description provided for @totalVATValue.
  ///
  /// In en, this message translates to:
  /// **'Total VAT value'**
  String get totalVATValue;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noPromotionsApplyOrder.
  ///
  /// In en, this message translates to:
  /// **'There are no promotions applicable to this order'**
  String get noPromotionsApplyOrder;

  /// No description provided for @noDiscountsApplyOrder.
  ///
  /// In en, this message translates to:
  /// **'There are no discounts applicable to this order'**
  String get noDiscountsApplyOrder;

  /// No description provided for @maxCreditAmount.
  ///
  /// In en, this message translates to:
  /// **'Maximum credit amount (VND)'**
  String get maxCreditAmount;

  /// No description provided for @currentCreditBalance.
  ///
  /// In en, this message translates to:
  /// **'Current credit balance (VND)'**
  String get currentCreditBalance;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @orderType.
  ///
  /// In en, this message translates to:
  /// **'Order type'**
  String get orderType;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @poNumber.
  ///
  /// In en, this message translates to:
  /// **'PO number'**
  String get poNumber;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @confirmedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Confirmed quantity'**
  String get confirmedQuantity;

  /// No description provided for @orderedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Ordered quantity'**
  String get orderedQuantity;

  /// No description provided for @deliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Delivery date'**
  String get deliveryDate;

  /// No description provided for @truckCode.
  ///
  /// In en, this message translates to:
  /// **'Truck code'**
  String get truckCode;

  /// No description provided for @shippingCode.
  ///
  /// In en, this message translates to:
  /// **'Shipping code'**
  String get shippingCode;

  /// No description provided for @shippingStatus.
  ///
  /// In en, this message translates to:
  /// **'Shipping status'**
  String get shippingStatus;

  /// No description provided for @selectReasonCancelVisit.
  ///
  /// In en, this message translates to:
  /// **'Select a reason for cancelling visit'**
  String get selectReasonCancelVisit;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @numberOfPointOfSales.
  ///
  /// In en, this message translates to:
  /// **'Number of points of sale'**
  String get numberOfPointOfSales;

  /// No description provided for @numberOfDTC.
  ///
  /// In en, this message translates to:
  /// **'Number of DTC'**
  String get numberOfDTC;

  /// No description provided for @amoutPaidToPointOfSalse.
  ///
  /// In en, this message translates to:
  /// **'Amount paid to point of sale'**
  String get amoutPaidToPointOfSalse;

  /// No description provided for @amoutPaidToManager.
  ///
  /// In en, this message translates to:
  /// **'Amount paid to manager'**
  String get amoutPaidToManager;

  /// No description provided for @discountAmount.
  ///
  /// In en, this message translates to:
  /// **'Discount amount'**
  String get discountAmount;

  /// No description provided for @surveyContent.
  ///
  /// In en, this message translates to:
  /// **'Survey content'**
  String get surveyContent;

  /// No description provided for @customerStock.
  ///
  /// In en, this message translates to:
  /// **'Customer stock'**
  String get customerStock;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synchronized'**
  String get synced;

  /// No description provided for @notSynced.
  ///
  /// In en, this message translates to:
  /// **'Not synchronized yet'**
  String get notSynced;

  /// No description provided for @updatingData.
  ///
  /// In en, this message translates to:
  /// **'Updating data'**
  String get updatingData;

  /// No description provided for @inventoryIsNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Inventory of \"{object}\" products is not enough'**
  String inventoryIsNotEnough(Object object);

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @planDeliveryDateMustBeFuture.
  ///
  /// In en, this message translates to:
  /// **'Plan of delivery date must be in future'**
  String get planDeliveryDateMustBeFuture;

  /// No description provided for @noProductsPurchased.
  ///
  /// In en, this message translates to:
  /// **'No products were purchased'**
  String get noProductsPurchased;

  /// No description provided for @horecaStatus.
  ///
  /// In en, this message translates to:
  /// **'Horeca status'**
  String get horecaStatus;

  /// No description provided for @productInformation.
  ///
  /// In en, this message translates to:
  /// **'Product Information'**
  String get productInformation;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @waringBackOrder.
  ///
  /// In en, this message translates to:
  /// **'Your order has not been saved\nDo you want to stay?'**
  String get waringBackOrder;

  /// No description provided for @yesAnswer.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesAnswer;

  /// No description provided for @noAnswer.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noAnswer;

  /// No description provided for @warningCustomerVisitting.
  ///
  /// In en, this message translates to:
  /// **'There is a customer visiting'**
  String get warningCustomerVisitting;

  /// No description provided for @upgradeAppInfo.
  ///
  /// In en, this message translates to:
  /// **'Application Update Information'**
  String get upgradeAppInfo;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get currentVersion;

  /// No description provided for @newVersion.
  ///
  /// In en, this message translates to:
  /// **'New version'**
  String get newVersion;

  /// No description provided for @msgCheckSync.
  ///
  /// In en, this message translates to:
  /// **'Please synchronize the data before performing another task'**
  String get msgCheckSync;

  /// No description provided for @defaultSetting.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultSetting;

  /// No description provided for @confirmInvetory.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the inventory at the selling point'**
  String get confirmInvetory;

  /// No description provided for @loginFail.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get loginFail;

  /// No description provided for @errMsgNotPriceProduct.
  ///
  /// In en, this message translates to:
  /// **'The product has not been priced yet, this product cannot be ordered'**
  String get errMsgNotPriceProduct;

  /// No description provided for @waringInitialData.
  ///
  /// In en, this message translates to:
  /// **'Unsynchronized data will be deleted on startup.\nYou want to continue?'**
  String get waringInitialData;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @msgGetInfoLastestUpdate.
  ///
  /// In en, this message translates to:
  /// **'Retrieving last updated information failed'**
  String get msgGetInfoLastestUpdate;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network settings.'**
  String get errorNoInternet;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Bad request. Please check your input.'**
  String get errorBadRequest;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized. Please login again.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'Access forbidden. You don\'t have permission.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found. Please check the URL.'**
  String get errorNotFound;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Internal server error. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service temporarily unavailable. Please try again later.'**
  String get errorServiceUnavailable;

  /// No description provided for @errorParse.
  ///
  /// In en, this message translates to:
  /// **'Unable to parse response. Please contact support.'**
  String get errorParse;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorSlowResponse.
  ///
  /// In en, this message translates to:
  /// **'Server response is too slow. Please check your connection.'**
  String get errorSlowResponse;

  /// No description provided for @startVisitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Visit started successfully'**
  String get startVisitSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
