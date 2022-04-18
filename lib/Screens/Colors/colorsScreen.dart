import 'dart:async';

import 'package:celular/widgets/buttonsAdd.dart';
import 'package:celular/widgets/buttonsRegister.dart';
import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/inputRegister.dart';
import 'package:celular/widgets/inputSearch.dart';
import 'package:celular/widgets/itemsList.dart';
import 'package:celular/widgets/showDialogRegister.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Model/ColorsModel.dart';
import '../../Model/export.dart';

class ColorsScreen extends StatefulWidget {
  const ColorsScreen({Key key}) : super(key: key);

  @override
  _ColorsScreenState createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {

  ColorsModel _colorsModel;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _controllerSerch = TextEditingController();
  TextEditingController _controllerRegister = TextEditingController();
  var _controllerColors = StreamController<QuerySnapshot>.broadcast();
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;

  _data() async {
    var data = await db.collection("corPesquisa").get();

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

    if (_controllerSerch.text != "") {
      for (var items in _allResults) {
        var brands = ColorsModel.fromSnapshot(items).color.toLowerCase();

        if (brands.contains(_controllerSerch.text.toLowerCase())) {
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

  _registerColors(){
    _colorsModel = ColorsModel.createId();

    _colorsModel.color = _controllerRegister.text;

    db
        .collection("cores")
        .doc(_colorsModel.color)
        .set(_colorsModel.toMap())
        .then((value) {
      db
          .collection('corPesquisa')
          .doc(_colorsModel.id)
          .set(_colorsModel.toMap())
          .then((value) {
        Navigator.pop(context);
        _controllerRegister.clear();
        Navigator.pushReplacementNamed(context, "/colors");
      });
    });
  }

  _deleteColors(String idColor, String color) {

    db.collection("cores")
        .doc(color)
        .delete()
        .then((_){

      db.collection('corPesquisa')
          .doc(idColor)
          .delete()
          .then((_){
        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, "/colors");
      });
    });
  }

  _showDialogRegister(String brands) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ShowDialogRegister(
            title: 'Cadastrar Cor',
            hint: 'Nova Cor',
            controllerRegister: _controllerRegister,
            list: [
              ButtonsRegister(
                  onTap: () => Navigator.pop(context),
                  text: 'Cancelar',
                  color: PaletteColor.greyButton),
              Spacer(),
              ButtonsRegister(
                  onTap: () => _registerColors(),
                  text: 'Incluir',
                  color: PaletteColor.blueButton),
            ],
          );
        });
  }

  _showDialogDelete(String idColor,String color) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmar"),
            content: Text("Deseja realmente excluir essa cor?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: Colors.red,
                child: Text(
                  "Remover",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _deleteColors(idColor,color),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _colorsModel = ColorsModel();
    _data();
    _controllerSerch.addListener(_search);
    //_addListenerBrands();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerSerch.removeListener(_search);
    _controllerSerch.dispose();
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
        backgroundColor: PaletteColor.white,
        appBar: AppBar(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: PaletteColor.white,
            fontWeight: FontWeight.w700,
          ),
          backgroundColor: PaletteColor.appBar,
          title: Text('COR'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InputSearch(controller: _controllerSerch),
                  ButtonsAdd(onPressed: (){
                    _controllerRegister.clear();
                    _showDialogRegister(_controllerRegister.text);
                  })
                ],
              ),
              Container(
                height: height * 0.5,
                child: StreamBuilder(
                  stream: _controllerColors.stream,
                  builder: (context, snapshot) {
                    return ListView.separated(
                        separatorBuilder: (context, index) => DividerList(),
                        itemCount: _resultsList.length,
                        itemBuilder: (BuildContext context, index) {
                          DocumentSnapshot item = _resultsList[index];

                          String id        = item["id"];
                          String color    = item["cor"];

                          return ItemsList(
                            data: color,
                            onPressedDelete: () =>
                                _showDialogDelete(id,color),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
