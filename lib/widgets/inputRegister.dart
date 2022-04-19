import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Model/export.dart';

class InputRegister extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final double width;
  final double fonts;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatter;

  InputRegister({
    @required this.controller,
    @required this.hint,
    @required this.width,
    @required this.fonts,
    @required this.keyboardType,
    this.inputFormatter,
});

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.topCenter,
      width: this.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: PaletteColor.lightGrey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            offset: Offset(0, -2), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        controller: this.controller,
        textAlign: TextAlign.center,
        keyboardType: this.keyboardType,
        textAlignVertical: TextAlignVertical.bottom,
        inputFormatters:this.inputFormatter,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: this.hint,
            hintStyle: TextStyle(
              color: PaletteColor.darkGrey,
              fontSize: this.fonts,
            )
        ),
      ),
    );
  }
}
