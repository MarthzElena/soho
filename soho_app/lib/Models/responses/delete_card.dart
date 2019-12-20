import 'dart:convert';

DeleteCardResponse deleteCardResponseFromJson(String str) =>
    DeleteCardResponse.fromJson(json.decode(str));

String deleteCardResponseToJson(DeleteCardResponse data) => json.encode(data.toJson());

class DeleteCardResponse {
  String id;
  String object;
  bool deleted;

  DeleteCardResponse({
    this.id,
    this.object,
    this.deleted,
  });

  factory DeleteCardResponse.fromJson(Map<String, dynamic> json) => DeleteCardResponse(
        id: json["id"],
        object: json["object"],
        deleted: json["deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "deleted": deleted,
      };
}
