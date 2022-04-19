import 'dart:async';
import 'package:celular/widgets/buttonsAdd.dart';
import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/dropDownItens.dart';
import 'package:celular/widgets/inputSearch.dart';
import 'package:celular/widgets/itemsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Model/BrandsModel.dart';
import '../../../Model/export.dart';

class MobilesScreen extends StatefulWidget {
  const MobilesScreen({Key key}) : super(key: key);

  @override
  _MobilesScreenState createState() => _MobilesScreenState();
}

class _MobilesScreenState extends State<MobilesScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controllerBrands = StreamController<QuerySnapshot>.broadcast();
  TextEditingController _controllerSerch = TextEditingController();
  String _selected;
  List _resultsList = [];
  List _allResults = [];

  Future<Stream<QuerySnapshot>> _addListenerBrands()async{

    Stream<QuerySnapshot> stream = db
        .collection("marcas")
        .snapshots();

    stream.listen((data) {
      _controllerBrands.add(data);
    });
  }

  Future<Stream<QuerySnapshot>> _addListenerFilter()async{

    Query query = db.collection("marcas");
    if(_selected != null){
      query = query.where("marcas",isEqualTo: _selected);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((data) {
      _controllerBrands.add(data);
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

  @override
  void initState() {
    super.initState();
    _addListenerBrands();
    _data();
    _controllerSerch.addListener(_search);
  }

  @override
  Widget build(BuildContext context) {

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
          title: Text('CELULAR'),
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
                  ButtonsAdd(onPressed: ()=> Navigator.pushNamed(context, "/partsRegister"))
                ],
              ),
              DropdownItens(
                  streamBuilder: StreamBuilder<QuerySnapshot>(
                    stream:_controllerBrands.stream,
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                        Text("Carregando");
                      }else {
                        List<DropdownMenuItem> espItems = [];
                        for (int i = 0; i < snapshot.data.docs.length;i++){
                          DocumentSnapshot snap=snapshot.data.docs[i];
                          espItems.add(
                              DropdownMenuItem(
                                child: Text(
                                  snap.id,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: PaletteColor.darkGrey),
                                ),
                                value: "${snap.id}",
                              )
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton(
                              items:espItems,
                              onChanged:(valor){
                                setState(() {
                                  _selected = valor;
                                  _addListenerFilter();
                                });
                              },
                              value: _selected,
                              isExpanded: false,
                              hint: new Text(
                                "Escolha uma marca",
                                style: TextStyle(color: PaletteColor.darkGrey ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  onChanged: (valor){
                    setState(() {
                      _selected = valor;
                    });
                  }),
              Container(
                height: height * 0.5,
                child: StreamBuilder(
                  stream: _controllerBrands.stream,
                  builder: (context, snapshot) {
                    return ListView.separated(
                        separatorBuilder: (context, index) => DividerList(),
                        itemCount: _resultsList.length,
                        itemBuilder: (BuildContext context, index) {
                          DocumentSnapshot item = _resultsList[index];

                          String id        = item["id"];
                          String brands    = item["marcas"];

                          return ItemsList(
                            data: brands,
                            onPressedDelete: () =>
                               _showDialogDelete(id,brands),
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
