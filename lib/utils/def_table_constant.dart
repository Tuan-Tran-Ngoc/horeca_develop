class DefTableConstant {
  // def json file
  static const String JSON_ACCOUNT_OFFLINE = 'm_account_offline.json';
  static const String JSON_ACCOUNT_POSITION_LINK =
      'm_account_position_link.json';
  static const String JSON_ACCOUNT = 'm_account.json';
  static const String JSON_AREA_LEVEL = 'm_area_level.json';
  static const String JSON_AREA = 'm_area.json';
  static const String JSON_BRAND = 'm_brand.json';
  static const String JSON_CATEGORY = 'm_category.json';
  static const String JSON_CUSTOMER_ADDRESS = 'm_customer_address.json';
  static const String JSON_CUSTOMER_PROPERTY = 'm_customer_property.json';
  static const String JSON_CUSTOMER = 'm_customer.json';
  static const String JSON_DISCOUNT_CONDITION = 'm_discount_condition.json';
  static const String JSON_DISCOUNT_RESULT = 'm_discount_result.json';
  static const String JSON_DISCOUNT_SCHEME = 'm_discount_scheme.json';
  static const String JSON_DISCOUNT_TARGET = 'm_discount_target.json';
  static const String JSON_DISCOUNT = 'm_discount.json';
  static const String JSON_DISTRICT = 'm_district.json';
  static const String JSON_EMPLOYEE_POSITION_LINK =
      'm_employee_position_link.json';
  static const String JSON_EMPLOYEE = 'm_employee.json';
  static const String JSON_LANGUAGE = 'm_language.json';
  static const String JSON_MEMBERSHIP = 'm_membership.json';
  static const String JSON_MESSAGES = 'm_messages.json';
  static const String JSON_PRODUCT_TYPE = 'm_product_type.json';
  static const String JSON_PRODUCT = 'm_product.json';
  static const String JSON_PROMOTION_CONDITION = 'm_promotion_condition.json';
  static const String JSON_PROMOTION_RESULT = 'm_promotion_result.json';
  static const String JSON_PROMOTION_SCHEME = 'm_promotion_scheme.json';
  static const String JSON_PROMOTION_TARGET = 'm_promotion_target.json';
  static const String JSON_PROMOTION = 'm_promotion.json';
  static const String JSON_PROVINCE = 'm_province.json';
  static const String JSON_REASON = 'm_reason.json';
  static const String JSON_RESOURCE = 'm_resource.json';
  static const String JSON_ROUTE_ASSIGNMENT = 'm_route_assignment.json';
  static const String JSON_SURVEY_TARGET = 'm_survey_target.json';
  static const String JSON_SURVEY = 'm_survey.json';
  static const String JSON_UOM = 'm_uom.json';
  static const String JSON_WARD = 'm_ward.json';
  static const String JSON_CUSTOMER_PRICE = 's_customer_price.json';
  static const String JSON_CUSTOMER_STOCK = 's_customer_stock.json';
  static const String JSON_CUSTOMER_VISIT = 's_customer_visit.json';
  static const String JSON_ORDER_DISCOUNT_RESULT =
      's_order_discount_result.json';
  static const String JSON_ORDER_DTL = 's_order_dtl.json';
  static const String JSON_ORDER_PROMOTION_RESULT =
      's_order_promotion_result.json';
  static const String JSON_ORDER = 's_order.json';
  static const String JSON_SHIFT_REPORT = 's_shift_report.json';
  static const String JSON_SURVEY_RESULT = 's_survey_result.json';
  static const String JSON_STOCK_BALANCE = 'w_stock_balance.json';
  static const String JSON_TRANSFER_DTL = 'w_transfer_dtl.json';
  static const String JSON_TRANSFER_REQUEST = 'w_transfer_request.json';
  static const String JSON_SHIFT = 'm_shift.json';
  static const String JSON_CUSTOMER_LIABILITIES = 'm_customer_liabilities.json';
  static const String JSON_SAP_ORDER = 's_sap_order.json';
  static const String JSON_SAP_ORDER_DTL = 's_sap_order_dtl.json';
  static const String JSON_DATA_DELETE = 'data_delete.json';
  static const String JSON_CUSTOMER_PROPERTY_MAAPING =
      'm_customer_property_mapping.json';
  static const String JSON_CUSTOMERS_GROUP_DETAIL =
      'm_customers_group_detail.json';
  static const String JSON_CUSTOMERS_GROUP = 'm_customers_group.json';
  static const String JSON_SALES_IN_PRICE_DTL = 'm_sales_in_price_dtl.json';
  static const String JSON_SALES_IN_PRICE_TARGET =
      'm_sales_in_price_target.json';
  static const String JSON_SALES_IN_PRICE = 'm_sales_in_price.json';
  static const String JSON_SAP_ORDER_DELIVERY = 's_sap_order_delivery.json';
  static const String JSON_PRODUCT_BRANCH_MAPPING =
      'm_product_branch_mapping.json';

  static const List<String> masterFiles = [
    JSON_AREA,
    JSON_BRAND,
    JSON_CATEGORY,
    JSON_DISTRICT,
    JSON_LANGUAGE,
    JSON_MESSAGES,
    JSON_PRODUCT,
    JSON_PRODUCT,
    JSON_PROVINCE,
    JSON_REASON,
    JSON_RESOURCE,
    JSON_SHIFT,
    JSON_UOM,
    JSON_WARD,
    JSON_PRODUCT_BRANCH_MAPPING
  ];

  static const List<String> salesmanFiles = [
    JSON_ACCOUNT_POSITION_LINK,
    JSON_ACCOUNT,
    JSON_CUSTOMER_ADDRESS,
    JSON_CUSTOMER,
    JSON_DISCOUNT_CONDITION,
    JSON_DISCOUNT_RESULT,
    JSON_DISCOUNT_SCHEME,
    JSON_DISCOUNT_TARGET,
    JSON_DISCOUNT,
    JSON_EMPLOYEE_POSITION_LINK,
    JSON_EMPLOYEE,
    JSON_PROMOTION_CONDITION,
    JSON_PROMOTION_RESULT,
    JSON_PROMOTION_SCHEME,
    JSON_PROMOTION_TARGET,
    JSON_PROMOTION,
    JSON_ROUTE_ASSIGNMENT,
    JSON_SURVEY_TARGET,
    JSON_SURVEY,
    JSON_TRANSFER_DTL,
    JSON_TRANSFER_REQUEST,
    JSON_CUSTOMER_LIABILITIES,
    JSON_SALES_IN_PRICE,
    JSON_SALES_IN_PRICE_DTL,
    JSON_SALES_IN_PRICE_TARGET,
    JSON_CUSTOMERS_GROUP,
    JSON_CUSTOMERS_GROUP_DETAIL,
    JSON_SAP_ORDER_DELIVERY
  ];

  static const List<String> updateFiles = [
    JSON_DATA_DELETE,
    JSON_BRAND,
    JSON_CUSTOMER_ADDRESS,
    JSON_CUSTOMER_LIABILITIES,
    JSON_CUSTOMER_PROPERTY_MAAPING,
    JSON_CUSTOMER_PROPERTY,
    JSON_CUSTOMER,
    JSON_CUSTOMERS_GROUP_DETAIL,
    JSON_CUSTOMERS_GROUP,
    JSON_DISCOUNT_CONDITION,
    JSON_DISCOUNT_RESULT,
    JSON_DISCOUNT_SCHEME,
    JSON_DISCOUNT_TARGET,
    JSON_DISCOUNT,
    JSON_MESSAGES,
    JSON_PROMOTION_CONDITION,
    JSON_PROMOTION_RESULT,
    JSON_PROMOTION_SCHEME,
    JSON_PROMOTION_TARGET,
    JSON_PROMOTION,
    JSON_RESOURCE,
    JSON_ROUTE_ASSIGNMENT,
    JSON_SALES_IN_PRICE_DTL,
    JSON_SALES_IN_PRICE_TARGET,
    JSON_SALES_IN_PRICE,
    JSON_SHIFT,
    JSON_SURVEY_TARGET,
    JSON_SURVEY,
    JSON_CUSTOMER_PRICE,
    JSON_CUSTOMER_STOCK,
    JSON_CUSTOMER_VISIT,
    JSON_ORDER_DISCOUNT_RESULT,
    JSON_ORDER_DTL,
    JSON_ORDER_PROMOTION_RESULT,
    JSON_ORDER,
    JSON_SHIFT_REPORT,
    JSON_STOCK_BALANCE,
    JSON_SALES_IN_PRICE,
    JSON_SALES_IN_PRICE_DTL,
    JSON_SALES_IN_PRICE_TARGET,
    JSON_CUSTOMERS_GROUP,
    JSON_CUSTOMERS_GROUP_DETAIL,
    JSON_SAP_ORDER_DELIVERY,
    JSON_PRODUCT_BRANCH_MAPPING
  ];
}
