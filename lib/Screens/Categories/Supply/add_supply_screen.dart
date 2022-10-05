import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Model/colors.dart';
import '../../../widgets/buttonsRegister.dart';
import '../../../widgets/dropDownItens.dart';
import '../../../widgets/inputRegister.dart';

class AddSupplyScreen extends StatefulWidget {
  const AddSupplyScreen({Key key}) : super(key: key);

  @override
  State<AddSupplyScreen> createState() => _AddSupplyScreenState();
}

class _AddSupplyScreenState extends State<AddSupplyScreen> {

  var _controllerSupply = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  _registerSupply(){

    db
        .collection("supply")
        .doc(_controllerSupply.text)
        .set({
          'supply' : _controllerSupply.text,
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
                    onPressed: ()=>Navigator.pushReplacementNamed(context, "/supply"),
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
        title: Text('ADICIONAR FORNECEDORES',style: TextStyle(fontSize: 13),),
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
              child: Text('Nome',
                style: TextStyle(fontSize: 15,color: PaletteColor.darkGrey),),
            ),
            InputRegister(keyboardType: TextInputType.text, controller: _controllerSupply, hint: '',width: width*0.7,fonts: 15,obscure: false,),
            SizedBox(height: 50),
            ButtonsRegister(
                width: width*0.7,
                text: "Salvar",
                color: PaletteColor.green,
                onTap:(){
                  if(_controllerSupply.text.isNotEmpty){
                    _registerSupply();
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}
