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

  Widget drawer = Application.currentUser == null ? NoUserMenuWidget() : LoggedInUserMenuWidget(photoUrl: Application.currentUser.photoUrl);

  void updateDrawer() {
    drawer = Application.currentUser == null ? NoUserMenuWidget() : LoggedInUserMenuWidget(photoUrl: Application.currentUser.photoUrl);
    notifyListeners();
  }

  List<RecentOrdersElement> getOrderList() {
    List<RecentOrdersElement> result = List<RecentOrdersElement>();
    var currentUser = Application.currentUser;
    if (currentUser != null) {
      if (currentUser.ongoingOrders.isNotEmpty) {
        if (currentUser.ongoingOrders.length >= 2) {
          var last = currentUser.ongoingOrders.elementAt(1);
          for (var product in last.selectedProducts) {
            var lastElement = RecentOrdersElement(product.categoryName, product.name, product.photoUrl, last.getCompletedDateShort(), true);
            result.add(lastElement);
          }
        }
        if (currentUser.ongoingOrders.length >= 1) {
          var last = currentUser.ongoingOrders.elementAt(0);
          for (var product in last.selectedProducts) {
            var lastElement = RecentOrdersElement(product.categoryName, product.name, product.photoUrl, last.getCompletedDateShort(), true);
            result.add(lastElement);
          }
        }
      }

      // If result already has values return that
      if (result.isNotEmpty) {
        return result;
      }

      // Attempt to add from past orders
      if (currentUser.pastOrders.isNotEmpty) {
        if (currentUser.pastOrders.length >= 2) {
          var last = currentUser.ongoingOrders.elementAt(1);
          for (var product in last.selectedProducts) {
            var lastElement = RecentOrdersElement(product.categoryName, product.name, product.photoUrl, last.getCompletedDateShort(), false);
            result.add(lastElement);
          }
        }
        if (currentUser.pastOrders.length >= 1) {
          var last = currentUser.ongoingOrders.elementAt(0);
          for (var product in last.selectedProducts) {
            var lastElement = RecentOrdersElement(product.categoryName, product.name, product.photoUrl, last.getCompletedDateShort(), false);
            result.add(lastElement);
          }
        }
      }

    }
    return result;
  }

}