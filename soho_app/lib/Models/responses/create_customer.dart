// To parse this JSON data, do
//
//     final createCustomerRequest = createCustomerRequestFromJson(jsonString);

import 'dart:convert';

CreateCustomerResponse createCustomerResponseFromJson(String str) =>
    CreateCustomerResponse.fromJson(json.decode(str));

String createCustomerResponseToJson(CreateCustomerResponse data) => json.encode(data.toJson());

class CreateCustomerResponse {
  String id;
  String object;
  int accountBalance;
  dynamic address;
  int balance;
  int created;
  dynamic currency;
  String defaultSource;
  bool delinquent;
  String description;
  dynamic discount;
  dynamic email;
  String invoicePrefix;
  InvoiceSettings invoiceSettings;
  bool livemode;
  Metadata metadata;
  dynamic name;
  dynamic phone;
  List<dynamic> preferredLocales;
  dynamic shipping;
  Sources sources;
  Sources subscriptions;
  String taxExempt;
  Sources taxIds;
  dynamic taxInfo;
  dynamic taxInfoVerification;

  CreateCustomerResponse({
    this.id,
    this.object,
    this.accountBalance,
    this.address,
    this.balance,
    this.created,
    this.currency,
    this.defaultSource,
    this.delinquent,
    this.description,
    this.discount,
    this.email,
    this.invoicePrefix,
    this.invoiceSettings,
    this.livemode,
    this.metadata,
    this.name,
    this.phone,
    this.preferredLocales,
    this.shipping,
    this.sources,
    this.subscriptions,
    this.taxExempt,
    this.taxIds,
    this.taxInfo,
    this.taxInfoVerification,
  });

  factory CreateCustomerResponse.fromJson(Map<String, dynamic> json) => CreateCustomerResponse(
        id: json["id"],
        object: json["object"],
        accountBalance: json["account_balance"],
        address: json["address"],
        balance: json["balance"],
        created: json["created"],
        currency: json["currency"],
        defaultSource: json["default_source"],
        delinquent: json["delinquent"],
        description: json["description"],
        discount: json["discount"],
        email: json["email"],
        invoicePrefix: json["invoice_prefix"],
        invoiceSettings: InvoiceSettings.fromJson(json["invoice_settings"]),
        livemode: json["livemode"],
        metadata: Metadata.fromJson(json["metadata"]),
        name: json["name"],
        phone: json["phone"],
        preferredLocales: List<dynamic>.from(json["preferred_locales"].map((x) => x)),
        shipping: json["shipping"],
        sources: Sources.fromJson(json["sources"]),
        subscriptions: Sources.fromJson(json["subscriptions"]),
        taxExempt: json["tax_exempt"],
        taxIds: Sources.fromJson(json["tax_ids"]),
        taxInfo: json["tax_info"],
        taxInfoVerification: json["tax_info_verification"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "account_balance": accountBalance,
        "address": address,
        "balance": balance,
        "created": created,
        "currency": currency,
        "default_source": defaultSource,
        "delinquent": delinquent,
        "description": description,
        "discount": discount,
        "email": email,
        "invoice_prefix": invoicePrefix,
        "invoice_settings": invoiceSettings.toJson(),
        "livemode": livemode,
        "metadata": metadata.toJson(),
        "name": name,
        "phone": phone,
        "preferred_locales": List<dynamic>.from(preferredLocales.map((x) => x)),
        "shipping": shipping,
        "sources": sources.toJson(),
        "subscriptions": subscriptions.toJson(),
        "tax_exempt": taxExempt,
        "tax_ids": taxIds.toJson(),
        "tax_info": taxInfo,
        "tax_info_verification": taxInfoVerification,
      };
}

class InvoiceSettings {
  dynamic customFields;
  dynamic defaultPaymentMethod;
  dynamic footer;

  InvoiceSettings({
    this.customFields,
    this.defaultPaymentMethod,
    this.footer,
  });

  factory InvoiceSettings.fromJson(Map<String, dynamic> json) => InvoiceSettings(
        customFields: json["custom_fields"],
        defaultPaymentMethod: json["default_payment_method"],
        footer: json["footer"],
      );

  Map<String, dynamic> toJson() => {
        "custom_fields": customFields,
        "default_payment_method": defaultPaymentMethod,
        "footer": footer,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}

class Sources {
  String object;
  List<Datum> data;
  bool hasMore;
  int totalCount;
  String url;

  Sources({
    this.object,
    this.data,
    this.hasMore,
    this.totalCount,
    this.url,
  });

  factory Sources.fromJson(Map<String, dynamic> json) => Sources(
        object: json["object"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        hasMore: json["has_more"],
        totalCount: json["total_count"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "has_more": hasMore,
        "total_count": totalCount,
        "url": url,
      };
}

class Datum {
  String id;
  String object;
  dynamic addressCity;
  dynamic addressCountry;
  dynamic addressLine1;
  dynamic addressLine1Check;
  dynamic addressLine2;
  dynamic addressState;
  dynamic addressZip;
  dynamic addressZipCheck;
  String brand;
  String country;
  String customer;
  String cvcCheck;
  dynamic dynamicLast4;
  int expMonth;
  int expYear;
  String fingerprint;
  String funding;
  String last4;
  Metadata metadata;
  String name;
  dynamic tokenizationMethod;

  Datum({
    this.id,
    this.object,
    this.addressCity,
    this.addressCountry,
    this.addressLine1,
    this.addressLine1Check,
    this.addressLine2,
    this.addressState,
    this.addressZip,
    this.addressZipCheck,
    this.brand,
    this.country,
    this.customer,
    this.cvcCheck,
    this.dynamicLast4,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.funding,
    this.last4,
    this.metadata,
    this.name,
    this.tokenizationMethod,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        object: json["object"],
        addressCity: json["address_city"],
        addressCountry: json["address_country"],
        addressLine1: json["address_line1"],
        addressLine1Check: json["address_line1_check"],
        addressLine2: json["address_line2"],
        addressState: json["address_state"],
        addressZip: json["address_zip"],
        addressZipCheck: json["address_zip_check"],
        brand: json["brand"],
        country: json["country"],
        customer: json["customer"],
        cvcCheck: json["cvc_check"],
        dynamicLast4: json["dynamic_last4"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        fingerprint: json["fingerprint"],
        funding: json["funding"],
        last4: json["last4"],
        metadata: Metadata.fromJson(json["metadata"]),
        name: json["name"],
        tokenizationMethod: json["tokenization_method"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "address_city": addressCity,
        "address_country": addressCountry,
        "address_line1": addressLine1,
        "address_line1_check": addressLine1Check,
        "address_line2": addressLine2,
        "address_state": addressState,
        "address_zip": addressZip,
        "address_zip_check": addressZipCheck,
        "brand": brand,
        "country": country,
        "customer": customer,
        "cvc_check": cvcCheck,
        "dynamic_last4": dynamicLast4,
        "exp_month": expMonth,
        "exp_year": expYear,
        "fingerprint": fingerprint,
        "funding": funding,
        "last4": last4,
        "metadata": metadata.toJson(),
        "name": name,
        "tokenization_method": tokenizationMethod,
      };
}
