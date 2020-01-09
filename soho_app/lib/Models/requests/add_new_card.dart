import 'dart:convert';

AddNewCardRequest addNewCardRequestFromJson(String str) =>
    AddNewCardRequest.fromJson(json.decode(str));

String addNewCardRequestToJson(AddNewCardRequest data) => json.encode(data.toJson());

class AddNewCardRequest {
  String source;

  AddNewCardRequest({
    this.source,
  });

  factory AddNewCardRequest.fromJson(Map<String, dynamic> json) => AddNewCardRequest(
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "source": source,
      };
}
