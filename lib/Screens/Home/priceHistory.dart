import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/textTitle.dart';
import 'package:flutter/material.dart';
import '../../Model/export.dart';
import '../../widgets/exampleDataHistory.dart';
import '../../widgets/inputSearch.dart';

class PriceHistory extends StatefulWidget {
  const PriceHistory({Key key}) : super(key: key);

  @override
  _PriceHistoryState createState() => _PriceHistoryState();
}

class _PriceHistoryState extends State<PriceHistory> {

  TextEditingController _controllerSearch = TextEditingController();
  String _input;
  String _output;
  String _alls;
  String _value;
  static double fonts=20.0;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 15,
          color: PaletteColor.white,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: PaletteColor.appBar,
        title: Text('HISTÓRICO DE PREÇOS'),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: 55,
            child: Image.asset("assets/celularcom_ImageView_32-41x41.png"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InputSearch(controller: _controllerSearch),
            Row(
              children: [
                Radio(
                    value: 'entrada',
                    groupValue: _input,
                    activeColor: PaletteColor.darkGrey,
                    onChanged: (value){
                      setState(() {
                        _value = value;
                        print('teste '+ _value.toString());
                      });
                    }
                ),
                TextTitle(
                    text: 'Entrada',
                    fonts: 14
                ),
                Radio(
                    value: 'saida',
                    groupValue: _output,
                    activeColor: PaletteColor.darkGrey,
                    onChanged: (value){
                      setState(() {
                        _value = value;
                        print('teste '+ _value.toString());
                      });
                    }
                ),
                TextTitle(
                    text: 'Saída',
                    fonts: 14
                ),
                Radio(
                    value: 'todos',
                    groupValue: _alls,
                    activeColor: PaletteColor.darkGrey,
                    onChanged: (value){
                      setState(() {
                        _value = value;
                        print('teste '+ _value.toString());
                      });
                    }
                ),
                TextTitle(
                    text: 'Todos',
                    fonts: 14
                )
              ],
            ),
            DividerList(),
            ExampleDataHistory(),
            ExampleDataHistory(),
            ExampleDataHistory(),
            ExampleDataHistory(),
            ExampleDataHistory(),
          ],
        ),
      ),
    );
  }
}
