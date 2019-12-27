import 'dart:convert';

GetAllCardsResponse getAllCardsResponseFromJson(String str) =>
    GetAllCardsResponse.fromJson(json.decode(str));

String getAllCardsResponseToJson(GetAllCardsResponse data) => json.encode(data.toJson());

class GetAllCardsResponse {
  String object;
  List<Datum> data;
  bool hasMore;
  String url;

  GetAllCardsResponse({
    this.object,
    this.data,
    this.hasMore,
    this.url,
  });

  factory GetAllCardsResponse.fromJson(Map<String, dynamic> json) => GetAllCardsResponse(
        object: json["object"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        hasMore: json["has_more"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "has_more": hasMore,
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

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}
