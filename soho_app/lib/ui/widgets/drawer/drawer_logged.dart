import 'package:flutter/material.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/purchases/admin.dart';
import 'package:soho_app/ui/purchases/history.dart';
import 'package:soho_app/ui/widgets/drawer/QRCodeReaderTest.dart';

class LoggedInUserMenuWidget extends StatelessWidget {
  final String photoUrl;

  LoggedInUserMenuWidget({this.photoUrl = ""});

  @override
  Widget build(BuildContext context) {
    var name = "";
    var lastOrder = "";
    var isAdmin = false;
    var currentUser = Application.currentUser;
    if (currentUser != null) {
      name = currentUser.username;
      if (currentUser.ongoingOrders.isNotEmpty) {
        lastOrder = currentUser.ongoingOrders.last.getCompletedDateShort();
      }
      isAdmin = currentUser.isAdmin;
    }

    return Drawer(
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 30),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 32.0,
                          height: 32.0,
                          child: photoUrl.isEmpty ?
                          CircleAvatar(
                            radius: 50.0,
                            backgroundColor: Colors.grey,
                            child: Container(
                            ),
                          ) :
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(photoUrl),
                                )
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              name.isNotEmpty ? name : 'Nombre',
                              style: boldStyle(
                                fSize: 16.0,
                                color: Color(0xff604848),
                              ),
                            ),
                            SizedBox(height: 2.0),
                            lastOrder.isNotEmpty ?
                            Row(
                              children: <Widget>[
                                Text(
                                  'Última orden: ',
                                  style: regularStyle(
                                    fSize: 12.0,
                                    color: Color(0xff604848),
                                  ),
                                ),
                                Text(
                                  lastOrder,
                                  style: boldStyle(
                                    fSize: 12.0,
                                    color: Color(0xff604848),
                                  ),
                                )
                              ],
                            ) : SizedBox.shrink()
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 115.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HistoryScreen(isOngoingOrder: true))
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/menu/icon_barcode.png'),
                            width: 24.0,
                          ),
                          SizedBox(width: 12.0),
                          Text(
                            'Mis órdenes',
                            style: regularStyle(
                              fSize: 14.0,
                              color: Color(0xff604848),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 42.0),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.about),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/menu/icon_about.png'),
                            width: 24.0,
                          ),
                          SizedBox(width: 12.0),
                          Text(
                            'Acerca de Soho',
                            style: regularStyle(
                              fSize: 14.0,
                              color: Color(0xff604848),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 42.0),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.paymentMethods),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/menu/icon_wallet.png'),
                            width: 24.0,
                          ),
                          SizedBox(width: 12.0),
                          Text(
                            'Métodos de pago',
                            style: regularStyle(
                              fSize: 14.0,
                              color: Color(0xff604848),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 42.0),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.location),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/menu/icon_locations.png'),
                            width: 24.0,
                          ),
                          SizedBox(width: 12.0),
                          Text(
                            'Ubicación',
                            style: regularStyle(
                              fSize: 14.0,
                              color: Color(0xff604848),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 52),
                  child: Container(
                    height: isAdmin ? 160 : 80,
                    child: Column(
                      children: <Widget>[
                        isAdmin ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => AdminScreen()
                                )
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Image(
                                image: AssetImage('assets/menu/icon_admin.png'),
                                width: 24.0,
                              ),
                              SizedBox(width: 12.0),
                              Text(
                                'Administrador Soho',
                                style: regularStyle(
                                  fSize: 14.0,
                                  color: Color(0xff604848),
                                  fWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ) : SizedBox.shrink(),
                        isAdmin ? SizedBox(height: 36.0) : SizedBox.shrink(),
                        Row(
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/menu/icon_settings.png'),
                              width: 24.0,
                            ),
                            SizedBox(width: 12.0),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, Routes.viewProfile),
                              child: Text(
                                'Configuración',
                                style: regularStyle(
                                  fSize: 14.0,
                                  color: Color(0xff604848),
                                  fWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 36.0),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 36.0),
                            GestureDetector(
                              onTap: () {
                                locator<AppController>().logoutUser().then((_) {
                                  locator<HomePageState>().updateDrawer();
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                'Cerrar sesión',
                                style: regularStyle(
                                  fSize: 14.0,
                                  color: Color(0xffCCC5BA),
                                  fWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
