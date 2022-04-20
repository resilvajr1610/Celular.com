import 'dart:async';

import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/exampleDataReport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Model/PartsModel.dart';
import '../../Model/export.dart';
import '../../widgets/inputSearch.dart';

class StockReport extends StatefulWidget {
  const StockReport({Key key}) : super(key: key);

  @override
  _StockReportState createState() => _StockReportState();
}

class _StockReportState extends State<StockReport> {

  TextEditingController _controllerSearch = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  var _controllerItem = StreamController<QuerySnapshot>.broadcast();
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;

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
        title: Text('RELATÓRIO DE ESTOQUE'),
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
                            String peca    = item["peca"]??"";
                            String selecionado2    = item["selecionado2"]??"";
                            String foto    = item["foto"]??"";
                            String brands    = item["marca"]??"";

                            return ExampleDataReport(
                              showImagem: true,
                              photo: foto,
                              title: peca,
                              brands: brands,
                              colorsUp: selecionado2,
                              unidUp: int.parse(stock),
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
