class Constant {
  //request time out
  static const int REQUEST_TIMMEOUT = 10;

  //show toast time
  static const int SHOW_TOAST_TIME = 2;

  static const String SESSION_LOGIN_EXPIRED = 'err.sys.0205';

  // shift name
  static const String morningShift = '00';
  static const String eveningShift = '01';
  static const String nightShift = '02';
  static const String singleShift = '04';

  // brand status
  static const String stsBrdAct = '01';

  // reason type
  static const String REASON_TYPE_CANCEL_VISIT = '04';

  // time format
  static const String dateFormatterDDMMYYYY = 'dd/MM/yyyy';
  static const String dateFormatterYYYYMMDD = 'yyyy-MM-dd';
  static const String dateFormatterYYYYMMDDHHMM = 'yyyy-MM-dd HH:mm';
  static const String dateTimeFormatter = 'yyyy-MM-dd HH:mm:ss.SSS';
  static const String dateTimeStr = 'yyyyMMddHHmmssSSS';

  static const String clShift = 'cl.shf.defied';
  static const String clTypeOrder = 'cl.bod.type';
  static const String clVatValue = 'cl.vat.value';
  static const String clHorecaSts = 'cl.horeca.status';
  // order status
  static const String orderStatusCancel = '00';
  static const String orderStatusInComplete = '01';
  static const String orderStatusComplete = '02';

  // status
  static const String STS_ACT = '00';
  static const String STS_INACT = '01';

  // stock tyle
  static const String stockTypeStore = '01';
  static const String stockTypeDTC = '02';

  // path folder sync data
  static const String PATH_FOLDER_SYNC_DATA = 'assets/json/';

  // order
  static const String ORDER_CD_HEADER = 'ORD?_Temp';

  // EVisitStatus
  static const String notYetVisit = "00";
  static const String visiting = "01";
  static const String visited = "02";
  static const String canceledVisit = "03";

  // Horeca status
  static const String horecaStsDraft = "01";
  static const String horecaStsReceived = "02";
  static const String horecaStsInProgress = "03";
  static const String horecaStsDone = "04";
  static const String horecaStsCancel = "05";

  // route assignment frequence
  static const String frequencyWeekly = "00";
  static const String frequencyEvenWeek = "01";
  static const String frequencyOddWeek = "02";

  // type data
  static const String dataTypeInput = 'input';
}

// sync type
enum SyncType {
  startShift,
  endShift,
  checkinVisit,
  checkoutVisit,
  cancelVisit,
  revisit,
  order,
  customerPrice,
  customerStock,
  survey
}

enum Session {
  shiftReportId,
  shiftCode,
  workingDate,
  token,
  dateLogin,
  refreshToken,
  baPositionId,
  username,
  languageCode
}
