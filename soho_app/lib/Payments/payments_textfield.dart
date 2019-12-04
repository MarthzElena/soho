import 'package:flutter/material.dart';

class PaymentsTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;

  PaymentsTextField({this.controller, this.hint = ''});

  @override
  _PaymentsTextFieldState createState() => _PaymentsTextFieldState();
}

class _PaymentsTextFieldState extends State<PaymentsTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: TextField(
        controller: widget.controller,
        textCapitalization: TextCapitalization.words,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: widget.hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
            borderSide: BorderSide(
              color: Color(0xffE5E4E5),
              width: 1.0,
            ),
          ),
          hintStyle: TextStyle(
            fontSize: 14.0,
            color: Color(0xffC4C4C4),
            fontFamily: 'InterUI',
            fontStyle: FontStyle.normal,
          ),
        ),
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
          fontFamily: 'InterUI',
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}
