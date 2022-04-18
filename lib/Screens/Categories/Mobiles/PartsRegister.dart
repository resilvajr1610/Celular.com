import 'dart:async';
import 'dart:io';
import 'package:celular/widgets/buttonCamera.dart';
import 'package:celular/widgets/buttonsAdd.dart';
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
  bool _switchProduct = false;
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
                    _selectedBrands = value;
                  });
                },
                value: _selectedBrands,
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
    );
  }

  Widget streamUp(final controller) {
    return StreamBuilder<QuerySnapshot>(
      stream:controller.stream,
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
      },
    );
  }

  Widget streamLow(final controller) {
    return StreamBuilder<QuerySnapshot>(
      stream:controller.stream,
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
                onChanged:(value){
                  setState(() {
                    _selectedLow = value;
                  });
                },
                value: _selectedLow,
                isExpanded: false,
                hint: new Text(
                  "Selecione",
                  style: TextStyle(color: PaletteColor.darkGrey ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future _savePhoto(String namePhoto)async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
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
  }
  Future _uploadImage(String namePhoto)async{
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
        .child("celulares")
        .child(namePhoto + ".jpg");

    UploadTask task = arquivo.putFile(photo);

    Future.delayed(const Duration(seconds: 3),()async{
      String urlImage = await task.snapshot.ref.getDownloadURL();
      if(urlImage!=null){
        _urlImageFirestore(urlImage,namePhoto);
        setState(() {
          _urlPhoto = urlImage;
          _updatePhoto=false;
        });
      }
    });
  }

  _urlImageFirestore(String url, String namePhoto){

    Map<String,dynamic> dateUpdate = {
      namePhoto : url
    };

    db.collection("celulares")
        .doc(namePhoto)
        .update(dateUpdate);
  }

  @override
  void initState() {
    super.initState();
    _addListenerBrands();
    _addListenerColors();
    _addListenerDisplay();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                        InputRegister(controller: _controllerModel, hint: 'Modelo',width: width*0.5,fonts: 20),
                        InputRegister(controller: _controllerRef, hint: 'Referências',width: width*0.5,fonts: 20),
                      ],
                    ),
                  ),
                  ButtonCamera(
                      onTap: ()=>{},
                      width: width*0.3
                  )
                ],
              ),
              Visibility(
                visible: visibilityScreen1,
                  child: Column(
                    children: [
                      ButtonsAdd(onPressed: (){}),
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
                          onTapCamera: ()=> _savePhoto(_controllerModel.text),
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
                            setState(() {
                              visibilityScreen1=false;
                              visibilityScreen2=true;
                            });
                          }
                      ),
                    ],
                  )
              ),
              // Visibility(
              //   visible: visibilityScreen2,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Película 3D',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             onChangedUp: (value){
              //               setState(() {
              //                 _selectedDisplay = value.toString();
              //               });
              //             },
              //             onChangedLow: (value){
              //               setState(() {
              //                 _selectedColors = value.toString();
              //               });
              //             },
              //             selectedUp: _selectedDisplay,
              //             selectedLow: _selectedColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen2=false;
              //                 visibilityScreen3=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen3,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Película 3D Privativa',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             onChangedUp: (value){
              //               setState(() {
              //                 _selectedDisplay = value.toString();
              //               });
              //             },
              //             onChangedLow: (value){
              //               setState(() {
              //                 _selectedColors = value.toString();
              //               });
              //             },
              //             selectedUp: _selectedDisplay,
              //             selectedLow: _selectedColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen3=false;
              //                 visibilityScreen4=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen4,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Película de Vidro',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             onChangedUp: (value){
              //               setState(() {
              //                 _selectedDisplay = value.toString();
              //               });
              //             },
              //             onChangedLow: (value){
              //               setState(() {
              //                 _selectedColors = value.toString();
              //               });
              //             },
              //             selectedUp: _selectedDisplay,
              //             selectedLow: _selectedColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen4=false;
              //                 visibilityScreen5=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen5,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Case Original',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             onChangedUp: (value){
              //               setState(() {
              //                 _selectedDisplay = value.toString();
              //               });
              //             },
              //             onChangedLow: (value){
              //               setState(() {
              //                 _selectedColors = value.toString();
              //               });
              //             },
              //             selectedUp: _selectedDisplay,
              //             selectedLow: _selectedColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen5=false;
              //                 visibilityScreen6=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen6,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Case TPU',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             onChangedUp: (value){
              //               setState(() {
              //                 _selectedDisplay = value.toString();
              //               });
              //             },
              //             onChangedLow: (value){
              //               setState(() {
              //                 _selectedColors = value.toString();
              //               });
              //             },
              //             selectedUp: _selectedDisplay,
              //             selectedLow: _selectedColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen6=false;
              //                 visibilityScreen7=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen7,
              //     child: Column(
              //       children: [
              //         ButtonsAdd(onPressed: (){}),
              //         GroupStock(
              //             title: 'Cores de Tampa',
              //             subtitle: 'Cor',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             listItensLow: _listItensColors,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: true,
              //             onChangedLow: (value){
              //               setState(() {
              //                 _selectedColors = value.toString();
              //               });
              //             },
              //             selectedLow: _selectedColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen7=false;
              //                 visibilityScreen8=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen8,
              //     child: Column(
              //       children: [
              //         ButtonsAdd(onPressed: (){}),
              //         GroupStock(
              //             title: 'Cores de Chassi',
              //             subtitle: 'Cor',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             listItensLow: _listItensColors,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: true,
              //             onChangedLow: (value){
              //               setState(() {
              //                 _selectedColors = value.toString();
              //               });
              //             },
              //             selectedLow: _selectedColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen8=false;
              //                 visibilityScreen9=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen9,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Conector de Carga',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             listItensLow: _listItensColors,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showCod: false,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen9=false;
              //                 visibilityScreen10=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen10,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Dock de Carga',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             controllerCod: _controllerCodBattery,
              //             listItensLow: _listItensColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen10=false;
              //                 visibilityScreen11=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen11,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Bateria',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: true,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             controllerCod: _controllerCodBattery,
              //             listItensLow: _listItensColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen11=false;
              //                 visibilityScreen12=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen12,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Flex Power',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             controllerCod: _controllerCodBattery,
              //             listItensLow: _listItensColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen12=false;
              //                 visibilityScreen13=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen13,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Digital',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             controllerCod: _controllerCodBattery,
              //             listItensLow: _listItensColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen13=false;
              //                 visibilityScreen14=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen14,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Lente de Câmera',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             controllerCod: _controllerCodBattery,
              //             listItensLow: _listItensColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen14=false;
              //                 visibilityScreen15=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen15,
              //     child: Column(
              //       children: [
              //         ButtonsAdd(onPressed: (){}),
              //         GroupStock(
              //             title: 'Gaveta do chip',
              //             subtitle: 'Cor',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: true,
              //             onChangedLow: (value){
              //               setState(() {
              //                 _selectedColors = value.toString();
              //               });
              //             },
              //             selectedLow: _selectedColors,
              //             controllerCod: _controllerCodBattery,
              //             listItensLow: _listItensColors,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen15=false;
              //                 visibilityScreen16=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen16,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Câmera Frontal',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen16=false;
              //                 visibilityScreen17=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen17,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Câmera Traseira',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen17=false;
              //                 visibilityScreen18=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen18,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Falante Auricular',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen18=false;
              //                 visibilityScreen19=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen19,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Campainha',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Próximo",
              //             color: PaletteColor.blueButton,
              //             onTap: (){
              //               setState(() {
              //                 visibilityScreen19=false;
              //                 visibilityScreen20=true;
              //               });
              //             }
              //         ),
              //       ],
              //     )
              // ),
              // Visibility(
              //     visible: visibilityScreen20,
              //     child: Column(
              //       children: [
              //         GroupStock(
              //             title: 'Flex Sub Placa',
              //             fontsTitle: 16,
              //             width: width*0.5,
              //             showCod: false,
              //             showDropDownUp: false,
              //             showDropDownLow: false,
              //             controllerPricePuschace: _controllerPricePuschace,
              //             controllerPriceSale: _controllerPriceSale,
              //             controllerStock: _controllerStock,
              //             controllerStockMin: _controllerStockMin,
              //             onTapCamera: ()=>{},
              //             showStockmin: true,
              //             showPrice: true,
              //             titlePrice: 'Preço Venda',
              //             showCamera: true
              //         ),
              //         SizedBox(height: 10),
              //         ButtonsRegister(
              //             text: "Finalizar",
              //             color: PaletteColor.blueButton,
              //             onTap: ()=> Navigator.pushNamed(context, "/parts")
              //         ),
              //       ],
              //     )
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
