import 'dart:convert';

AddNewCardRequest addNewCardRequestFromJson(String str) =>
    AddNewCardRequest.fromJson(json.decode(str));

Map addNewCardRequestToMap(AddNewCardRequest data) {
  return {
    "source" : data.source,
  };
}

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
