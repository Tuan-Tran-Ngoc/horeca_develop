String columnVersion = 'version';
String columnStatus = 'status';
String columnUpdatedBy = 'updated_by';
String columnCreatedDate = 'created_date';
String columnUpdatedDate = 'updated_date';
String columnCreatedBy = 'created_by';

String tableDistrict = 'm_district';
String columnDistrictId = 'district_id';
String columnDistrictName = 'district_name';
String columnDistrictCode = 'district_code';
// String columnProvinceId = 'province_id';

String tableCategory = 'm_category';
String columnCategoryName = 'category_name';
String columnCategoryId = 'category_id';
String columnCategoryCode = 'category_code';

String tableArea = 'm_area';
String columnAreaId = 'area_id';
String columnAreaName = 'area_name';
String columnParentId = 'parent_id';
String columnAreaCode = 'area_code';
String columnLevelCode = 'level_code';

String tableCustomerAddress = 'm_customer_address';
String columnCustomerAddressId = 'customer_address_id';
String columnCustomerId = 'customer_id';
String columnAddressDetail = 'address_detail';
String columnStreetName = 'street_name';
String columnWardId = 'ward_id';
String columnFaxNo = 'fax_no';
String columnDefaultAddress = 'default_address';
String columnAddressCode = 'address_code';
String columnOldAddressCode = 'old_address_code';
String columnAddressStartDate = 'address_start_date';
String columnAddressEndDate = 'address_end_date';

String tableCustomer = 'm_customer';
String columnRepresentativeName = 'representative_name';
String columnIsTax = 'is_tax';
// String columnAreaId = 'area_id';
String columnDistributorId = 'distributor_id';
String columnCustomerName = 'customer_name';
// String columnCustomerId = 'customer_id';
String columnIsUsed = 'is_use';
String columnCustomerCode = 'customer_code';

// String tableMessages = 'survey';
// String columnMessageId = 'message_id';
// String columnMessageCode = 'message_code';
// String columnMessageString = 'message_string';
// String columnReuseFlag = 'reuse_flag';

String tableUOM = 'm_uom';
String columnUomId = 'uom_id';
String columnUomCode = 'uom_code';
String columnUomName = 'uom_name';

String tableProductType = 'm_product_type';
String columnProductTypeId = 'product_type_id';
String columnTypeName = 'type_name';
String columnTypeCode = 'type_code';

//m_brand
String tableBrand = 'm_brand';

String columnBrandCd = 'brand_cd';
String columnBrandName = 'brand_name';
String columnBrandId = 'brand_id';
String columnBrandImg = 'brand_img';

String tableProduct = 'm_product';
String columnProductId = 'product_id';
String columnProductCd = 'product_cd';
// String columnProductTypeId = 'produc_type_id';
String columnProductName = 'product_name';
String columnPriceCost = 'price_cost';
String columnPriority = 'priority';
// String columnCategoryId = 'category_id';
// String columnUomId = 'uom_id';
// String columnBrandId = 'brand_id';
String columnProductImg = 'product_img';
String columnIsSalable = 'is_salable';

String tableWard = 'm_ward';
// String columnWardId = 'ward_id';
String columnWardName = 'ward_name';
String columnWardCode = 'ward_code';
// String columnDistrictId = 'district_id';

String tableProvince = 'm_province';

String columnProvinceId = 'province_id';
String columnProvinceName = 'province_name';
String columnProvinceCode = 'province_code';

// String columnCustomerId = 'customer_id';
String columnBaPositionId = 'ba_position_id';
// String columnCustomerVisitId = 'customer_visit_id';
// String columnProductId = 'product_id';
String columnAvailableStock = 'available_stock';
String columnAllocateDate = 'allocate_date';
String columnLastUpdate = 'last_update';

String columnCustomerVisitId = 'customer_visit_id';
String columnShiftReportId = 'shift_report_id';
// String columnCustomerId = 'customer_id';
// String columnBaPositionId = 'ba_position_id';
String columnEmployeeName = 'employee_name';
String columnSupPositionId = 'sup_position_id';
String columnCityLeaderPositionId = 'city_leader_position_id';
String columnVisitDate = 'visit_date';
String columnStartTime = 'start_time';
String columnEndTime = 'end_time';
String columnShiftCode = 'shift_code';
String columnTotalCashBack = 'total_cash_back';
String columnTotalCollection = 'total_collection';
String columnNewMembership = 'new_membership';
String columnSignature = 'signature';
String columnVisitStatus = 'visit_status';
String columnLongitude = 'longitude';
String columnLatitude = 'latitude';
String columnReason = 'reason';
String columnVisitTimes = 'visit_times';
String columnParentCustomerVisitId = 'parent_customer_visit_id';
String columnIsSample = 'is_sample';
String columnIsStockCheckCompleted = 'is_stock_check_completed';
String columnIsSurveyCompleted = 'is_survey_completed';
String columnTotalApproached = 'total_approached';
String columnTotalSmoker = 'total_smoker';
String columnTotalGift = 'total_gift';

String tableStockBalance = 'w_stock_balance';
String columnStockBalanceId = 'stock_balance_id';
// String columnProductId = 'product_id';
String columnAllocatingStoc = 'allocating_stock';
// String columnAvailableStock = 'available_stock';
String columnIsGood = 'is_good';
String columnIsReceived = 'is_received';

String columnOrderId = 'order_id';
String columnOrderCd = 'order_cd';
// String columnCustomerId = 'customer_id';
// String columnCustomerVisitId = 'customer_visit_id';
// String columnBaPositionId = 'ba_position_id';
// String columnEmployeeId = 'employee_id';
// String columnEmployeeName = 'employee_name';
// String columnSupPositionId = 'sup_position_id';
// String columnCityLeaderPositionId = 'city_leader_position_id';
String columnBuyerTelNo = 'buyer_tel_no';
String columnOrderDate = 'order_date';
String columnTotalAmount = 'total_amount';
String columnVat = 'vat';
String columnTotalDiscount = 'total_discount';
String columnCashBackAmount = 'cash_back_amount';
String columnCollection = 'collection';
String columnRemark = 'remark';
String columnGrandTotalAmount = 'grand_total_amount';
String columnOrderType = 'order_type';
// String columnVisitTimes = 'visit_times';
String columnSapStatus = 'sap_status';
String columnSapOrderNo = 'sap_order_no';

String tableOrderDetail = 's_order_dtl';
String columnOrderDetailId = 'order_dtl_id';
String columnOrderDtlIdSync = 'order_dtl_id_sync';
// String columnOrderId = 'order_id';
// String columnProductId = 'product_id';
String columnStockType = 'stock_type';
String columnQuantity = 'qty';
String columnSalesPrice = 'sales_price';
String columnSalesInPrice = 'sales_in_price';
// String columnTotalAmount = 'total_amount';
// String columnCashBackAmount = 'cash_back_amount';
// String columnCollection = 'collection';
//m_resource
String tableResource = 'm_resource';
String columnResourceId = 'resource_id';
String columnCategoryCd = 'category_cd';
String columnResourceCd = 'resource_cd';
String columnValue1 = 'value1';
String columnValue2 = 'value2';
String columnValue3 = 'value3';
String columnValue4 = 'value4';
String columnValue5 = 'value5';
String columnResourceType = 'resource_type';
String columnDeleteFlg = 'delete_flg';

//s_shift_report
String tableShiftReport = 's_shift_report';

String columnShiftReportIdSync = 'shift_report_id_sync';
String columnWorkingDate = 'working_date';
String columnNewSmoker = 'new_smoker';

//m_survey
String tableSurvey = 'm_survey';

String columnSurveyId = 'survey_id';
String columnSurveyCode = 'survey_code';
String columnSurveyTitle = 'survey_title';
String columnDescription = 'description';
String columnStartDate = 'start_date';
String columnEndDate = 'end_date';

//m_route_assignment
String tableRouteAssignment = 'm_route_assignment';

String columnRouteId = 'route_id';
String columnDayOfWeek = 'day_of_week';
String columnFrequency = 'frequency';
String columnIsUpdate = 'is_update';

//m_account
String tableAccount = 'm_account';

String columnAccountId = 'account_id';
String columnAccountNonExpired = 'account_non_expired';
String columnAccountNonLocked = 'account_non_locked';
String columnCredentialsNonExpired = 'credentials_non_expired';
String columnAccountRuleDefinitionId = 'account_rule_definition_id';
String columnForceChangePassword = 'force_change_password';

//m_account_offline
String tableAccountOffline = 'm_account_offline';

String columnAccountOfflineId = 'account_offline_id';
String columnUsername = 'username';
String columnPassword = 'password';
String columnLastLogin = 'last_login';
String columnOauthString = 'oauth_string';

//m_account_position_link
String tableAccountPositionLink = 'm_account_position_link';

String columnPositionId = 'position_id';

//m_area_level
String tableAreaLevel = 'm_area_level';

String columnAreaLevelId = 'm_area_level';
String colmnLevelCode = 'level_code';
String columnLevelName = 'level_name';
String columnIsSmallest = 'is_smallest';

//m_discount
String tableDiscount = 'm_discount';

String columnDiscountId = 'discount_id';
String columnDiscountCode = 'discount_code';
String columnDiscountName = 'discount_name';
String columnConditionType = 'condition_type';

//m_discount_condition
String tableDiscountCondition = 'm_discount_condition';

String columnDiscountConditionId = 'discount_condition_id';
String columnTotalType = 'total_type';
String columnConditionQty = 'condition_qty';

//m_discount_scheme
String tableDiscountScheme = 'm_discount_scheme';

String columnDiscountSchemeId = 'discount_scheme_id';

//m_discount_target
String tableDiscountTarget = 'm_discount_target';

String columnDiscountTargetId = 'discount_target_id';
String columnTargetType = 'target_type';
String columnTargetId = 'target_id';

//m_discount_result
String tableDiscountResult = 'm_discount_result';

String columnDiscountResultId = 'discount_result_id';
String columnDiscountType = 'discount_type';

//m_employee
String tableEmployee = 'm_employee';

String columnEmployeeId = 'employee_id';
String columnEmployeeCode = 'employee_code';
String columnPhoneNumber = 'phone_number';
String columnEmail = 'email';
String columnBirthdate = 'birthdate';

//m_employee_position_link
String tableEmployeePositionLink = 'm_employee_position_link';

String columnEmployeePositionLinkId = 'employee_position_link_id';

//m_language
String tableLanguage = 'm_language';

String columnLanguageCode = 'language_code';
String columnCountryCode = 'country_code';
String columnLanguageName = 'language_name';
String columnRegionCode = 'region_code';

//m_membership
String tableMembership = 'm_membership';

String columnMembershipRecordId = 'membership_record_id';
String columnMembershipId = 'membership_id';
String columnMembershipCode = 'membership_code';
String columnMembershipName = 'membership_name';
String columnTelNo = 'tel_no';
String columnTotalPoint = 'total_point';
String columnUsedPoint = 'used_point';
String columnCurrentPoint = 'current_point';

//m_messages
String tableMessages = 'm_messages';

String columnMessageId = 'message_id';
String columnMessageCode = 'message_code';
String columnMessageString = 'message_string';
String columnModuleResource = 'module_resource';
String columnReuseFlag = 'reuse_flag';

//m_promotion
String tablePromotion = 'm_promotion';

String columnPromotionId = 'promotion_id';
String columnPromotionCode = 'promotion_code';
String columnPromotionName = 'promotion_name';
String columnPromotionType = 'promotion_type';

//m_promotion_scheme
String tablePromotionScheme = 'm_promotion_scheme';

String columnPromotionSchemeId = 'promotion_scheme_id';

//m_promotion_condition
String tablePromotionCondition = 'm_promotion_condition';

String columnPromotionConditionId = 'promotion_condition_id';

//m_promotion_target
String tablePromotionTarget = 'm_promotion_target';

String columnPromotionTargetId = 'promotion_target_id';

//m_promotion_result
String tablePromotionResult = 'm_promotion_result';

String columnPromotionResultId = 'promotion_result_id';
String columnResultQty = 'result_qty';

//m_reason
String tableReason = 'm_reason';

String columnReasonId = 'reason_id';
String columnReasonType = 'reason_type';
String columnReasonContent = 'reason_content';
String columnSort = 'sort';
String columnIsOther = 'is_other';

//m_survey_target
String tableSurveyTarget = 'm_survey_target';

String columnSurveyTargetId = 'survey_target_id';

//m_sync_offlinep
String tableSyncOffline = 'm_sync_offline';

String columnSyncOfflineId = 'sync_offline_id';
String columnRequestId = 'request_id';
String columnType = 'type';
String columnRelatedId = 'related_id';
String columnSequence = 'sequence';

//s_customer_price
String tableCustomerPrice = 's_customer_price';

String columnCustomerPriceId = 'customer_price_id';
String columnCustomerPriceIdSync = 'customer_price_id_sync';
String columnPrice = 'price';

//s_order_discount_result
String tableOrderDiscountResult = 's_order_discount_result';

String columnOrderDiscountResultId = 'discount_result_id';
String columnOrderDiscountResultIdSync = 'discount_result_id_sync';
String columnDiscountValue = 'discount_value';

//s_order_promotion_result
String tableOrderPromotionResult = 's_order_promotion_result';

String columnOrderPromotionResultId = 'promotion_result_id';
String columnOrderPromotionResultIdSync = 'promotion_result_id_sync';
String columnQty = 'qty';

//s_survey_result
String tableSurveyResult = 's_survey_result';

String columnSurveyResultId = 'survey_result_id';
String columnSurveyResultIdSync = 'survey_result_id_sync';
String columnSurveyQuestionId = 'survey_question_id';
String columnSurveyAnswerId = 'survey_answer_id';
String columnSurveyAnswer = 'survey_answer';
String columnSurveyDate = 'survey_date';
String columnResultDetail = 'result_detail';

//sync_manage_log
String tableSyncManageLog = 'sync_manage_log';

String columnLogId = 'log_id';
String columnImeiDevice = 'imei_device';
String columnObjectFail = 'object_fail';
String columnLog = 'log';

//w_transfer_request
String tableTransferRequest = 'w_transfer_request';

String columnTransferRequestId = 'transfer_request_id';
String columnTransferCode = 'transfer_code';
String columnTransferName = 'transfer_name';
String columnPositionTransferId = 'position_transfer_id';
String columnPositionTransferFromId = 'position_transfer_from_id';
String columnDateTransfer = 'date_transfer';
String columnTypeTransfer = 'type_transfer';
String columConfirmedDate = 'confirmed_date';

//w_transfer_dtl
String tableTransferDtl = 'w_transfer_dtl';

String columnTransferDtlId = 'w_transfer_dtl_id';
String columnTransferQty = 'transfer_qty';

//m_shift
String tableShift = 'm_shift';

String columnShiftId = 'shift_id';
String columnShiftName = 'shift_name';

//m_customer_liabilities
String tableCustomerLiabilities = 'm_customer_liabilities';

String columnCustomerLibilitiesId = 'customer_liabilities_id';
String columnBusinessArea = 'business_area';
String columnDistributionChanel = 'distribution_chanel';
String columnInvoiceDate = 'invoice_date';
String columnNetDueDate = 'net_due_date';
String columnDocumentCurrencyValueOriginal = 'document_currency_value_original';
String columnPayment = 'payment';
String columnDocumentCurrencyValueRemain = 'document_currency_value_remain';
String columnUsedDebtLimit = 'used_debt_limit';
String columnOrderDebtLimit = 'order_debt_limit';
String columnRemainDebtLimit = 'remain_debt_limit';

// s_order
String tableOrder = 's_order';
String columnOrderIdSync = 'order_id_sync';
String columnPoNo = 'po_no';
String columnExpectDeliveryDate = 'expect_delivery_date';
String columnHorecaStatus = 'horeca_status';

// s_sap_order
String tableSapOrder = 's_sap_order';

String columnOrderNo = 'order_no';
String columnCustomerCd = 'customer_cd';
String columnShipToPartyName = 'ship_to_party_name';
String columnShipToParty = 'ship_to_party';
String columnTotalNetValue = 'total_net_value';
String columnPoHrc = 'po_hrc';

// s_sap_order_dtl
String tableSapOrderDtl = 's_sap_order_dtl';

String columnItemCategory = 'item_category';
String columnShippedQty = 'shipped_qty';
String columnUnit = 'unit';
String columnUnitPrice = 'unit_price';
String columnDiscount = 'discount';
String columnUnitPriceAfterDiscount = 'unit_price_after_discount';
String columnNetValue = 'net_value';
String columnTaxAmount = 'tax_amount';

// s_customer_visit
String tableCustomerVisit = 's_customer_visit';
String columnCustomerVisitIdSync = 'customer_visit_id_sync';

// s_customer_stock
String tableCustomerStock = 's_customer_stock';
String columnCustomerStockId = 'customer_stock_id';
String columnCustomerStockIdSync = 'customer_stock_id_sync';

// m_customer_property
String tableCustomerProperty = 'm_customer_property';
String columnCustomerPropertyId = 'customer_property_id';
String columnPropertyTypeCode = 'property_type_code';
String columnCustomerPropertyCode = 'customer_property_code';
String columnCustomerPropertyName = 'customer_property_name';

// m_customer_property_mapping
String tableCustomerPropertyMapping = 'm_customer_property_mapping';
String columnPropertyMappingId = 'property_mapping_id';

// m_customers_group
String tableCustomersGroup = 'm_customers_group';
String columnCustomersGroupId = 'customers_group_id';
String columnCustomersGroupCode = 'customers_group_code';
String columnCustomersGroupName = 'customers_group_name';
String columnBranchId = 'branch_id';

// m_customers_group_detail
String tableCustomersGroupDetail = 'm_customers_group_detail';
String columnCustomersGroupDetailId = 'customers_group_detail_id';

//m_sales_in_price
String tableSalesInPrice = 'm_sales_in_price';
String columnSalesInPriceId = 'sales_in_price_id';
String columnPriceCode = 'price_code';
String columnPriceName = 'price_name';

//m_sales_in_price_dtl
String tableSalesInPriceDtl = 'm_sales_in_price_dtl';
String columnSalesInPriceDtlId = 'sales_in_price_dtl_id';
String columnPriceVat = 'price_vat';

//m_sales_in_price_target
String tableSalesInPriceTarget = 'm_sales_in_price_target';
String columnSalesInPriceTargetId = 'sales_in_price_target_id';

//s_sap_order_delivery
String tableSapOrderDelivery = 's_sap_order_delivery';
String columnOrderDeliveryId = 'order_delivery_id';
String columnDeliveryNo = 'delivery_no';
String columnDeliveryDate = 'delivery_date';
String columnDeliveryStatus = 'delivery_status';
String columnTruckId = 'truck_id';

//w_transfer_update_log
String tableTransferUpdateLog = 'w_transfer_update_log';
String columnTransferUpdateLogId = 'transfer_update_log_id';
String columnDateLastestUpdate = 'date_lastest_update';

//m_product_branch_mapping
String tableProductBranchMapping = 'm_product_branch_mapping';
String columnProductBranchMappingId = 'product_branch_mapping_id';
