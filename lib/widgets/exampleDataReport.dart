import 'package:celular/Model/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExampleDataReport extends StatelessWidget {

  final String title;
  final String colorsUp;
  final String colorsLow;
  final int unidUp;
  final int unidLow;
  final bool showImagem;

  const ExampleDataReport({
    @ required this.title,
    @required this.colorsUp,
    @required this.colorsLow,
    @required this.unidUp,
    @required this.unidLow,
    this.showImagem
  });

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    NumberFormat format = NumberFormat('00');

    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          showImagem?Container(
            color: PaletteColor.lightGrey,
            width: height*0.1,
            height: height*0.1,
          ):Container(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(this.title),
                    ),
                  ],
                ),
              ),
              Container(
                width: showImagem?width*0.7:width*0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                          child: Row(
                            children: [
                              Text('Cor'),
                              SizedBox(width: 10),
                              Text(this.colorsUp,style: TextStyle(fontWeight: FontWeight.bold,color: PaletteColor.darkGrey))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 8),
                          child: Row(
                            children: [
                              Text(showImagem?'Cor':'Mínimo:'),
                              SizedBox(width: 10),
                              Text(this.colorsLow,style: TextStyle(fontWeight: FontWeight.bold,color: PaletteColor.darkGrey))
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 8),
                          child: Row(
                            children: [
                              Text('Estoque'),
                              SizedBox(width: 10),
                              Text(format.format(this.unidUp),style: TextStyle(fontWeight: FontWeight.bold,color: PaletteColor.darkGrey))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 8),
                          child: Row(
                            children: [
                              Text(showImagem?'Estoque':'Quantidade faltante'),
                              SizedBox(width: 10),
                              Text(format.format(this.unidLow),style: TextStyle(fontWeight: FontWeight.bold,color: showImagem?PaletteColor.darkGrey:Colors.red))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
