import 'package:flutter/material.dart';

import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Constants.dart';

class LoggedInUserMenuWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  // TODO: Replace values with User values + Add actions to each Row item

    return Drawer(
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 96, 73, 73)
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 30),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 32,
                  width: 32,
                  color: Colors.grey,
                ),
              ),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 48.0),
                      child: Text(
                          'Martha Loera', // Change this with real user
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0, top: 2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Última orden: ',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Color.fromARGB(255, 222, 221, 222)
                          ),
                        ),
                        Text(
                          'Hace X días',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Color.fromARGB(255, 222, 221, 222),
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ), // Name, photo, last order date
              Padding(
                padding: const EdgeInsets.only(top: 113),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image(
                            image: AssetImage('assets/menu/icon_barcode.png')
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Mis órdenes',
                            style: TextStyle(
                              color: Color.fromARGB(255, 228, 228, 228),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0
                            ),
                          ),
                        )
                      ],
                    ), // Mis ordenes
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Row(
                        children: <Widget>[
                          Image(
                              image: AssetImage('assets/menu/icon_about.png')
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Acerca de Soho',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 228, 228, 228),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0
                              ),
                            ),
                          )
                        ],
                      ),
                    ), // Acerca de soho
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 44),
                      child: Row(
                        children: <Widget>[
                          Image(
                              image: AssetImage('assets/menu/icon_wallet.png')
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Métodos de pago',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 228, 228, 228),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0
                              ),
                            ),
                          )
                        ],
                      ),
                    ), // Metodos de pago
                    Row(
                      children: <Widget>[
                        Image(
                            image: AssetImage('assets/menu/icon_locations.png')
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Text(
                            'Ubicaciones',
                            style: TextStyle(
                                color: Color.fromARGB(255, 228, 228, 228),
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0
                            ),
                          ),
                        )
                      ],
                    ), // Ubicaciones
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
                                image: AssetImage('assets/menu/icon_settings.png')
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Configuración',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 228, 228, 228),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0
                                ),
                              ),
                            )
                          ],
                        ), // Configuracion
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30, top: 35),
                            child: InkWell(
                              onTap: null,
                              child: Text(
                                'Cerrar sesión',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 134, 103, 103),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),
                        )
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