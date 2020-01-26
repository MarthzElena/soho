import 'dart:convert';

UpdateCardRequest updateCardRequestFromJson(String str) =>
    UpdateCardRequest.fromJson(json.decode(str));

Map updateCardRequestToMap(UpdateCardRequest data) {
  if (data.name.isNotEmpty && data.expMonth.isNotEmpty && data.expYear.isNotEmpty) {
    // Update everything
    return {
      "name" : data.name,
      "exp_month" : data.expMonth,
      "exp_year" : data.expYear,
    };
  } else if (data.expYear.isNotEmpty && data.expMonth.isNotEmpty) {
    // Only update date
    return {
      "exp_month" : data.expMonth,
      "exp_year" : data.expYear,
    };
  } else {
    // Only update name
    return {
      "name" : data.name,
    };
  }
}

class UpdateCardRequest {
  String name;
  String expMonth;
  String expYear;

  UpdateCardRequest({
    this.name = "",
    this.expMonth = "",
    this.expYear = "",
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
