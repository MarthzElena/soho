import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/ui/widgets/drawer/drawer_anon.dart';
import 'package:soho_app/ui/widgets/drawer/drawer_logged.dart';

class HomePageState extends Model {

  Widget drawer = Application.currentUser == null ? NoUserMenuWidget() : LoggedInUserMenuWidget(photoUrl: Application.currentUser.photoUrl);

  void updateDrawer() {
    drawer = Application.currentUser == null ? NoUserMenuWidget() : LoggedInUserMenuWidget(photoUrl: Application.currentUser.photoUrl);
    notifyListeners();
  }

  List<SohoOrderObject> getOrderList() {
    List<SohoOrderObject> result = List<SohoOrderObject>();
    if (Application.currentUser != null) {
      for (var order in Application.currentUser.pastOrders) {
        if (order.selectedProducts.isNotEmpty) {
          result.add(order);
        }
      }
      for (var order in Application.currentUser.ongoingOrders) {
        if (order.selectedProducts.isNotEmpty) {
          result.add(order);
        }
      }
    }
    return result;
  }

}