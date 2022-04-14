import 'package:flutter/material.dart';
import '../Model/export.dart';

class DropdownItens extends StatelessWidget {

  final List<DropdownMenuItem<String>>listItens;
  final String selected;
  final dynamic onChanged;
  final double width;

  DropdownItens({
    @required this.listItens,
    @required this.onChanged,
    @required this.selected,
    @required this.width
});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: PaletteColor.lightGrey,
      elevation: 3,
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 5),
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        width: this.width,
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            iconEnabledColor: PaletteColor.blueButton,
            iconSize: 40,
            isExpanded: true,
            value: this.selected,
            hint: Text("Selecione",style: TextStyle(fontSize: 15)),
            style: TextStyle(
                color: Colors.black,
                fontSize: 12
            ),
            items: this.listItens,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
