import 'dart:async';
import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/exampleDataReport.dart';
import 'package:celular/widgets/textTitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Model/PartsModel.dart';
import '../../Model/export.dart';
import '../../widgets/inputSearch.dart';

class StockAlert extends StatefulWidget {
  const StockAlert({Key key}) : super(key: key);

  @override
  _StockAlertState createState() => _StockAlertState();
}

class _StockAlertState extends State<StockAlert> {

  TextEditingController _controllerSearch = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  var _controllerItem = StreamController<QuerySnapshot>.broadcast();
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;
  String _input;
  String _output;
  String _value;

  _data() async {
    var data = await db.collection("pecas").get();

    setState(() {
      _allResults = data.docs;
    });
    resultSearchList();
    return "complete";
  }

  _search() {
    resultSearchList();
  }

  resultSearchList() {
    var showResults = [];

    if (_controllerSearch.text != "") {
      for (var items in _allResults) {
        var parts = PartsModel.fromSnapshot(items).item.toLowerCase();

        if (parts.contains(_controllerSearch.text.toLowerCase())) {
          showResults.add(items);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  void initState() {
    super.initState();
    _data();
    _controllerSearch.addListener(_search);
  }

  @override
  void dispose() {
    super.dispose();
    _controllerSearch.removeListener(_search);
    _controllerSearch.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = _search();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        label: Text('Gerar PDF'),
      ),
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 15,
          color: PaletteColor.white,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: PaletteColor.appBar,
        title: Text('ALERTA DE ESTOQUE'),
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
            Column(
              children: [
                InputSearch(controller: _controllerSearch),
                Row(
                  children: [
                    Radio(
                        value: 'alerta',
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
                        text: 'Abaixo do estoque',
                        fonts: 14
                    ),
                    Radio(
                        value: 'todos',
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
                        text: 'Todos',
                        fonts: 14
                    ),
                  ],
                ),
                DividerList(),
                Container(
                  height: height * 0.4,
                  child: StreamBuilder(
                    stream: _controllerItem.stream,
                    builder: (context, snapshot) {
                      return ListView.separated(
                          separatorBuilder: (context, index) => DividerList(),
                          itemCount: _resultsList.length,
                          itemBuilder: (BuildContext context, index) {
                            DocumentSnapshot item = _resultsList[index];

                            String id        = item["id"];
                            String stock    = item["estoque"]??"";
                            String stockMin    = item["estoqueMinimo"]??"";
                            String peca    = item["peca"]??"";
                            String selecionado2    = item["selecionado2"]??"";
                            String brands    = item["marca"]??"";

                            int dif = int.parse(stockMin)-int.parse(stock);

                            return ExampleDataReport(
                              showImagem: false,
                              title: peca,
                              unidMin: int.parse(stockMin),
                              unidUp: int.parse(stock),
                              difference: dif,
                              brands: brands,
                              colorsUp: selecionado2,
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
