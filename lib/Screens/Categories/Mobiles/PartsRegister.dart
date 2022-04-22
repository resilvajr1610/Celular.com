import 'dart:async';
import 'dart:io';
import 'package:celular/Model/MobilesModel.dart';
import 'package:celular/Model/PartsModel.dart';
import 'package:celular/widgets/controlRegisterParts.dart';
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
  static double fonts=20.0;
  bool _updatePhoto = false;
  bool _switchPCB = false;
  bool _showCamera = true;
  bool _sendPhoto=false;
  File photo;
  String _urlPhoto;
  String _selectedBrands;
  String _selectedUp;
  String _selectedLow;
  int _cont=1;

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

  Widget streamUp(final controller) {

    _addListenerDisplay();

    return StreamBuilder<QuerySnapshot>(
      stream:controller.stream,
      builder: (context,snapshot){

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container();
            break;
          case ConnectionState.active:
          case ConnectionState.done:

          if(snapshot.hasError)
            return Text("Erro ao carregar dados!");

          if(!snapshot.hasData){
            return Container();
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
              return Container();
              break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
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
            _sendPhoto=true;
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

  _registerMobile(){
    _mobilesModel = MobilesModel.createId();

    _mobilesModel.mobiles = _controllerModel.text;
    _mobilesModel.brands = _selectedBrands;

    db.collection('celularPesquisa')
        .doc(_mobilesModel.id)
        .set(_mobilesModel.toMap());
  }

  _registerDatabase(String part,String description,String color){

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
        && _sendPhoto
    ){
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
        "item":_selectedBrands+"_"+_controllerModel.text+"_"+part,
        "modelo":_controllerModel.text,
        "descricao":description,
        "cor":color,
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
          setState(() {
            _controllerStock.clear();
            _controllerStockMin.clear();
            _controllerPricePuschace.clear();
            _controllerPriceSale.clear();
            description="";
            color="";
            part="";
            _sendPhoto=false;
          });
        });
      });
    }else{
      String text = 'Preencha todos os dados e foto para continuar';
      showSnackBar(context,text);
    }
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

  _back(){
    setState(() {
      _cont--;
    });
  }

  _forward(){
    setState(() {
      _cont++;
    });
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
          child: _updatePhoto?Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: PaletteColor.darkGrey),
                TextTitle(text: 'Salvando foto...', fonts: fonts)
              ],
            ),
          ):Column(
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
              InputRegister(keyboardType: TextInputType.text, controller: _controllerModel, hint: 'Modelo',width: width*0.7,fonts: 20),
              InputRegister(keyboardType: TextInputType.text, controller: _controllerRef, hint: 'Referências',width: width*0.7,fonts: 20),
              _cont==1?Column(
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
                      sendPhoto: _sendPhoto,
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Preço Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: null,
                      onPressedForward: _forward,
                      onTapRegister: (){
                        _registerMobile();
                        _registerDatabase('Display-$_selectedLow','Display',_selectedLow);
                      }
                  ),
                ],
              ):Container(),
              _cont==2?Column(
                children: [
                  GroupStock(
                      title: 'Película 3D',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Película 3D','Película 3D',"")
                  ),
                ],
              ):Container(),
              _cont==3?Column(
                children: [
                  GroupStock(
                      title: 'Película 3D Privativa',
                      fontsTitle: 16,
                      width: width*0.5,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Película 3D Privativa','Película 3D Privativa',"")
                  ),
                ],
              ):Container(),
              _cont==4?Column(
                children: [
                  GroupStock(
                      title: 'Película de Vidro',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=> _registerDatabase('Película de Vidro','Película de Vidro',"")
                  ),
                ],
              ):Container(),
              _cont==5?Column(
                children: [
                  GroupStock(
                      title: 'Case Original',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Case Original','Case Original',"")
                  ),
                ],
              ):Container(),
              _cont==6?Column(
                children: [
                  GroupStock(
                      title: 'Case TPU',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Case TPU','Case TPU',"")
                  ),
                ],
              ):Container(),
              _cont==7?Column(
                children: [
                  GroupStock(
                      title: 'Cores de Tampa',
                      subtitle: 'Cor',
                      fontsTitle: 16,
                      width: width*0.5,
                      streamBuilderLow: streamLow(_controllerColors),
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Cores de Tampa-$_selectedLow',"Cores de Tampa",_selectedLow)
                  ),
                ],
              ):Container(),
              _cont==8?Column(
                children: [
                  GroupStock(
                      title: 'Cores de Chassi',
                      subtitle: 'Cor',
                      fontsTitle: 16,
                      width: width*0.5,
                      streamBuilderLow: streamLow(_controllerColors),
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Cores de Chassi-$_selectedLow',"Cores de Chassi",_selectedLow)
                  ),
                ],
              ):Container(),
              _cont==9?Column(
                children: [
                  GroupStock(
                      title: 'Conector de Carga',
                      fontsTitle: 16,
                      width: width*0.5,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Conector de Carga','Conector de Carga',"")
                  ),
                ],
              ):Container(),
              _cont==10?Column(
                children: [
                  GroupStock(
                      title: 'Dock de Carga',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Dock de Carga','Dock de Carga',"")
                  ),
                ],
              ):Container(),
              _cont==11?Column(
                children: [
                  GroupStock(
                      title: 'Bateria',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: true,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: (){
                        _registerDatabase('Bateria','Bateria',"");
                        _registerBattery('Bateria');
                      }
                  ),
                ],
              ):Container(),
              _cont==12?Column(
                children: [
                  GroupStock(
                      title: 'Flex Power',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Flex Power','Flex Power',"")
                  ),
                ],
              ):Container(),
              _cont==13?Column(
                children: [
                  GroupStock(
                      title: 'Digital',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Digital','Digital',"")
                  ),
                ],
              ):Container(),
              _cont==14?Column(
                children: [
                  GroupStock(
                      title: 'Lente da Câmera',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Lente da câmera','Lente da câmera',"")
                  ),
                ],
              ):Container(),
              _cont==15?Column(
                children: [
                  GroupStock(
                      title: 'Gaveta do chip',
                      subtitle: 'Cor',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=> _registerDatabase('Gaveta do chip-$_selectedLow','Gaveta do chip',_selectedLow)
                  ),
                ],
              ):Container(),
              _cont==16?Column(
                children: [
                  GroupStock(
                      title: 'Câmera Frontal',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Câmera Frontal','Câmera Frontal',"")
                  ),
                ],
              ):Container(),
              _cont==17?Column(
                children: [
                  GroupStock(
                      title: 'Câmera Traseira',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Câmera Traseira','Câmera Traseira',"")
                  ),
                ],
              ):Container(),
              _cont==18?Column(
                children: [
                  GroupStock(
                      title: 'Falante Auricular',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Falante Auricular','Falante Auricular',"")
                  ),
                ],
              ):Container(),
              _cont==19?Column(
                children: [
                  GroupStock(
                      title: 'Campainha',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Campainha','Campainha',"")
                  ),
                ],
              ):Container(),
              _cont==20?Column(
                children: [
                  GroupStock(
                      title: 'Flex Sub Placa',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: null,
                      onTapRegister: (){
                        _registerDatabase('Flex Sub Placa','Flex Sub Placa',"");
                        Navigator.pushReplacementNamed(context, "/mobiles");
                      }
                  ),
                ],
              ):Container(),
            ],
          ),
        ),
      ),
    );
  }
}