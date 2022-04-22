import 'dart:async';
import 'package:celular/widgets/buttonsRegister.dart';
import 'package:celular/widgets/groupStock.dart';
import 'package:celular/widgets/inputSearch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Model/PartsModel.dart';
import '../../Model/UpdatesModel.dart';
import '../../Model/export.dart';
import '../../widgets/dividerList.dart';
import '../../widgets/itemsList.dart';

class Output extends StatefulWidget {
  const Output({Key key}) : super(key: key);

  @override
  _OutputState createState() => _OutputState();
}

class _OutputState extends State<Output> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _controllerSearch = TextEditingController();
  TextEditingController _controllerStock = TextEditingController();
  TextEditingController _controllerPriceSale = TextEditingController();
  var _controllerItem = StreamController<QuerySnapshot>.broadcast();
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;
  bool _visibility=false;
  String _id;
  String _part;
  String _brand;
  String _item;
  UpdatesModel _updatesModel;

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

  _updateValue(){

    _updatesModel = UpdatesModel.createId();

    _updatesModel.type = 'saida';
    _updatesModel.quantity = _controllerStock.text;
    _updatesModel.part = _part;
    _updatesModel.brand = _brand;
    _updatesModel.date = DateTime.now().toString();
    _updatesModel.price = _controllerPriceSale.text;
    _updatesModel.item = _item;

    db
        .collection("pecas")
        .doc(_id)
        .update({
      "precoVenda":_controllerPriceSale.text,
      "estoque":_controllerStock.text
    }).then((_) {

      db.collection("historicoPrecos")
          .doc(_updatesModel.id)
          .set(_updatesModel.toMap())
          .then((_){
        _controllerStock.clear();
        _controllerPriceSale.clear();
        _id = "";
        _part = "";
        _brand = "";
        _item = "";

        setState(() {
          _visibility = false;
          _data();
        });
      });

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: PaletteColor.white,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: PaletteColor.appBar,
        title: Text('SAÍDA'),
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

                        _id        = item["id"];
                        _item   = item["item"];
                        String stock    = item["estoque"]??"";
                        String priceSale= item["precoVenda"]??"";
                        _brand    = item["marca"]??"";
                        _part    = item["peca"]??"";

                        return ItemsList(
                          onTapItem: (){
                            setState(() {
                              _controllerStock = TextEditingController(text: stock);
                              _controllerPriceSale = TextEditingController(text: priceSale);
                              _visibility=true;
                            });
                          },
                          data: _item,
                          showDelete: false,
                        );
                      });
                },
              ),
            ),
            Visibility(
              visible: _visibility,
              child: Column(
                children: [
                  GroupStock(
                      title: "",
                      fontsTitle: 16,
                      width: width * 0.5,
                      showCod: false,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      onTapCamera: () => {},
                      showStockmin: false,
                      showPrice: false,
                      titlePrice: 'Preço venda',
                      showCamera: false),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonsRegister(
                          onTap: (){
                            setState(() {
                              _visibility=false;
                            });
                          },
                          text: 'Cancelar',
                          color: PaletteColor.darkGrey),
                      ButtonsRegister(
                          onTap: () => _updateValue(),
                          text: 'Dar Baixa',
                          color: PaletteColor.blueButton),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
