// To parse this JSON data, do
//
//     final chargeCustomerRequest = chargeCustomerRequestFromJson(jsonString);

import 'dart:convert';

ChargeCustomerRequest chargeCustomerRequestFromJson(String str) =>
    ChargeCustomerRequest.fromJson(json.decode(str));

Map chargeCustomerRequestToMap(ChargeCustomerRequest data) {
  return {
    "amount" : data.amount,
    "currency" : data.currency,
    "description" : data.description,
    "source" : data.source,
    "customer" : data.customer,
  };
}

class ChargeCustomerRequest {
  String amount;
  String currency;
  String description;
  String source;
  String customer;

  ChargeCustomerRequest({
    this.amount,
    this.currency,
    this.description,
    this.source,
    this.customer,
  });

  factory ChargeCustomerRequest.fromJson(Map<String, dynamic> json) => ChargeCustomerRequest(
        amount: json["amount"],
        currency: json["currency"],
        description: json["description"],
        source: json["source"],
        customer: json["customer"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "currency": currency,
        "description": description,
        "source": source,
        "customer": customer,
      };
}
