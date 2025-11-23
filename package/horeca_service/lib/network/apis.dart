class APIs {
  // MARK: - Upload file_
  var upload = "/api/uploadFile";

  // MARK: - Sync
  var download = "/api/downloadFile";
  var syncInitData = "/api/sync/getInitData";
  static var syncLogging = "/api/sync/updateLatest";
  static var syncRequestUpdateData = "/api/sync/requestUpdateData";
  static var syncGetUpdateData = "/api/sync/getUpdateData";
  var syncGetDailyData = "/api/sync/getDailyData";

  // MARK: - Login
  var login = "/api/auth/login";
  static var getInitData = "/api/sync/getInitData";

  // MARK: - Membership
  var membershipFindAll = "/api/membership/findAll";
  var membershipGetInfor = "/api/membership/getInfor";
  var membershipSave = "/api/membership/save";

  // MARK: - Shift
  static var startShift = "/api/shift/startShift";
  static var endShift = "/api/shift/endShift";

  // MARK: - Customer visit
  static var checkin = "/api/visit/checkin";
  static var revisit = "/api/visit/revisit";
  static var checkout = "/api/visit/checkout";
  static var cancel = "/api/visit/cancel";

  // MARK: - Check stock
  static var checkStock = "/api/stock/checkStockCustomer";

  // MARK: - Confirm allocation
  static var confirmAllocation = "/api/stock/confirmAllocation";

  // MARK: - Create order
  static var createOrder = "/api/order/createOrder";

  // MARK: - Redemption
  static var redeem = "/api/redeem/save";

  // MARK: - Pack swap
  static var packswap = "/api/packswap/save";

  // MARK: - Reward
  static var reward = "/api/reward/save";
  static var otp = "/api/reward/otp";

  // MARK: - Stock return
  static var stockReturn = "/api/stock/return";

  // MARK: - Cashback
  static var cashback = "/api/cashback/save";

  // MARK: - Change password
  static var changePassword = "/api/auth/change/pwd";

  // MARK: - Survey
  static var survey = "/api/survey/save";
  // MARK: - Smoker
  static var smokerFindAll = "/api/smoker/findAll";
  static var smokerGetInfo = "/api/smoker/getInfor";
  static var smokerSave = "/api/smoker/save";

  static var oauth = "/oauth/token";
  static var getApk = "/api/sync/getAPK";
}
