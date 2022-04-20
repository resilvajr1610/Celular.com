import 'dart:async';
import 'package:celular/Model/MobilesModel.dart';
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
  final _controllerMobiles = StreamController<QuerySnapshot>.broadcast();
  TextEditingController _controllerSerch = TextEditingController();
  String _selected;
  List _resultsList = [];
  List _allResults = [];

  Future<Stream<QuerySnapshot>> _addListenerMobiles()async{

    Stream<QuerySnapshot> stream = db
        .collection("marcas")
        .snapshots();
    stream.listen((data) {
      _controllerMobiles.add(data);
    });
  }

  _data() async {
    var data = await db.collection("celularPesquisa").get();

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
        var mobiles = MobilesModel.fromSnapshot(items).mobiles.toLowerCase();

        if (mobiles.contains(_controllerSerch.text.toLowerCase())) {
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
    _addListenerMobiles();
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
              Container(
                height: height * 0.5,
                child: StreamBuilder(
                  stream: _controllerMobiles.stream,
                  builder: (context, snapshot) {
                    return ListView.separated(
                        separatorBuilder: (context, index) => DividerList(),
                        itemCount: _resultsList.length,
                        itemBuilder: (BuildContext context, index) {
                          DocumentSnapshot item = _resultsList[index];

                          String id        = item["id"];
                          String brands    = item["celular"];

                          return ItemsList(
                            showDelete: false,
                            data: brands,
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
