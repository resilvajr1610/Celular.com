import '../../../Model/export.dart';

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
  PartsModel _partsModel;
  ColorsModel _colorsModel;
  TextEditingController _controllerModel = TextEditingController();
  TextEditingController _controllerRef = TextEditingController();
  TextEditingController _controllerStock = TextEditingController();
  TextEditingController _controllerStockMin = TextEditingController();
  TextEditingController _controllerPricePuschace = TextEditingController();
  TextEditingController _controllerPriceSale = TextEditingController();
  TextEditingController _controllerCodBattery = TextEditingController();
  TextEditingController _controllerRegister = TextEditingController();
  static double fonts=20.0;
  UpdatesModel _updatesModel;
  bool _updatePhoto = false;
  bool _switchPCB = false;
  bool _showCamera = true;
  bool _sendPhoto=false;
  bool _sendData=false;
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
        String text = 'Preencha os dados marca, modelo e refer??ncia para continuar';
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

    Map<String,dynamic> dateUpdate = {
      "foto" : url,
    };

    db.collection("pecas")
        .doc(_partsModel.id)
        .update(dateUpdate).then((value) => _sendData=false);
  }

  _registerDatabase(String part,String description,String color){

    _partsModel = PartsModel.createId();


    Map<String,dynamic> dateUpdate = part!="PCB"?{
      "selecionado1" : _selectedUp,
      "selecionado2" : _selectedLow,
      "estoque" : _controllerStock.text,
      "estoqueMinimo" : _controllerStockMin.text,
      "precoCompra" : _controllerPricePuschace.text,
      "precoVenda" : _controllerPriceSale.text,
      "referencia" : _controllerRef.text,
      "peca" : part,
      "marca": _selectedBrands,
      "item":_selectedBrands+"_"+_controllerModel.text+"_"+part+"_"+_controllerRef.text,
      "modelo":_controllerModel.text,
      "descricao":description,
      "cor":color,
      "id":_partsModel.id
    }:{
      "marca": _selectedBrands,
      "peca" : part,
      "descricao":description,
      "modelo":_controllerModel.text,
      "item":_selectedBrands+"_"+_controllerModel.text+"_"+part+"_"+_controllerRef.text,
      "selecionado1" : "N/A",
      "selecionado2" : "N/A",
      "estoque" : "0",
      "estoqueMinimo" : "0",
      "precoCompra" : "0",
      "precoVenda" : "0",
      "referencia" : part,
      "cor":"Branco",
      "foto":"",
      "id":_partsModel.id
    };

    if(part=="PCB"){
      db.collection("pecas")
          .doc(_partsModel.id)
          .set(dateUpdate);

    }else{

      _updatesModel = UpdatesModel.createId();
      _updatesModel.type = 'entrada';
      _updatesModel.quantity = _controllerStock.text;
      _updatesModel.part = part;
      _updatesModel.brand = _selectedBrands;
      _updatesModel.date = DateTime.now().toString();
      _updatesModel.price = _controllerPriceSale.text;
      _updatesModel.item = _selectedBrands+"_"+_controllerModel.text+"_"+part+"_"+_controllerRef.text;

      db.collection("pecas")
          .doc(_partsModel.id)
          .set(dateUpdate).then((_){
        db.collection('celulares')
            .doc(_controllerModel.text)
            .set({
          "celular":_controllerModel.text,
          "marca":_selectedBrands

        }).then((value){

          db.collection("historicoPrecos")
              .doc(_updatesModel.id)
              .set(_updatesModel.toMap());

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
            _sendData=true;
          });
        });
      });
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

  _showDialogRegister() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ShowDialogRegister(
            title: 'Cadastrar Cor',
            hint: 'Nova Cor',
            controllerRegister: _controllerRegister,
            list: [
              ButtonsRegister(
                  onTap: () => Navigator.pop(context),
                  text: 'Cancelar',
                  color: PaletteColor.greyButton),
              ButtonsRegister(
                  onTap: () => _registerColors(),
                  text: 'Incluir',
                  color: PaletteColor.blueButton),
            ],
          );
        });
  }

  _registerColors(){
    _colorsModel = ColorsModel.createId();

    _colorsModel.color = _controllerRegister.text;

    db
        .collection("cores")
        .doc(_colorsModel.color)
        .set(_colorsModel.toMap())
        .then((value) {
      db
          .collection('corPesquisa')
          .doc(_colorsModel.id)
          .set(_colorsModel.toMap())
          .then((value) {
        Navigator.pop(context);
        _controllerRegister.clear();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _addListenerBrands();
    _addListenerColors();
    _addListenerDisplay();
    _partsModel = PartsModel();
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
        title: Text('PE??AS'),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: 55,
            child: Image.asset("assets/logoBig.png"),
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
              InputRegister(keyboardType: TextInputType.text, controller: _controllerModel, hint: 'Modelo',width: width*0.7,fonts: 20,obscure: false,),
              InputRegister(keyboardType: TextInputType.text, controller: _controllerRef, hint: 'Refer??ncias',width: width*0.7,fonts: 20,obscure: false,),
              _cont==1?Column(
                children: [
                  Row(
                    children: [
                      TextTitle(text: 'PCB', fonts: fonts),
                      SizedBox(width: 20),
                      TextTitle(text: 'N??o', fonts: 14),
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_switchPCB?_registerDatabase('PCB','PCB',""):null
                  ),
                ],
              ):Container(),
              _cont==2?Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: ButtonsRegister(
                      text: "Nova cor",
                      color: PaletteColor.blueButton,
                      onTap: ()=>_showDialogRegister(),
                    ),
                  ),
                  GroupStock(
                      title: 'Display',
                      subtitle: 'Cor',
                      sendData: _sendData,
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
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: null,
                      onPressedForward: _forward,
                      onTapRegister: (){
                        _registerDatabase('Display-$_selectedLow','Display',_selectedLow);
                      }
                  ),
                ],
              ):Container(),
              _cont==3?Column(
                children: [
                  GroupStock(
                      title: 'Pel??cula 3D',
                      fontsTitle: 16,
                      width: width*0.5,
                      sendData: _sendData,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Pel??cula 3D'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Pel??cula 3D','Pel??cula 3D',"")
                  ),
                ],
              ):Container(),
              _cont==4?Column(
                children: [
                  GroupStock(
                      title: 'Pel??cula 3D Privativa',
                      fontsTitle: 16,
                      width: width*0.5,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showCod: false,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Pel??cula 3D Privativa'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Pel??cula 3D Privativa','Pel??cula 3D Privativa',"")
                  ),
                ],
              ):Container(),
              _cont==5?Column(
                children: [
                  GroupStock(
                      title: 'Pel??cula de Vidro',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Pel??cula de Vidro'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: _showCamera
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=> _registerDatabase('Pel??cula de Vidro','Pel??cula de Vidro',"")
                  ),
                ],
              ):Container(),
              _cont==6?Column(
                children: [
                  GroupStock(
                      title: 'Case Original',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Case Original'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Case Original','Case Original',"")
                  ),
                ],
              ):Container(),
              _cont==7?Column(
                children: [
                  GroupStock(
                      title: 'Case TPU',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Case TPU'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Case TPU','Case TPU',"")
                  ),
                ],
              ):Container(),
              _cont==8?Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: ButtonsRegister(
                      text: "Nova cor",
                      color: PaletteColor.blueButton,
                      onTap: ()=>_showDialogRegister(),
                    ),
                  ),
                  GroupStock(
                      title: 'Tampa',
                      subtitle: 'Cor',
                      fontsTitle: 16,
                      width: width*0.5,
                      streamBuilderLow: streamLow(_controllerColors),
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
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
                      onTapCamera: ()=>_savePhoto('Tampa_$_selectedLow'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Tampa_$_selectedLow',"Tampa",_selectedLow)
                  ),
                ],
              ):Container(),
              _cont==9?Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: ButtonsRegister(
                      text: "Nova cor",
                      color: PaletteColor.blueButton,
                      onTap: ()=>_showDialogRegister(),
                    ),
                  ),
                  GroupStock(
                      title: 'Chassi',
                      subtitle: 'Cor',
                      fontsTitle: 16,
                      width: width*0.5,
                      streamBuilderLow: streamLow(_controllerColors),
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
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
                      onTapCamera: ()=>_savePhoto('Chassi_$_selectedLow'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Chassi_$_selectedLow',"Chassi",_selectedLow)
                  ),
                ],
              ):Container(),
              _cont==10?Column(
                children: [
                  GroupStock(
                      title: 'Conector de Carga',
                      fontsTitle: 16,
                      width: width*0.5,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
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
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Conector de Carga','Conector de Carga',"")
                  ),
                ],
              ):Container(),
              _cont==11?Column(
                children: [
                  GroupStock(
                      title: 'Dock de Carga',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Dock de Carga'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Dock de Carga','Dock de Carga',"")
                  ),
                ],
              ):Container(),
              _cont==12?Column(
                children: [
                  GroupStock(
                      title: 'Bateria',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: true,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
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
                      titlePrice: 'Pre??o Venda',
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
              _cont==13?Column(
                children: [
                  GroupStock(
                      title: 'Flex Power',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Flex Power'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Flex Power','Flex Power',"")
                  ),
                ],
              ):Container(),
              _cont==14?Column(
                children: [
                  GroupStock(
                      title: 'Digital',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Digital'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Digital','Digital',"")
                  ),
                ],
              ):Container(),
              _cont==15?Column(
                children: [
                  GroupStock(
                      title: 'Lente da C??mera',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Lente da C??mera'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Lente da c??mera','Lente da c??mera',"")
                  ),
                ],
              ):Container(),
              _cont==16?Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: ButtonsRegister(
                      text: "Nova cor",
                      color: PaletteColor.blueButton,
                      onTap: ()=>_showDialogRegister(),
                    ),
                  ),
                  GroupStock(
                      title: 'Gaveta do chip',
                      subtitle: 'Cor',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
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
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=> _registerDatabase('Gaveta do chip-$_selectedLow','Gaveta do chip',_selectedLow)
                  ),
                ],
              ):Container(),
              _cont==17?Column(
                children: [
                  GroupStock(
                      title: 'C??mera Frontal',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('C??mera Frontal'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('C??mera Frontal','C??mera Frontal',"")
                  ),
                ],
              ):Container(),
              _cont==18?Column(
                children: [
                  GroupStock(
                      title: 'C??mera Traseira',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('C??mera Traseira'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('C??mera Traseira','C??mera Traseira',"")
                  ),
                ],
              ):Container(),
              _cont==19?Column(
                children: [
                  GroupStock(
                      title: 'Falante Auricular',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Falante Auricular'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Falante Auricular','Falante Auricular',"")
                  ),
                ],
              ):Container(),
              _cont==20?Column(
                children: [
                  GroupStock(
                      title: 'Campainha',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Campainha'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Campainha','Campainha',"")
                  ),
                ],
              ):Container(),
              _cont==21?Column(
                children: [
                  GroupStock(
                      title: 'Flex Sub Placa',
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      sendPhoto: _sendPhoto,
                      sendData: _sendData,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPricePuschace: _controllerPricePuschace,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      controllerStockMin: _controllerStockMin,
                      onTapCamera: ()=>_savePhoto('Flex Sub Placa'),
                      showStockmin: true,
                      showPrice: true,
                      titlePrice: 'Pre??o Venda',
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