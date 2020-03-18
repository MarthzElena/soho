import 'package:flutter/material.dart';
import 'package:soho_app/States/SearchState.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color(0xffF3F1F2),
      height: preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFC4C4C4),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 30.0,
                          child: Image(
                            image: searchIconDark,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 110,
                          child: TextField(
                            onChanged: (value) async {
                              var model = locator<SearchState>();
                              model.currentQuery = value;
                              if (value.isEmpty) {
                                model.showSpinner(false);
                                model.clearResults();
                              } else {
                                // Show spinner while search is completed
                                model.showSpinner(true);
                                // Execute the search
                                await model.performSearch(value, context).then((error) async {
                                  if (error.isNotEmpty) {
                                    await showDialog(
                                      context: context,
                                      child: SimpleDialog(
                                        title: Text(error),
                                        children: <Widget>[
                                          SimpleDialogOption(
                                            child: Text("OK"),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                });
                              }
                            },
                            textAlignVertical: TextAlignVertical.center,
                            style: interLightStyle(
                              fSize: 14.0,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFC4C4C4),
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: 'Té, pastel, café...',
                              hintStyle: interLightStyle(
                                fSize: 14.0,
                                color: Color(0xff5A6265),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            locator<SearchState>().clearResults();
                            locator<SearchState>().showSpinner(false);
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 40.0,
                            alignment: Alignment.center,
                            child: Image(
                              image: searchCloseDark,
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Constants.APP_BAR_HEIGHT + 36);

}