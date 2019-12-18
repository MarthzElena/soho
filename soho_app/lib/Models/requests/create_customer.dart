// To parse this JSON data, do
//
//     final createCustomerRequest = createCustomerRequestFromJson(jsonString);

import 'dart:convert';

CreateCustomerRequest createCustomerRequestFromJson(String str) =>
    CreateCustomerRequest.fromJson(json.decode(str));

String createCustomerRequestToJson(CreateCustomerRequest data) => json.encode(data.toJson());

class CreateCustomerRequest {
  String description;
  String source;

  CreateCustomerRequest({
    this.description,
    this.source,
  });

  factory CreateCustomerRequest.fromJson(Map<String, dynamic> json) => CreateCustomerRequest(
        description: json["description"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "source": source,
      };
}
