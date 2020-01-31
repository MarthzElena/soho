import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/ui/widgets/drawer/drawer_anon.dart';
import 'package:soho_app/ui/widgets/drawer/drawer_logged.dart';

class RecentOrdersElement {
  String categoryName;
  String name;
  String photoUrl;
  String orderedAt;
  bool isCodeValid;
  RecentOrdersElement(this.categoryName, this.name, this.photoUrl, this.orderedAt, this.isCodeValid);
}

class HomePageState extends Model {

  final int maxItems = 10;
  Widget drawer = Application.currentUser == null ? NoUserMenuWidget() : LoggedInUserMenuWidget(photoUrl: Application.currentUser.photoUrl);

  void updateState() {
    notifyListeners();
  }

  void updateDrawer() {
    drawer = Application.currentUser == null ? NoUserMenuWidget() : LoggedInUserMenuWidget(photoUrl: Application.currentUser.photoUrl);
    notifyListeners();
  }

  List<RecentOrdersElement> getOrderList() {
    List<RecentOrdersElement> result = List<RecentOrdersElement>();
    var currentUser = Application.currentUser;
    if (currentUser != null) {
      // First attempt to add from ongoing orders
      for (var order in currentUser.ongoingOrders) {
        for (var product in order.selectedProducts) {
          var element = RecentOrdersElement(product.categoryName, product.name, product.photoUrl, order.getCompletedDateShort(), true);
          if (result.length < maxItems) {
            result.add(element);
          } else {
            return result;
          }
        }
      }

      // Attempt to add from past orders
      for (var order in currentUser.pastOrders) {
        for (var product in order.selectedProducts) {
          var element = RecentOrdersElement(product.categoryName, product.name, product.photoUrl, order.getCompletedDateShort(), true);
          if (result.length < maxItems) {
            result.add(element);
          } else {
            return result;
          }
        }
      }
    }

    return result;
  }

}