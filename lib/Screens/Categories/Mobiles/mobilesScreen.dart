import 'dart:async';

import 'package:celular/widgets/buttonsAdd.dart';
import 'package:celular/widgets/buttonsRegister.dart';
import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/dropDownItens.dart';
import 'package:celular/widgets/inputRegister.dart';
import 'package:celular/widgets/inputSearch.dart';
import 'package:celular/widgets/itemsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  TextEditingController _controllerRegister = TextEditingController();
  String _selected;

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

  @override
  void initState() {
    super.initState();
    _addListenerBrands();
  }

  @override
  Widget build(BuildContext context) {
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
              ItemsList(item: "iPhone 5"),
              DividerList(),
              ItemsList(item: "iPhone 6"),
              DividerList(),
              ItemsList(item: "iPhone 7"),
              DividerList(),
              ItemsList(item: "iPhone 8"),
            ],
          ),
        ));
  }
}
