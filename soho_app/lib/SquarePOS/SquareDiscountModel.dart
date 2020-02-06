const discountFixedAmount = "FIXED_AMOUNT";
const discountFixedPercentage = "FIXED_PERCENTAGE";

class SquareDiscountModelPercentage {
  String type;
  String id;
  String updatedAt;
  int version;
  bool isDeleted;
  bool presentAtAllLocations;
  DiscountDataPercentage discountDataPercentage;

  SquareDiscountModelPercentage({
    this.type,
    this.id,
    this.updatedAt,
    this.version,
    this.isDeleted,
    this.presentAtAllLocations,
    this.discountDataPercentage,
  });

  factory SquareDiscountModelPercentage.fromJson(Map<String, dynamic> json) => SquareDiscountModelPercentage(
    type: json["type"],
    id: json["id"],
    updatedAt: json["updated_at"],
    version: json["version"],
    isDeleted: json["is_deleted"],
    presentAtAllLocations: json["present_at_all_locations"],
    discountDataPercentage: DiscountDataPercentage.fromJson(json["discount_data"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
    "updated_at": updatedAt,
    "version": version,
    "is_deleted": isDeleted,
    "present_at_all_locations": presentAtAllLocations,
    "discount_data": discountDataPercentage.toJson(),
  };
}

class SquareDiscountModelFixed {
  String type;
  String id;
  String updatedAt;
  int version;
  bool isDeleted;
  bool presentAtAllLocations;
  DiscountDataFixed discountDataFixed;

  SquareDiscountModelFixed({
    this.type,
    this.id,
    this.updatedAt,
    this.version,
    this.isDeleted,
    this.presentAtAllLocations,
    this.discountDataFixed,
  });

  factory SquareDiscountModelFixed.fromJson(Map<String, dynamic> json) => SquareDiscountModelFixed(
    type: json["type"],
    id: json["id"],
    updatedAt: json["updated_at"],
    version: json["version"],
    isDeleted: json["is_deleted"],
    presentAtAllLocations: json["present_at_all_locations"],
    discountDataFixed: DiscountDataFixed.fromJson(json["discount_data"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
    "updated_at": updatedAt,
    "version": version,
    "is_deleted": isDeleted,
    "present_at_all_locations": presentAtAllLocations,
    "discount_data": discountDataFixed.toJson(),
  };
}

class DiscountDataPercentage {
  String name;
  String discountType;
  String percentage;
  String applicationMethod;
  String modifyTaxBasis;

  DiscountDataPercentage({
    this.name,
    this.discountType,
    this.percentage,
    this.applicationMethod,
    this.modifyTaxBasis
  });

  factory DiscountDataPercentage.fromJson(Map<String, dynamic> json) => DiscountDataPercentage(
    name: json["name"],
    discountType: json["discount_type"],
    percentage: json["percentage"],
    applicationMethod: json["application_method"],
    modifyTaxBasis: json["modify_tax_basis"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "discount_type": discountType,
    "percentage": percentage,
    "application_method": applicationMethod,
    "modify_tax_basis": modifyTaxBasis,
  };
}

class DiscountDataFixed {
  String name;
  String discountType;
  AmountMoney amountMoney;
  String applicationMethod;
  String modifyTaxBasis;

  DiscountDataFixed({
    this.name,
    this.discountType,
    this.amountMoney,
    this.applicationMethod,
    this.modifyTaxBasis
  });

  factory DiscountDataFixed.fromJson(Map<String, dynamic> json) => DiscountDataFixed(
    name: json["name"],
    discountType: json["discount_type"],
    amountMoney: AmountMoney.fromJson(json["amount_money"]),
    applicationMethod: json["application_method"],
    modifyTaxBasis: json["modify_tax_basis"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "discount_type": discountType,
    "amount_money": amountMoney.toJson(),
    "application_method": applicationMethod,
    "modify_tax_basis": modifyTaxBasis,
  };
}

class AmountMoney {
  int amount;
  String currency;

  AmountMoney({
    this.amount,
    this.currency,
  });

  factory AmountMoney.fromJson(Map<String, dynamic> json) => AmountMoney(
    amount: json["amount"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "currency": currency,
  };
}

