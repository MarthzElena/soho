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
      color: Colors.white,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 30.0,
                      height: preferredSize.height - 40.0,
                      alignment: Alignment.centerLeft,
                      child: Image(
                        image: detailBack,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 70.0,
                    height: 40.0,
                    child: TextField(
                      onChanged: (value) {
                        // Execute the search
                        locator<SearchState>().performSearch(value);
                      },
                      textAlignVertical: TextAlignVertical.center,
                      style: interLightStyle(
                        fSize: 14.0,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        hintText: 'Té, pastel, café...',
                        hintStyle: interLightStyle(
                          fSize: 14.0,
                          color: Color(0xffC4C4C4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.0),
                          borderSide: const BorderSide(
                            color: Color(0xffE5E4E5),
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xffE5E4E5),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xffE5E4E5),
                            width: 1.0,
                          ),
                        ),
                      ),
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