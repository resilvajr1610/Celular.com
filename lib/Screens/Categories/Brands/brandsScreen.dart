import 'dart:async';
import 'package:celular/Model/BrandsModel.dart';
import 'package:celular/widgets/buttonsAdd.dart';
import 'package:celular/widgets/buttonsRegister.dart';
import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/inputSearch.dart';
import 'package:celular/widgets/itemsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Model/export.dart';
import '../../../widgets/showDialogRegister.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({Key key}) : super(key: key);

  @override
  _BrandsScreenState createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  BrandsModel _brandsModel;
  TextEditingController _controllerSerch = TextEditingController();
  TextEditingController _controllerRegister = TextEditingController();
  var _controllerBrands = StreamController<QuerySnapshot>.broadcast();
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;

  _data() async {
    var data = await db.collection("marcaPesquisa").get();

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
        var brands = BrandsModel.fromSnapshot(items).brands.toLowerCase();

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

  _registerBrands() {
    _brandsModel = BrandsModel.createId();

    _brandsModel.brands = _controllerRegister.text;

    db
        .collection("marcas")
        .doc(_brandsModel.brands)
        .set(_brandsModel.toMap())
        .then((value) {
      db
          .collection('marcaPesquisa')
          .doc(_brandsModel.id)
          .set(_brandsModel.toMap())
          .then((value) {
        Navigator.pop(context);
        _controllerRegister.clear();
        Navigator.pushReplacementNamed(context, "/brands");
      });
    });
  }

  _deleteBrands(String idBrands, String brands) {

    db.collection("marcas")
      .doc(brands)
      .delete()
      .then((_){

      db.collection('marcaPesquisa')
        .doc(idBrands)
        .delete()
        .then((_){
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, "/brands");
      });
    });
  }

  _showDialogRegister(String brands) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ShowDialogRegister(
            title: 'Cadastrar Marca',
            hint: 'Nova Marca',
            controllerRegister: _controllerRegister,
            list: [
              ButtonsRegister(
                  onTap: () => Navigator.pop(context),
                  text: 'Cancelar',
                  color: PaletteColor.greyButton),
              ButtonsRegister(
                  onTap: () => _registerBrands(),
                  text: 'Incluir',
                  color: PaletteColor.blueButton),
            ],
          );
        });
  }

  _showDialogDelete(String idBrands,String brands) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmar"),
            content: Text("Deseja realmente excluir essa marca?"),
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
                onPressed: () => _deleteBrands(idBrands,brands),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _brandsModel = BrandsModel();
    _data();
    _controllerSerch.addListener(_search);
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
          title: Text('MARCAS'),
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
                  ButtonsAdd(onPressed: () {
                    _controllerRegister.clear();
                    _showDialogRegister(_controllerRegister.text);
                  })
                ],
              ),
              Container(
                height: height * 0.5,
                child: StreamBuilder(
                  stream: _controllerBrands.stream,
                  builder: (context, snapshot) {
                    if(snapshot.hasError)
                      return Text("Erro ao carregar dados!");

                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                        case ConnectionState.done:
                          if (_resultsList.length == 0) {
                            return Center(
                                child: Text('Sem dados!', style: TextStyle(
                                    fontSize: 20),)
                            );
                          } else {
                            return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    DividerList(),
                                itemCount: _resultsList.length,
                                itemBuilder: (BuildContext context, index) {
                                  DocumentSnapshot item = _resultsList[index];

                                  String id = item["id"];
                                  String brands = item["marcas"];

                                  return ItemsList(
                                    data: brands,
                                    showDelete: true,
                                    onPressedDelete: () =>_showDialogDelete(id, brands),
                                    onPressedEdit: null,
                                  );
                                });
                          }
                      }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
