// To parse this JSON data, do
//
//     final createCustomerRequest = createCustomerRequestFromJson(jsonString);

import 'dart:convert';

CreateCustomerRequest createCustomerRequestFromJson(String str) =>
    CreateCustomerRequest.fromJson(json.decode(str));

Map createCustomerRequestToMap(CreateCustomerRequest data) {
  return {
    "description" : data.description,
    "source" : data.source,
    "email" : data.email,
  };
}

class CreateCustomerRequest {
  String description;
  String source;
  String email;

  CreateCustomerRequest({
    this.description,
    this.source,
    this.email
  });

  factory CreateCustomerRequest.fromJson(Map<String, dynamic> json) => CreateCustomerRequest(
        description: json["description"],
        source: json["source"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "source": source,
        "email": email,
      };
}
