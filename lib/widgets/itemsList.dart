import 'package:celular/Model/BrandsModel.dart';
import 'package:flutter/material.dart';
import '../Model/export.dart';

class ItemsList extends StatelessWidget {

  final String item;
  final String data;
  VoidCallback onPressedDelete;


  ItemsList({
    this.data,
    this.item,
    this.onPressedDelete,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                this.data!=null? this.data: this.item,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: PaletteColor.darkGrey,
                  fontWeight: FontWeight.w400,
                ),
              )
          ),
          Spacer(),
          SizedBox(width: 20),
          if(this.onPressedDelete != null)
            GestureDetector(
              onTap: this.onPressedDelete,
              child: Icon(Icons.delete,color: PaletteColor.lightBlue),
            )
        ],
      ),
    );
  }
}
