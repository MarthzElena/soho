import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Fonts.dart';

class TextFieldSoho extends StatefulWidget {
  final TextEditingController controller;
  final int length;

  TextFieldSoho({this.controller, this.length = 100});

  @override
  _TextFieldSohoState createState() => _TextFieldSohoState();
}

class _TextFieldSohoState extends State<TextFieldSoho> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 12,
      child: TextField(
        maxLength: widget.length,
        textAlign: TextAlign.center,
        controller: widget.controller,
        keyboardType: TextInputType.number,
        style: interBoldStyle(fSize: 14.0),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          hintText: '-',
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
    );
  }
}
