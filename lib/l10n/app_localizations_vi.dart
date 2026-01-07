// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get login => 'Đăng nhập';

  @override
  String get account => 'Tài khoản';

  @override
  String get password => 'Mật khẩu';

  @override
  String get enterAccount => 'Vui lòng nhập tài khoản';

  @override
  String get enterPassword => 'Vui lòng nhập mật khẩu';

  @override
  String enter(Object object) {
    return 'Vui lòng nhập $object';
  }

  @override
  String get shift => 'Ca làm việc';

  @override
  String get visit => 'Viếng thăm';

  @override
  String get storage => 'Kho';

  @override
  String get system => 'Hệ thống';

  @override
  String get sync => 'Đồng bộ';

  @override
  String get startTime => 'Thời gian bắt đầu';

  @override
  String get endTime => 'Thời gian kết thúc';

  @override
  String get numberVisitor => 'Tổng số khách hàng viếng thăm';

  @override
  String get numberCancelVisitor => 'Tổng số khách hàng huỷ viếng thăm';

  @override
  String get numberOfflineVisitor =>
      'Tổng số khách hàng viếng thăm ngoại tuyến';

  @override
  String get totalOrderShift => 'Tổng đơn hàng trong ca';

  @override
  String get totalProductPurchase => 'Tổng sản lượng mua';

  @override
  String get totalOrderAmount => 'Tổng tiền đơn hàng';

  @override
  String get no => 'STT';

  @override
  String get productCode => 'Mã sản phẩm';

  @override
  String get productName => 'Tên sản phẩm';

  @override
  String get totalQuantity => 'Tổng số lượng';

  @override
  String get totalAmount => 'Tổng tiền mua hàng';

  @override
  String get orderNo => 'Mã đơn hàng';

  @override
  String get customerName => 'Tên khách hàng';

  @override
  String get deliveryAddress => 'Địa chỉ giao hàng';

  @override
  String workShift(Object date) {
    return 'Ca làm việc ngày $date';
  }

  @override
  String get finishShift => 'Kết thúc ca';

  @override
  String cannotSynchronize(Object object) {
    return 'Không thể đồng bộ $object';
  }

  @override
  String get list => 'Danh sách';

  @override
  String listOf(Object object) {
    return 'Danh sách $object';
  }

  @override
  String get productPrice => 'Giá của sản phẩm';

  @override
  String get discount => 'Chiết khấu';

  @override
  String get promotion => 'Khuyến mãi';

  @override
  String get order => 'Đơn hàng';

  @override
  String get salesInventory => 'Tồn kho bán hàng';

  @override
  String get update => 'Cập nhật';

  @override
  String get updateData => 'Cập nhật dữ liệu';

  @override
  String get success => 'Thành công';

  @override
  String get unsucess => 'Không thành công';

  @override
  String get failed => 'Thất bại';

  @override
  String notFound(Object object) {
    return '$object không tồn tại';
  }

  @override
  String get createOrder => 'Tạo đơn hàng';

  @override
  String get productPromotionCriteria =>
      'Sản phẩm chưa đủ điều kiện để sử dụng khuyến mãi';

  @override
  String get planDeliveryDate => 'Ngày dự kiến giao hàng';

  @override
  String get information => 'Thông tin';

  @override
  String get please => 'Vui lòng';

  @override
  String get customerVisitAddress => 'Địa chỉ viếng thăm khách hàng';

  @override
  String get employee => 'Nhân viên';

  @override
  String get doSurvey => 'Làm khảo sát';

  @override
  String get endVisit => 'Kết thúc viếng thăm';

  @override
  String get startVisit => 'Bắt đầu viếng thăm';

  @override
  String get cancelVisit => 'Hủy viếng thăm';

  @override
  String turnOnInternet(Object object) {
    return 'Vui lòng kết nối mạng Internet trước khi thực hiện $object';
  }

  @override
  String isNotBlank(Object object) {
    return '$object không được để trống';
  }

  @override
  String get currentPassword => 'Mật khẩu hiện tại';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get oldPassword => 'Mật khẩu cũ';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get tryAgain => 'Vui lòng thử lại!';

  @override
  String get wrongCurrentPassword => 'Mật khẩu hiện tại không chính xác';

  @override
  String get wrongConfirmPassword => 'Mật khẩu xác nhận không trùng khớp';

  @override
  String get startShift => 'Bắt đầu ca';

  @override
  String get endShift => 'Kết thúc ca';

  @override
  String get homeScreen => 'Màn hình chính';

  @override
  String get customerCode => 'Mã khách hàng';

  @override
  String get visitDate => 'Ngày viếng thăm';

  @override
  String get numberOfVisits => 'Số lần viếng thăm';

  @override
  String get customer => 'Khách hàng';

  @override
  String get shfitManagement => 'Quản lý ca làm việc';

  @override
  String get product => 'Sản phẩm';

  @override
  String get brand => 'Thương hiệu';

  @override
  String get company => 'Công ty';

  @override
  String get unit => 'Đơn vị';

  @override
  String get allocation => 'Phân bổ';

  @override
  String get initAllocation => 'Phân bổ ban đầu';

  @override
  String get usedAllocation => 'Phân bổ đã sử dụng';

  @override
  String get availableAllocation => 'Phân bổ khả dụng';

  @override
  String get userInfo => 'Thông tin người dùng';

  @override
  String get appInfo => 'Thông tin ứng dụng';

  @override
  String get changePassword => 'Thay đổi mật khẩu';

  @override
  String get submit => 'Xác nhận';

  @override
  String get version => 'Phiên bản';

  @override
  String get server => 'Máy chủ';

  @override
  String get imeiDevice => 'Mã định danh thiết bị';

  @override
  String get ui => 'Giao diện';

  @override
  String get lang => 'Ngôn ngữ';

  @override
  String get settings => 'Cài đặt';

  @override
  String get merchandise => 'Hàng hóa';

  @override
  String get purchase => 'Mua hàng';

  @override
  String get summary => 'Tổng kết';

  @override
  String get gallery => 'Thư viện';

  @override
  String get stockSalesStaff => 'Hàng của NVBH';

  @override
  String get type => 'Loại';

  @override
  String get priceAtPointSales => 'Giá điểm bán';

  @override
  String get quantity => 'Số lượng';

  @override
  String get addNew => 'Thêm mới';

  @override
  String get promotionProgram => 'Chương trình khuyến mãi';

  @override
  String get discountProgram => 'Chương trình chiết khấu';

  @override
  String get exportDatabase => 'Xuất Cơ Sở Dữ Liệu';

  @override
  String get databaseExported => 'Đã xuất cơ sở dữ liệu thành công';

  @override
  String exportFailed(Object error) {
    return 'Xuất thất bại: $error';
  }

  @override
  String get pleaseWaitForCalculation =>
      'Vui lòng đợi tính toán đơn hàng hoàn tất trước khi lưu';

  @override
  String get promotionCode => 'Mã khuyến mãi';

  @override
  String get promotionName => 'Tên khuyến mãi';

  @override
  String get fromDate => 'Từ ngày';

  @override
  String get toDate => 'Đến ngày';

  @override
  String get accumulated => 'Lũy kế';

  @override
  String get discountCode => 'Mã chiết khấu';

  @override
  String get discountName => 'Tên chiết khấu';

  @override
  String get salesDate => 'Ngày bán hàng';

  @override
  String get status => 'Trạng thái';

  @override
  String get survey => 'Khảo sát';

  @override
  String get surverProgram => 'Chương trình khảo sát';

  @override
  String get startDate => 'Ngày bắt đầu';

  @override
  String get endDate => 'Ngày kết thúc';

  @override
  String get surveryed => 'Đã khảo sát';

  @override
  String get debtLimit => 'Hạn mức công nợ';

  @override
  String get availableDebt => 'Công nợ khả dụng';

  @override
  String get daysOfWeek => 'Ngày trong tuần';

  @override
  String get allDaysOfWeek => 'Tất cả ngày trong tuần';

  @override
  String get morningShift => 'Ca sáng';

  @override
  String get eveningShift => 'Ca chiều';

  @override
  String get nightShift => 'Ca tối';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get program => 'Chương trình';

  @override
  String get enterKeyWordForSearching => 'Nhập vào để tìm kiếm';

  @override
  String get syncManagement => 'Quản lý đồng bộ';

  @override
  String get contentSync => 'Nội dung đồng bộ';

  @override
  String get priceOfCompany => 'Giá công ty';

  @override
  String get mon => 'T2';

  @override
  String get tue => 'T3';

  @override
  String get wed => 'T4';

  @override
  String get thu => 'T5';

  @override
  String get fri => 'T6';

  @override
  String get sat => 'T7';

  @override
  String get sun => 'CN';

  @override
  String get all => 'Tất cả';

  @override
  String get creditBalanceExceeded => 'Số dư nợ tín dụng đã vượt quá';

  @override
  String doYouWant(Object object) {
    return 'Bạn có muốn $object';
  }

  @override
  String get loginAgain => 'Vui lòng đăng nhập lại';

  @override
  String syncNotYetAndDo(Object object) {
    return '$object chưa được đồng bộ, vui lòng đồng bộ $object trước';
  }

  @override
  String get revisit => 'Viếng thăm lại';

  @override
  String errorOccur(Object object) {
    return 'Xảy ra lỗi trong quá trình $object';
  }

  @override
  String get data => 'Dữ liệu';

  @override
  String get sendRequest => 'Gửi yêu cầu';

  @override
  String get initialData => 'Khởi tạo dữ liệu';

  @override
  String get initializingData => 'Đang khởi tạo dữ liệu';

  @override
  String get waiting => 'Vui lòng đợi …';

  @override
  String get changeLanguageSuccess => 'Thay đổi ngôn ngữ thành công';

  @override
  String get notification => 'Thông báo';

  @override
  String get discountManagement => 'Quản lý chiết khấu';

  @override
  String get select => 'Chọn';

  @override
  String get unitPriceBeforeVAT => 'Đơn giá trước VAT';

  @override
  String get discountRate => 'Tỉ lệ chiết khấu';

  @override
  String get discountUnitPrice => 'Đơn giá chiết khấu';

  @override
  String get promotionalProduct => 'Sản phẩm khuyến mãi';

  @override
  String get note => 'Chú thích';

  @override
  String get totalDiscount => 'Tổng chiết khấu';

  @override
  String get total => 'Tổng cộng';

  @override
  String get salesDetails => 'Chi tiết bán hàng';

  @override
  String get grandTotalAmount => 'Tổng tiền';

  @override
  String get totalPromotionValue => 'Tổng khuyến mãi';

  @override
  String get totalVATValue => 'Tổng VAT';

  @override
  String get finish => 'Hoàn tất';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get cancel => 'Hủy bỏ';

  @override
  String get noPromotionsApplyOrder =>
      'Không có khuyến mãi nào áp dụng cho đơn hàng này';

  @override
  String get noDiscountsApplyOrder =>
      'Không có chiết khấu nào áp dụng cho đơn hàng này';

  @override
  String get maxCreditAmount => 'Số tiền tín dụng tối đa (VNĐ)';

  @override
  String get currentCreditBalance => 'Số dư tín dụng hiện tại (VNĐ)';

  @override
  String get address => 'Địa chỉ';

  @override
  String get orderType => 'Loại đơn hàng';

  @override
  String get draft => 'Nháp';

  @override
  String get selectDate => 'Chọn ngày';

  @override
  String get poNumber => 'Số PO';

  @override
  String get add => 'Thêm';

  @override
  String get confirmedQuantity => 'Số lượng xác nhận';

  @override
  String get orderedQuantity => 'Số lượng đặt hàng';

  @override
  String get deliveryDate => 'Ngày giao hàng';

  @override
  String get truckCode => 'Mã xe tải';

  @override
  String get shippingCode => 'Mã giao hàng';

  @override
  String get shippingStatus => 'Trạng thái giao hàng';

  @override
  String get selectReasonCancelVisit => 'Chọn lý do hủy viếng thăm';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get price => 'Giá';

  @override
  String get detail => 'Chi tiết';

  @override
  String get numberOfPointOfSales => 'Số lượng của điểm bán';

  @override
  String get numberOfDTC => 'Số lượng của DTC';

  @override
  String get amoutPaidToPointOfSalse => 'Số tiền trả cho điểm bán';

  @override
  String get amoutPaidToManager => 'Số tiền trả cho quản lý';

  @override
  String get discountAmount => 'Số tiền chiết khấu';

  @override
  String get surveyContent => 'Nội dung khảo sát';

  @override
  String get customerStock => 'Tồn kho khách hàng';

  @override
  String get synced => 'Đã đồng bộ';

  @override
  String get notSynced => 'Chưa đồng bộ';

  @override
  String get updatingData => 'Đang cập nhật dữ liệu';

  @override
  String inventoryIsNotEnough(Object object) {
    return 'Tồn kho sản phẩm \"$object\" không đủ';
  }

  @override
  String get logout => 'Đăng xuất';

  @override
  String get planDeliveryDateMustBeFuture =>
      'Ngày dự kiến giao hàng phải là tương lai';

  @override
  String get noProductsPurchased => 'Không có sản phẩm được mua';

  @override
  String get horecaStatus => 'Trạng thái Horeca';

  @override
  String get productInformation => 'Thông tin sản phẩm';

  @override
  String get stock => 'Tồn kho';

  @override
  String get waringBackOrder => 'Đơn hàng chưa đươc lưu\nBạn có muốn ở lại?';

  @override
  String get yesAnswer => 'Có';

  @override
  String get noAnswer => 'Không';

  @override
  String get warningCustomerVisitting => 'Có khách hàng đang viếng thăm';

  @override
  String get upgradeAppInfo => 'Thông tin cập nhật ứng dụng';

  @override
  String get currentVersion => 'Phiên bản hiện tại';

  @override
  String get newVersion => 'Phiên bản mới';

  @override
  String get msgCheckSync =>
      'Vui lòng đồng bộ dữ liệu trước khi thực hiện tác vụ khác';

  @override
  String get defaultSetting => 'Mặc định';

  @override
  String get confirmInvetory => 'Vui lòng xác nhận tồn kho điểm bán';

  @override
  String get loginFail => 'Tên đăng nhập hoặc mật khẩu không đúng';

  @override
  String get errMsgNotPriceProduct =>
      'Sản phẩm chưa được đăng giá, không thể đặt hàng sản phẩm này';

  @override
  String get waringInitialData =>
      'Dữ liệu chưa được đồng bộ sẽ bị xoá khi được khởi tạo.\nBạn có muốn tiếp tục?';

  @override
  String get ok => 'Ok';

  @override
  String get msgGetInfoLastestUpdate =>
      'Lấy thông tin cập nhật cuối cùng thất bại';

  @override
  String get errorNoInternet =>
      'Không có kết nối Internet. Vui lòng kiểm tra cài đặt mạng.';

  @override
  String get errorTimeout => 'Yêu cầu hết thời gian chờ. Vui lòng thử lại.';

  @override
  String get errorBadRequest =>
      'Yêu cầu không hợp lệ. Vui lòng kiểm tra dữ liệu đầu vào.';

  @override
  String get errorUnauthorized => 'Chưa được ủy quyền. Vui lòng đăng nhập lại.';

  @override
  String get errorForbidden => 'Truy cập bị cấm. Bạn không có quyền.';

  @override
  String get errorNotFound =>
      'Không tìm thấy tài nguyên. Vui lòng kiểm tra URL.';

  @override
  String get errorServer => 'Lỗi máy chủ nội bộ. Vui lòng thử lại sau.';

  @override
  String get errorServiceUnavailable =>
      'Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau.';

  @override
  String get errorParse =>
      'Không thể phân tích phản hồi. Vui lòng liên hệ hỗ trợ.';

  @override
  String get errorUnknown => 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.';

  @override
  String get errorSlowResponse =>
      'Phản hồi từ máy chủ quá chậm. Vui lòng kiểm tra kết nối.';

  @override
  String get startVisitSuccess => 'Bắt đầu viếng thăm thành công';
}
