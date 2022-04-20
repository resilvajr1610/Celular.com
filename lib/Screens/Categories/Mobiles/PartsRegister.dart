import 'dart:async';
import 'dart:io';
import 'package:celular/Model/MobilesModel.dart';
import 'package:celular/Model/PartsModel.dart';
import 'package:celular/widgets/buttonCamera.dart';
import 'package:celular/widgets/buttonsRegister.dart';
import 'package:celular/widgets/groupStock.dart';
import 'package:celular/widgets/inputRegister.dart';
import 'package:celular/widgets/textTitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Model/export.dart';
import '../../../widgets/dropDownItens.dart';

class PartsResgister extends StatefulWidget {
  const PartsResgister({Key key}) : super(key: key);

  @override
  _PartsResgisterState createState() => _PartsResgisterState();
}

class _PartsResgisterState extends State<PartsResgister> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  final _controllerBrands = StreamController<QuerySnapshot>.broadcast();
  final _controllerColors = StreamController<QuerySnapshot>.broadcast();
  final _controllerDisplay = StreamController<QuerySnapshot>.broadcast();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MobilesModel _mobilesModel;
  PartsModel _partsModel;
  TextEditingController _controllerModel = TextEditingController();
  TextEditingController _controllerRef = TextEditingController();
  TextEditingController _controllerStock = TextEditingController();
  TextEditingController _controllerStockMin = TextEditingController();
  TextEditingController _controllerPricePuschace = TextEditingController();
  TextEditingController _controllerPriceSale = TextEditingController();
  TextEditingController _controllerCodBattery = TextEditingController();
  bool visibility = false;
  bool visibilityScreen1 = true;
  bool visibilityScreen2 = false;
  bool visibilityScreen3 = false;
  bool visibilityScreen4 = false;
  bool visibilityScreen5 = false;
  bool visibilityScreen6 = false;
  bool visibilityScreen7 = false;
  bool visibilityScreen8 = false;
  bool visibilityScreen9 = false;
  bool visibilityScreen10 = false;
  bool visibilityScreen11 = false;
  bool visibilityScreen12 = false;
  bool visibilityScreen13 = false;
  bool visibilityScreen14 = false;
  bool visibilityScreen15 = false;
  bool visibilityScreen16 = false;
  bool visibilityScreen17 = false;
  bool visibilityScreen18 = false;
  bool visibilityScreen19 = false;
  bool visibilityScreen20 = false;
  bool _switchPCB = false;
  bool _showCamera = true;
  File photo;
  bool _updatePhoto = false;
  String _urlPhoto;
  String _selectedBrands;
  String _selectedUp;
  String _selectedLow;
  static double fonts=20.0;

  Future<Stream<QuerySnapshot>> _addListenerBrands()async{

    Stream<QuerySnapshot> stream = db
        .collection("marcas")
        .snapshots();

    stream.listen((data) {
      _controllerBrands.add(data);
    });
  }

  Future<Stream<QuerySnapshot>> _addListenerDisplay()async{

    Stream<QuerySnapshot> stream = db
        .collection("display")
        .snapshots();

    stream.listen((data) {
      _controllerDisplay.add(data);
    });
  }

  Future<Stream<QuerySnapshot>> _addListenerColors()async{

    Stream<QuerySnapshot> stream = db
        .collection("cores")
        .snapshots();

    stream.listen((data) {
      _controllerColors.add(data);
    });
  }

  Widget streamBrands() {
    return StreamBuilder<QuerySnapshot>(
      stream:_controllerBrands.stream,
      builder: (context,snapshot){

        if(snapshot.hasError)
          return Text("Erro ao carregar dados!");

        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
          case ConnectionState.done:

          if(!snapshot.hasData){
            Text("Carregando");
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

  Widget streamUp(final controller) {

    _addListenerDisplay();

    return StreamBuilder<QuerySnapshot>(
      stream:controller.stream,
      builder: (context,snapshot){

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            break;
          case ConnectionState.active:
          case ConnectionState.done:

          if(snapshot.hasError)
            return Text("Erro ao carregar dados!");

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
                  onChanged:(value){
                    setState(() {
                      _selectedUp = value;
                    });
                  },
                  value: _selectedUp,
                  isExpanded: false,
                  hint: new Text(
                    "Selecione",
                    style: TextStyle(color: PaletteColor.darkGrey ),
                  ),
                ),
              ],
            );
          }

        }
      },
    );
  }

  Widget streamLow(final controller) {

    _addListenerColors();

    return StreamBuilder<QuerySnapshot>(
      stream:controller.stream,
      builder: (context,snapshot) {

        if(snapshot.hasError)
          return Text("Erro ao carregar dados!");

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
          case ConnectionState.done:
            if (!snapshot.hasData) {
              Text("Carregando");
            } else {
              List<DropdownMenuItem> espItems = [];
              for (int i = 0; i < snapshot.data.docs.length; i++) {
                DocumentSnapshot snap = snapshot.data.docs[i];
                espItems.add(
                    DropdownMenuItem(
                      child: Text(
                        snap.id ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: PaletteColor.darkGrey),
                      ),
                      value: "${snap.id ?? ""}",
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
                        _selectedLow = value;
                      });
                    },
                    value: _selectedLow,
                    isExpanded: false,
                    hint: new Text(
                      "Selecione",
                      style: TextStyle(color: PaletteColor.darkGrey),
                    ),
                  ),
                ],
              );
            }
        }
      }
    );
  }

  Future _savePhoto(String namePhoto)async{
    setState(() {
      _showCamera=false;
    });
    if(namePhoto!=null && namePhoto!="" && _selectedBrands!=null && _selectedBrands!=""){
      try{
        final image = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 50);
        if(image ==null)return;

        final imageTemporary = File(image.path);
        setState(() {
          this.photo = imageTemporary;
          setState(() {
            _updatePhoto=true;
          });
          _uploadImage(namePhoto);
        });
      } on PlatformException catch (e){
        print('Error : $e');
      }
    }else{
        String text = 'Preencha os dados marca, modelo e referência para continuar';
        showSnackBar(context,text);
    }
  }

  void showSnackBar(BuildContext context, String text){
    final snackbar = SnackBar(
        backgroundColor: Colors.red,
        content: Row(
          children: [
            Icon(Icons.info_outline,color: Colors.white),
            SizedBox(width: 20),
            Expanded(
              child: Text(text,
                style: TextStyle(fontSize: 16),),
            ),
          ],
        ),
    );

    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Future _uploadImage(String namePhoto)async{
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
        .child("pecas")
        .child(_selectedBrands+"_"+namePhoto + ".jpg");

    UploadTask task = arquivo.putFile(photo);

    Future.delayed(const Duration(seconds: 6),()async{
      String urlImage = await task.snapshot.ref.getDownloadURL();
      if(urlImage!=null){
        _urlImageFirestore(urlImage,namePhoto);
        setState(() {
          _urlPhoto = urlImage;
          _updatePhoto=false;
          _showCamera=true;
        });
      }
    });
  }

  _urlImageFirestore(String url, String namePhoto){

    _partsModel = PartsModel.createId();

    Map<String,dynamic> dateUpdate = {
      "foto" : url,
      "item":_selectedBrands+"_"+_controllerModel.text+"_"+namePhoto,
      "id" : _partsModel.id,
    };

    db.collection("pecas")
        .doc(_partsModel.id)
        .set(dateUpdate);
  }

  _registerDatabase(String part){

    Map<String,dynamic> dateUpdate = {
      "selecionado1" : _selectedUp,
      "selecionado2" : _selectedLow,
      "estoque" : _controllerStock.text,
      "estoqueMinimo" : _controllerStockMin.text,
      "precoCompra" : _controllerPricePuschace.text,
      "precoVenda" : _controllerPriceSale.text,
      "referencia" : _controllerRef.text,
      "peca" : part,
      "marca": _selectedBrands,
      "item":_selectedBrands+"_"+_controllerModel.text+"_"+part
    };

    db.collection("pecas")
        .doc(_partsModel.id)
        .update(dateUpdate).then((_){
          db.collection('celulares')
            .doc(_controllerModel.text)
            .set({
            "celular":_controllerModel.text,
            "marca":_selectedBrands
          }).then((value){
            _controllerStock.clear();
            _controllerStockMin.clear();
            _controllerPricePuschace.clear();
            _controllerPriceSale.clear();
          });
    });
  }

  _registerPCB(String part){

    _mobilesModel = MobilesModel.createId();

    _mobilesModel.mobiles = _controllerModel.text;
    _mobilesModel.brands = _selectedBrands;

    db.collection('celularPesquisa')
      .doc(_mobilesModel.id)
      .set(_mobilesModel.toMap());

    Map<String,dynamic> dateUpdate = {
      "PCB" : _switchPCB?"sim":"não",
    };

    db.collection("pecas")
        .doc(_partsModel.id)
        .set(dateUpdate);
  }

  _registerBattery(String part){

    Map<String,dynamic> dateUpdate = {
      "codBateria" : _controllerCodBattery.text,
    };

    db.collection("celulares")
        .doc(_selectedBrands)
        .collection(_controllerModel.text)
        .doc(part)
        .update(dateUpdate);
  }

  @override
  void initState() {
    super.initState();
    _addListenerBrands();
    _addListenerColors();
    _addListenerDisplay();
    _partsModel = PartsModel();
    _mobilesModel = MobilesModel();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Cadastrar Modelo',
                  style: TextStyle(fontSize: 20,color: PaletteColor.darkGrey),),
              ),
              DropdownItens(
                  streamBuilder: streamBrands(),
                  onChanged: (valor){
                    setState(() {
                      _selectedBrands = valor;
                    });
                  }),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: width*0.6,
                    child: Column(
                      children: [
                        InputRegister(keyboardType: TextInputType.text, controller: _controllerModel, hint: 'Modelo',width: width*0.5,fonts: 20),
                        InputRegister(keyboardType: TextInputType.text, controller: _controllerRef, hint: 'Referências',width: width*0.5,fonts: 20),
                      ],
                    ),
                  ),
                  _urlPhoto!=null?_updatePhoto?Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: PaletteColor.darkGrey),
                      Text('Aguarde',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: PaletteColor.darkGrey),),
                    ],
                  ):Column(
                    children: [
                      Icon(Icons.check_circle_outline,color: Colors.green,),
                      Text('Foto enviada!',style: TextStyle(color: Colors.green),)
                    ],
                  ):ButtonCamera(
                      onTap: ()=> _savePhoto(_controllerModel.text),
                      width: width*0.3
                  )
                ],
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                visible: visibilityScreen1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextTitle(text: 'PCB', fonts: fonts),
                          SizedBox(width: 20),
                          TextTitle(text: 'Não', fonts: 14),
                          Switch(
                              activeColor: PaletteColor.blueButton,
                              value: _switchPCB,
                              onChanged: (bool value){
                                setState(() {
                                  _switchPCB = value;
                                });
                              }
                          ),
                          TextTitle(text: 'Sim', fonts: 14),
                        ],
                      ),
                      GroupStock(
                          title: 'Display',
                          subtitle: 'Cor',
                          fontsTitle: 16,
                          fontsSubtitle: 14,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: true,
                          showDropDownLow: true,
                          //display
                          streamBuilderUp: streamUp(_controllerDisplay),
                          //color
                          streamBuilderLow: streamLow(_controllerColors),
                          onChangedUp: (value){
                            setState(() {
                              _selectedUp = value.toString();
                            });
                          },
                          onChangedLow: (value){
                            setState(() {
                              _selectedLow = value.toString();
                            });
                          },
                          selectedUp: _selectedUp,
                          selectedLow: _selectedLow,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=> _savePhoto('Display-$_selectedLow'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      ButtonsRegister(
                          text: "Salvar",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Display-$_selectedLow');
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                            && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                            && _controllerStock.text!="" && _controllerStock.text !=null
                            && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                            && _selectedUp!="" &&_selectedUp !=null
                            && _selectedLow!="" &&_selectedLow !=null
                            && _controllerRef.text!="" &&_controllerRef.text !=null
                            && _selectedBrands!="" && _selectedBrands!=null
                            && _selectedUp!="" && _selectedUp!=null
                            && _selectedLow!="" && _selectedLow!=null
                            && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Display-$_selectedLow');
                              _registerPCB('PCB');
                              setState(() {
                                visibilityScreen1=false;
                                visibilityScreen2=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                visible: visibilityScreen2,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Película 3D',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Película 3D'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Película 3D');
                              setState(() {
                                visibilityScreen2=false;
                                visibilityScreen3=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen3,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Película 3D Privativa',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Película 3D Privativa'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              setState(() {
                                _registerDatabase('Película 3D Privativa');
                                visibilityScreen3=false;
                                visibilityScreen4=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen4,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Película de Vidro',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Película de Vidro'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: _showCamera
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Película de Vidro');
                              setState(() {
                                visibilityScreen4=false;
                                visibilityScreen5=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen5,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Case Original',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Case Original'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              setState((){
                                _registerDatabase('Case Original');
                                visibilityScreen5=false;
                                visibilityScreen6=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen6,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Case TPU',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Case TPU'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Case TPU');
                              setState(() {
                                visibilityScreen6=false;
                                visibilityScreen7=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen7,
                  child: Column(
                    children: [
                      ButtonsRegister(
                          text: "Salvar",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Cores de Tampa-$_selectedLow');
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                      GroupStock(
                          title: 'Cores de Tampa',
                          subtitle: 'Cor',
                          fontsTitle: 16,
                          width: width*0.5,
                          streamBuilderLow: streamLow(_controllerColors),
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: true,
                          onChangedLow: (value){
                            setState(() {
                              _selectedLow = value.toString();
                            });
                          },
                          selectedLow: _selectedLow,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Cores de Tampa-$_selectedLow'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Cores de Tampa-$_selectedLow');
                              setState(() {
                                visibilityScreen7=false;
                                visibilityScreen8=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen8,
                  child: Column(
                    children: [
                      ButtonsRegister(
                          text: "Salvar",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Cores de Chassi-$_selectedLow');
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                      GroupStock(
                          title: 'Cores de Chassi',
                          subtitle: 'Cor',
                          fontsTitle: 16,
                          width: width*0.5,
                          streamBuilderLow: streamLow(_controllerColors),
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: true,
                          onChangedLow: (value){
                            setState(() {
                              _selectedLow = value.toString();
                            });
                          },
                          selectedLow: _selectedLow,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Cores de Chassi-$_selectedLow'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){

                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Cores de Chassi-$_selectedLow');
                              setState(() {
                                visibilityScreen8=false;
                                visibilityScreen9=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen9,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Conector de Carga',
                          fontsTitle: 16,
                          width: width*0.5,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Conector de Carga'),
                          showStockmin: true,
                          showCod: false,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){

                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Conector de Carga');
                              setState(() {
                                visibilityScreen9=false;
                                visibilityScreen10=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen10,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Dock de Carga',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Dock de Carga'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){

                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Dock de Carga');
                              setState(() {
                                visibilityScreen10=false;
                                visibilityScreen11=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen11,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Bateria',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: true,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerCod: _controllerCodBattery,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Bateria'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                                && _controllerCodBattery.text!="" &&_controllerCodBattery.text !=null
                            ){
                              _registerDatabase('Bateria');
                              _registerBattery('Bateria');

                              setState(() {
                                visibilityScreen11=false;
                                visibilityScreen12=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen12,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Flex Power',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Flex Power'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Flex Power');
                              setState(() {
                                visibilityScreen12=false;
                                visibilityScreen13=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen13,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Digital',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Digital'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){

                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Digital');
                              setState(() {
                                visibilityScreen13=false;
                                visibilityScreen14=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen14,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Lente da Câmera',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Lente da Câmera'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){

                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Lente da câmera');
                              setState(() {
                                visibilityScreen14=false;
                                visibilityScreen15=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen15,
                  child: Column(
                    children: [
                      ButtonsRegister(
                          text: "Salvar",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Gaveta do chip-$_selectedLow');
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                      GroupStock(
                          title: 'Gaveta do chip',
                          subtitle: 'Cor',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: true,
                          onChangedLow: (value){
                            setState(() {
                              _selectedLow = value.toString();
                            });
                          },
                          selectedLow: _selectedLow,
                          streamBuilderLow: streamLow(_controllerColors),
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Gaveta do chip-$_selectedLow'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Gaveta do chip-$_selectedLow');
                              setState(() {
                                visibilityScreen15=false;
                                visibilityScreen16=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen16,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Câmera Frontal',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Câmera Frontal'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Câmera Frontal');
                              setState(() {
                                visibilityScreen16=false;
                                visibilityScreen17=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen17,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Câmera Traseira',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Câmera Traseira'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Câmera Traseira');
                              setState(() {
                                visibilityScreen17=false;
                                visibilityScreen18=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen18,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Falante Auricular',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Falante Auricular'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Falante Auricular');
                              setState(() {
                                visibilityScreen18=false;
                                visibilityScreen19=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen19,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Campainha',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Campainha'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Próximo",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Campainha');
                              setState(() {
                                visibilityScreen19=false;
                                visibilityScreen20=true;
                              });
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
              _updatePhoto?Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PaletteColor.darkGrey),
                    Text('Aguarde',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey),),
                  ],
                ),
              ):Visibility(
                  visible: visibilityScreen20,
                  child: Column(
                    children: [
                      GroupStock(
                          title: 'Flex Sub Placa',
                          fontsTitle: 16,
                          width: width*0.5,
                          showCod: false,
                          showDropDownUp: false,
                          showDropDownLow: false,
                          controllerPricePuschace: _controllerPricePuschace,
                          controllerPriceSale: _controllerPriceSale,
                          controllerStock: _controllerStock,
                          controllerStockMin: _controllerStockMin,
                          onTapCamera: ()=>_savePhoto('Flex Sub Placa'),
                          showStockmin: true,
                          showPrice: true,
                          titlePrice: 'Preço Venda',
                          showCamera: true
                      ),
                      SizedBox(height: 10),
                      ButtonsRegister(
                          text: "Finalizar",
                          color: PaletteColor.blueButton,
                          onTap: (){
                            if(_controllerPricePuschace.text!="" && _controllerPricePuschace.text != null
                                && _controllerPriceSale.text!="" && _controllerPriceSale.text !=null
                                && _controllerStock.text!="" && _controllerStock.text !=null
                                && _controllerStockMin.text!="" && _controllerStockMin.text !=null
                                && _selectedUp!="" &&_selectedUp !=null
                                && _selectedLow!="" &&_selectedLow !=null
                                && _controllerRef.text!="" &&_controllerRef.text !=null
                                && _selectedBrands!="" && _selectedBrands!=null
                                && _selectedUp!="" && _selectedUp!=null
                                && _selectedLow!="" && _selectedLow!=null
                                && _controllerModel.text!="" &&_controllerModel.text !=null
                            ){
                              _registerDatabase('Flex Sub Placa');
                              Navigator.pushReplacementNamed(context, "/mobiles");
                            }else{
                              String text = 'Preencha todos os dados corretamente para continuar';
                              showSnackBar(context,text);
                            }
                          }
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}