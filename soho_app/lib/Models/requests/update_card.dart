import 'dart:convert';

UpdateCardRequest updateCardRequestFromJson(String str) =>
    UpdateCardRequest.fromJson(json.decode(str));

String updateCardRequestToJson(UpdateCardRequest data) => json.encode(data.toJson());

class UpdateCardRequest {
  String name;
  String expMonth;
  String expYear;

  UpdateCardRequest({
    this.name,
    this.expMonth,
    this.expYear,
  });

  factory UpdateCardRequest.fromJson(Map<String, dynamic> json) => UpdateCardRequest(
        name: json["name"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "exp_month": expMonth,
        "exp_year": expYear,
      };
}
