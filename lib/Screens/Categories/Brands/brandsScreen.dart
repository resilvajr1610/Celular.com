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
  TextEditingController _controllerSerch = TextEditingController();
  TextEditingController _controllerRegister = TextEditingController();
  var _controllerBrands = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _addListenerBrands()async{

    Stream<QuerySnapshot> stream = db
        .collection("marcas")
        .snapshots();

    stream.listen((dados) {
      _controllerBrands.add(dados);
    });
  }

  _registerBrands(){
    db.collection("marcas").doc(_controllerRegister.text).set({

      "marca"  : _controllerRegister.text,

    }).then((value){
      Navigator.pop(context);
      _controllerRegister.clear();
    }
    );
  }

  _showDialog(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return ShowDialogRegister(
            title: 'Cadastrar Marca',
            hint: 'Nova Marca',
            controllerRegister: _controllerRegister,
            list: [
              ButtonsRegister(
                  onTap: ()=>Navigator.pop(context),
                  text: 'Cancelar',
                  color: PaletteColor.greyButton
              ),
              Spacer(),
              ButtonsRegister(
                  onTap:()=>_registerBrands(),
                  text: 'Incluir',
                  color: PaletteColor.blueButton
              ),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    _addListenerBrands();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var loading = Center(
      child: Column(
        children: [
          Text('Carregando marcas'),
          CircularProgressIndicator()
        ],
      ),
    );

    var empty = Center(
      child: Text('Nenhuma marca Cadastrada',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,fontFamily: 'Arimo',
        ),),
    );

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
          title: Text('MARCA'),
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
                  ButtonsAdd(onPressed: ()=> _showDialog())
                ],
              ),
              Container(
                height: height*0.5,
                child: StreamBuilder(
                  stream: _controllerBrands.stream,
                  builder: (context,snapshot){

                    switch (snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return loading;
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:

                        if(snapshot.hasError)
                          return Text("Erro ao carregar dados!");

                        QuerySnapshot querySnapshot = snapshot.data;
                        return ListView.separated(
                            separatorBuilder: (context, index) => DividerList(),
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (_,index){

                              List<DocumentSnapshot> brands = querySnapshot.docs.toList();
                              DocumentSnapshot documentSnapshot = brands[index];
                              BrandsModel brandsModel = BrandsModel.fromDocumentSnapshot(documentSnapshot);

                              return ItemsList(
                                brandsModel: brandsModel,
                              );
                            }
                        );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
