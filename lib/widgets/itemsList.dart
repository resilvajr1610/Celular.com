import 'package:celular/Model/BrandsModel.dart';
import 'package:flutter/material.dart';
import '../Model/export.dart';

class ItemsList extends StatelessWidget {

  BrandsModel brandsModel;
  final String item;


  ItemsList({
    this.brandsModel,
    this.item
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
                brandsModel!=null? brandsModel.brands: this.item,
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
