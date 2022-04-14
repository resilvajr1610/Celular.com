import 'package:flutter/material.dart';
import '../Model/export.dart';

class ItemsList extends StatelessWidget {

  final String item;

  ItemsList({
    @required this.item
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                this.item,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: PaletteColor.darkGrey,
                  fontWeight: FontWeight.w400,
                ),
              )
          ),
          Spacer(),
          Icon(Icons.edit,color: PaletteColor.lightBlue),
          SizedBox(width: 20),
          Icon(Icons.delete_forever,color: PaletteColor.lightBlue),
        ],
      ),
    );
  }
}
