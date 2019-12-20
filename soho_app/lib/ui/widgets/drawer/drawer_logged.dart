import 'package:flutter/material.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/purchases/history.dart';

class LoggedInUserMenuWidget extends StatelessWidget {
  final String photoUrl;

  LoggedInUserMenuWidget({this.photoUrl = ""});

  @override
  Widget build(BuildContext context) {
    // TODO: Add actions to each Row item
    var name = "";
    var lastOrder = "";
    var currentUser = Application.currentUser;
    if (currentUser != null) {
      name = currentUser.username;
      if (currentUser.ongoingOrders.isNotEmpty) {
        lastOrder = currentUser.ongoingOrders.last.getCompletedDateShort();
      }
    }

    return Drawer(
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: Color.fromARGB(255, 96, 73, 73)),
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
                              style: interBoldStyle(
                                fSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2.0),
                            lastOrder.isNotEmpty ?
                            Row(
                              children: <Widget>[
                                Text(
                                  'Última orden: ',
                                  style: interStyle(
                                    fSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  lastOrder,
                                  style: interBoldStyle(
                                    fSize: 12.0,
                                    color: Colors.white,
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
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/menu/icon_barcode.png'),
                            width: 24.0,
                          ),
                          SizedBox(width: 12.0),
                          Text(
                            'Mis órdenes',
                            style: interStyle(
                              fSize: 14.0,
                              color: Color(0xffE4E4E4),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 42.0),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.about),
                      child: Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/menu/icon_about.png'),
                            width: 24.0,
                          ),
                          SizedBox(width: 12.0),
                          Text(
                            'Acerca de Soho',
                            style: interStyle(
                              fSize: 14.0,
                              color: Color(0xffE4E4E4),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 42.0),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.paymentMethods),
                      child: Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/menu/icon_wallet.png'),
                            width: 24.0,
                          ),
                          SizedBox(width: 12.0),
                          Text(
                            'Métodos de pago',
                            style: interStyle(
                              fSize: 14.0,
                              color: Color(0xffE4E4E4),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 42.0),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.location),
                      child: Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/menu/icon_locations.png'),
                            width: 24.0,
                          ),
                          SizedBox(width: 12.0),
                          Text(
                            'Ubicación',
                            style: interStyle(
                              fSize: 14.0,
                              color: Color(0xffE4E4E4),
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
                    height: 80,
                    child: Column(
                      children: <Widget>[
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
                                style: interMediumStyle(
                                  fSize: 14.0,
                                  color: Color(0xffE4E4E4),
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
                                locator<AuthController>().logoutUser().then((_) {
                                  locator<HomePageState>().updateDrawer();
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                'Cerrar sesión',
                                style: interMediumStyle(
                                  fSize: 14.0,
                                  color: Color(0xff866767),
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
