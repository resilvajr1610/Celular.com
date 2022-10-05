import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Model/colors.dart';
import '../../../widgets/buttonsRegister.dart';
import '../../../widgets/dropDownItens.dart';
import '../../../widgets/inputRegister.dart';

class AddRefScreen extends StatefulWidget {
  const AddRefScreen({Key key}) : super(key: key);

  @override
  State<AddRefScreen> createState() => _AddRefScreenState();
}

class _AddRefScreenState extends State<AddRefScreen> {

  final _controllerBrands = StreamController<QuerySnapshot>.broadcast();
  var _controllerModel = TextEditingController();
  var _controllerRef = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String _selectedBrands;

  Future<Stream<QuerySnapshot>> _addListenerBrands()async{

    Stream<QuerySnapshot> stream = db
        .collection("marcas")
        .snapshots();

    stream.listen((data) {
      _controllerBrands.add(data);
    });
  }

  Widget streamBrands() {

    _addListenerBrands();

    return StreamBuilder<QuerySnapshot>(
      stream:_controllerBrands.stream,
      builder: (context,snapshot){

        if(snapshot.hasError)
          return Text("Erro ao carregar dados!");

        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container();
          case ConnectionState.active:
          case ConnectionState.done:

            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }else {
              List<DropdownMenuItem> espItems = [];
              for (int i = 0; i < snapshot.data.docs.length; i++) {
                DocumentSnapshot snap = snapshot.data.docs[i];
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
                    items: espItems,
                    onChanged: (value) {
                      setState(() {
                        _selectedBrands = value;
                      });
                    },
                    value: _selectedBrands,
                    isExpanded: false,
                    hint: new Text(
                      "Escolha uma marca",
                      style: TextStyle(color: PaletteColor.darkGrey),
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }

  _registerRef(){

    db
        .collection("ref")
        .doc(_controllerRef.text)
        .set({
          'ref' : _controllerRef.text,
          'modelo':_controllerModel.text,
          'marca': _selectedBrands
        })
        .then((value) {

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Center(child: Text('Salvo')),
              titleTextStyle: TextStyle(color: PaletteColor.darkGrey,fontSize: 20),
              content: Row(
                children: [
                  Expanded(
                      child:  Text('Informações incluídas no banco de dados')
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              actions: [
                ElevatedButton(
                    onPressed: ()=>Navigator.pushReplacementNamed(context, "/ref"),
                    child: Text('OK')
                )
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
        title: Text('ADICIONAR REFERÊNCIAS',style: TextStyle(fontSize: 13),),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: 55,
            child: Image.asset("assets/logoBig.png"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Marca',
                style: TextStyle(fontSize: 15,color: PaletteColor.darkGrey),),
            ),
            DropdownItens(
              streamBuilder: streamBrands(),
              onChanged: (valor){
                setState(() {
                  _selectedBrands = valor;
                });
              }
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Modelo',
                style: TextStyle(fontSize: 15,color: PaletteColor.darkGrey),),
            ),
            InputRegister(keyboardType: TextInputType.text, controller: _controllerModel, hint: 'Criar Modelo',width: width*0.7,fonts: 15,obscure: false,),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Referência',
                style: TextStyle(fontSize: 15,color: PaletteColor.darkGrey),),
            ),
            InputRegister(keyboardType: TextInputType.text, controller: _controllerRef, hint: 'Criar Referência',width: width*0.7,fonts: 15,obscure: false,),
            SizedBox(height: 50),
            ButtonsRegister(
                width: width*0.7,
                text: "Salvar nova referência",
                color: PaletteColor.green,
                onTap:(){
                  if(_controllerRef.text.isNotEmpty && _controllerModel.text.isNotEmpty && _selectedBrands!=null){
                    _registerRef();
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}
