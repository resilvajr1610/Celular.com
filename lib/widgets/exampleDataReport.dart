import 'package:intl/intl.dart';

import '../Utils/export.dart';

class ExampleDataReport extends StatelessWidget {

  final String title;
  final String brands;
  final String colorsUp;
  final String photo;
  final String model;
  final String ref;
  final int unidUp;
  final int unidMin;
  final bool showImagem;
  final int difference;

  const ExampleDataReport({
    @ required this.title,
    this.photo,
    this.brands,
    this.model,
    this.ref,
    this.difference,
    @required this.colorsUp,
    this.unidUp,
    this.unidMin,
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
          showImagem?Image.network(this.photo,
            height: height*0.1,
            width: height*0.1,
            errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
              return Container(height: height*0.1,width: height*0.1,child: Icon(Icons.do_not_disturb));
            },
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Marca : "+ this.brands),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Modelo : "+ this.model),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Referência : "+ this.ref),
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
                        this.showImagem?Container():Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 8),
                          child: Row(
                            children: [
                              Text('Mínimo: '),
                              SizedBox(width: 10),
                              Text(format.format(this.unidMin),style: TextStyle(fontWeight: FontWeight.bold,color: PaletteColor.darkGrey))
                            ],
                          ),
                        ),
                        this.showImagem?Container():SizedBox(height: 15),
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
                        this.showImagem?Container():Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 8),
                          child: Row(
                            children: [
                              Text('Quantidade\nfaltante: '),
                              SizedBox(width: 10),
                              Text(format.format(this.difference),style: TextStyle(fontWeight: FontWeight.bold,color: this.showImagem?PaletteColor.darkGrey:Colors.red))
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
