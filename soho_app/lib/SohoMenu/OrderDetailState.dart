import 'package:scoped_model/scoped_model.dart';

class OrderDetailState extends Model {

  static const double NO_TIP = 0.0;
  static const double TIP_TEN = 10.0;
  static const double TIP_FIFTEEN = 15.0;
  static const double TIP_TWENTY = 20.0;

  double currentTip = 0.0;

  bool isTipOther() {
    return currentTip != NO_TIP && currentTip != TIP_TEN && currentTip != TIP_FIFTEEN && currentTip != TIP_TWENTY;
  }

  bool isTipTen() {
    return currentTip == TIP_TEN;
  }
  bool isTipFifteen() {
    return currentTip == TIP_FIFTEEN;
  }
  bool isTipTwenty() {
    return currentTip == TIP_TWENTY;
  }


  void updateTip(double toValue) {
    currentTip = toValue;
    notifyListeners();
  }

}