import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Model/colors.dart';
import '../../../Utils/export.dart';
import '../../../widgets/buttonCamera.dart';
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
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var _controllerModel = TextEditingController();
  var _controllerRef = TextEditingController();
  String _selectedBrands;
  bool sendPhoto = false;
  File photo;
  String _urlPhoto = '';

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

      db.collection("ref")
        .doc(_controllerRef.text)
        .set({
          'ref' : _controllerRef.text,
          'modelo':_controllerModel.text,
          'marca': _selectedBrands
        },SetOptions(merge: true))
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

  Future _savePhoto()async{
      try{
        final image = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 50);
        if(image ==null)return;
        final imageTemporary = File(image.path);
        setState(() {
          this.photo = imageTemporary;
          setState(() {
            sendPhoto=true;
          });
          _uploadImage();
        });
      } on PlatformException catch (e){
        print('Error : $e');
      }
  }

  Future _uploadImage()async{
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
        .child("ref")
        .child("${DateTime.now().toString()}.jpg");

    UploadTask task = arquivo.putFile(photo);

    Future.delayed(const Duration(seconds: 6),()async{
      String urlImage = await task.snapshot.ref.getDownloadURL();
      if(urlImage!=null){
        _urlImageFirestore(urlImage);
        setState(() {
          _urlPhoto = urlImage;
        });
      }
    });
  }

  _urlImageFirestore(String url){

    Map<String,dynamic> dateUpdate = {
      "foto" : url,
    };
    db.collection("ref")
        .doc(_controllerRef.text)
        .set(dateUpdate,SetOptions(merge: true)).then((value){
          setState(() {
            sendPhoto=false;
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
            SizedBox(height: 15),
            sendPhoto
            ?Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Foto sendo enviada ...')
              ],
            ):Container(),
            _urlPhoto==''?ButtonCamera(
                onTap: (){
                  if(_controllerRef.text.isNotEmpty && _controllerModel.text.isNotEmpty && _selectedBrands!=null) {
                    _savePhoto();
                  }else{
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: Center(child: Text('Erro')),
                            titleTextStyle: TextStyle(color: PaletteColor.darkGrey,fontSize: 20),
                            content: Row(
                              children: [
                                Expanded(
                                    child:  Text('Preencha todos os campos corretamente para salvar a foto')
                                ),
                              ],
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                            actions: [
                              ElevatedButton(
                                  onPressed: ()=>Navigator.pop(context),
                                  child: Text('OK')
                              )
                            ],
                          );
                        });
                  }
                },
                width: width*0.2
            ):Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(_urlPhoto,
                  width: 200,
                  height: 200,
                  errorBuilder: (BuildContext context,
                      Object exception, StackTrace stackTrace) {
                    return Container(height: 150,
                        width: 150,
                        child: Icon(Icons.do_not_disturb));
                  },
                ),
              ),
            ),
            SizedBox(height: 15),
            ButtonsRegister(
                width: width*0.7,
                text: "Salvar nova referência",
                color: PaletteColor.green,
                onTap:(){
                  if(_controllerRef.text.isNotEmpty && _controllerModel.text.isNotEmpty && _selectedBrands!=null){
                    _registerRef();
                  }else{
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: Center(child: Text('Erro')),
                            titleTextStyle: TextStyle(color: PaletteColor.darkGrey,fontSize: 20),
                            content: Row(
                              children: [
                                Expanded(
                                    child:  Text('Preencha todos os campos corretamente para salvar os dados')
                                ),
                              ],
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                            actions: [
                              ElevatedButton(
                                  onPressed: ()=>Navigator.pop(context),
                                  child: Text('OK')
                              )
                            ],
                          );
                        });
                  }
                }
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
