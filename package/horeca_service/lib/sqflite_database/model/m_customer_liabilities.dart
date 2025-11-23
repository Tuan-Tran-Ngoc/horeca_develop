class CustomerLiabilities {
  int? customerLiabilitiesId;
  String? businessArea;
  String? customerCode;
  String? customerName;
  String? distributionChanel;
  String? invoiceDate;
  String? netDueDate;
  int? documentCurrencyValueOriginal;
  int? payment;
  int? documentCurrencyValueRemain;
  int? usedDebtLimit;
  int? orderDebtLimit;
  int? remainDebtLimit;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  CustomerLiabilities(
      {this.customerLiabilitiesId,
      this.businessArea,
      this.customerCode,
      this.customerName,
      this.distributionChanel,
      this.invoiceDate,
      this.netDueDate,
      this.documentCurrencyValueOriginal,
      this.payment,
      this.documentCurrencyValueRemain,
      this.usedDebtLimit,
      this.orderDebtLimit,
      this.remainDebtLimit,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate});

  CustomerLiabilities.fromJson(Map<String, dynamic> json) {
    customerLiabilitiesId = json['customer_liabilities_id'];
    businessArea = json['business_area'];
    customerCode = json['customer_code'];
    customerName = json['customer_name'];
    distributionChanel = json['distribution_chanel'];
    invoiceDate = json['invoice_date'];
    netDueDate = json['net_due_date'];
    documentCurrencyValueOriginal = json['document_currency_value_original'];
    payment = json['payment'];
    documentCurrencyValueRemain = json['document_currency_value_remain'];
    usedDebtLimit = json['used_debt_limit'];
    orderDebtLimit = json['order_debt_limit'];
    remainDebtLimit = json['remain_debt_limit'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['update_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  CustomerLiabilities.fromMap(Map<dynamic, dynamic> map) {
    customerLiabilitiesId = map['customer_liabilities_id'];
    businessArea = map['business_area'];
    customerCode = map['customer_code'];
    customerName = map['customer_name'];
    distributionChanel = map['distribution_chanel'];
    invoiceDate = map['invoice_date'];
    netDueDate = map['net_due_date'];
    documentCurrencyValueOriginal = map['document_currency_value_original'];
    payment = map['payment'];
    documentCurrencyValueRemain = map['document_currency_value_remain'];
    usedDebtLimit = map['used_debt_limit'];
    orderDebtLimit = map['order_debt_limit'];
    remainDebtLimit = map['remain_debt_limit'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['update_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }

  Map<String, dynamic> toMap() {
    return {
      'customer_liabilities_id': customerLiabilitiesId,
      'business_area': businessArea,
      'customer_code': customerCode,
      'customer_name': customerName,
      'distribution_chanel': distributionChanel,
      'invoice_date': invoiceDate,
      'net_due_date': netDueDate,
      'document_currency_value_original': documentCurrencyValueOriginal,
      'payment': payment,
      'document_currency_value_remain': documentCurrencyValueRemain,
      'used_debt_limit': usedDebtLimit,
      'order_debt_limit': orderDebtLimit,
      'remain_debt_limit': remainDebtLimit,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
