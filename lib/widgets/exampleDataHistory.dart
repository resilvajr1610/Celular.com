import 'package:celular/Model/colors.dart';
import 'package:flutter/material.dart';

class ExampleDataHistory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('Data'),
              SizedBox(width: 10),
              Text('09/03/2021',style: TextStyle(fontWeight: FontWeight.bold,color: PaletteColor.darkGrey))
            ],
          ),
          Row(
            children: [
              Text('Quantidade'),
              SizedBox(width: 10),
              Text('10',style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text('Preço compra'),
              SizedBox(width: 10),
              Text('R\$ 08,40',style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ],
      ),
    );
  }
}
