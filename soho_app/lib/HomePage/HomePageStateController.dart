import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/ui/widgets/drawer/drawer_anon.dart';
import 'package:soho_app/ui/widgets/drawer/drawer_logged.dart';

class HomePageState extends Model {

  Widget drawer = Application.currentUser == null ? NoUserMenuWidget() : LoggedInUserMenuWidget();

  void updateDrawer() {
    drawer = Application.currentUser == null ? NoUserMenuWidget() : LoggedInUserMenuWidget();
    notifyListeners();
  }

}