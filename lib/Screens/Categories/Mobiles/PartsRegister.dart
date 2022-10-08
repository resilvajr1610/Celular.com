import '../../../Utils/export.dart';

class PartsResgister extends StatefulWidget {
  const PartsResgister({Key key}) : super(key: key);

  @override
  _PartsResgisterState createState() => _PartsResgisterState();
}

class _PartsResgisterState extends State<PartsResgister> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  final _controllerBrands = StreamController<QuerySnapshot>.broadcast();
  final _controllerModelBroadcast = StreamController<QuerySnapshot>.broadcast();
  final _controllerColors = StreamController<QuerySnapshot>.broadcast();
  final _controllerDisplay = StreamController<QuerySnapshot>.broadcast();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PartsModel _partsModel;
  ColorsModel _colorsModel;
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
  String storeUser='';
  String _selectedBrands;
  String _selectedRef='';
  String _selectedModel;
  String _selectedUp;
  String _selectedLow;
  bool saving = false;
  int _cont=1;

  Future<Stream<QuerySnapshot>> _addListenerBrands()async{

    Stream<QuerySnapshot> stream = db
        .collection("marcas")
        .snapshots();

    stream.listen((data) {
      _controllerBrands.add(data);
    });
  }

  Future<Stream<QuerySnapshot>> _addListenerModel()async{

    Stream<QuerySnapshot> stream = db
        .collection("ref").where('marca',isEqualTo: _selectedBrands)
        .snapshots();

    stream.listen((data) {
      _controllerModelBroadcast.add(data);
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
                      _selectedModel=null;
                      _selectedRef='';
                      _addListenerModel();
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

  Widget streamModel() {

    return StreamBuilder<QuerySnapshot>(
      stream:_controllerModelBroadcast.stream,
      builder: (context,snapshot){

        if(snapshot.hasError)
          return Text("Erro ao carregar dados!");

        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container();
          case ConnectionState.active:
          case ConnectionState.done:
          DocumentSnapshot snap;
          if(!snapshot.hasData){
              return CircularProgressIndicator();
            }else {
              List<DropdownMenuItem> espItems = [];
              for (int i = 0; i < snapshot.data.docs.length; i++) {
                snap = snapshot.data.docs[i];
                espItems.add(
                    DropdownMenuItem(
                      child: Text(
                        '${snap['modelo']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: PaletteColor.darkGrey),
                      ),
                      value: "${snap['modelo']}",
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
                        _selectedModel = value;
                        _selectedRef = snap['ref'];
                      });
                    },
                    value: _selectedModel,
                    isExpanded: false,
                    hint: new Text(
                      "Escolha um modelo",
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

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
    if(storeUser==''){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Center(child: Text('Erro ao Salvar')),
              titleTextStyle: TextStyle(color: PaletteColor.darkGrey,fontSize: 20),
              content: Row(
                children: [
                  Expanded(
                      child:  Text('Escolha uma loja na tela inicial para salvar os dados')
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              actions: [
                ElevatedButton(
                    onPressed: ()=>Navigator.pushReplacementNamed(context,'/home'),
                    child: Text('OK')
                )
              ],
            );
          });
    }else{
      if(_selectedBrands!=null && _selectedModel.isNotEmpty && _selectedRef.isNotEmpty){
        setState((){
          saving = true;
        });

        _partsModel = PartsModel.createId();

        Map<String,dynamic> dateUpdate = part!="PCB"?{
          "selecionado1" : _selectedUp,
          "selecionado2" : _selectedLow,
          "estoque$storeUser" : _controllerStock.text,
          "estoqueMinimo$storeUser" : _controllerStockMin.text,
          "precoCompra$storeUser" : _controllerPricePuschace.text,
          "precoVenda$storeUser" : _controllerPriceSale.text,
          "referencia" : _selectedRef,
          "peca" : part,
          "marca": _selectedBrands,
          "item":_selectedBrands+"_"+_selectedModel+"_"+part+"_"+_selectedRef,
          "modelo":_selectedModel,
          "descricao":description,
          "cor":color,
          "id":_partsModel.id,
          'store$storeUser': storeUser
        }:{
          "marca": _selectedBrands,
          "peca" : part,
          "descricao":description,
          "modelo":_selectedModel,
          "item":_selectedBrands+"_"+_selectedModel+"_"+part+"_"+_selectedRef,
          "selecionado1" : "N/A",
          "selecionado2" : "N/A",
          "estoque$storeUser" : "0",
          "estoqueMinimo$storeUser" : "0",
          "precoCompra$storeUser" : "0",
          "precoVenda$storeUser" : "0",
          "referencia" : part,
          "cor":"Branco",
          "foto":"",
          "id":_partsModel.id,
          'store$storeUser': storeUser
        };

        if(part=="PCB"){
          db.collection("pecas")
              .doc(_partsModel.id)
              .set(dateUpdate).then((value) =>setState((){
            saving=false;
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
                          onPressed: ()=>Navigator.pop(context),
                          child: Text('OK')
                      )
                    ],
                  );
                });
          }));

        }else{

          _updatesModel = UpdatesModel.createId();
          _updatesModel.type = 'entrada';
          _updatesModel.quantity = _controllerStock.text;
          _updatesModel.part = part;
          _updatesModel.brand = _selectedBrands;
          _updatesModel.date = DateTime.now().toString();
          _updatesModel.price = _controllerPriceSale.text;
          _updatesModel.item = _selectedBrands+"_"+_selectedModel+"_"+part+"_"+_selectedRef;
          _updatesModel.store = storeUser;

          db.collection("pecas")
              .doc(_partsModel.id)
              .set(dateUpdate).then((_){
            db.collection('celulares')
                .doc(_selectedModel)
                .set({
              "celular":_selectedModel,
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
                saving=false;
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
                              onPressed: ()=>Navigator.pop(context),
                              child: Text('OK')
                          )
                        ],
                      );
                    });
              });
            });
          });
        }
      }else{
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Center(child: Text('Erro ao Salvar')),
                titleTextStyle: TextStyle(color: PaletteColor.darkGrey,fontSize: 20),
                content: Row(
                  children: [
                    Expanded(
                        child:  Text('Preecha todos os campos corretamente')
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
  }

  _registerBattery(String part){

    Map<String,dynamic> dateUpdate = {
      "codBateria" : _controllerCodBattery.text,
    };

    db.collection("celulares")
        .doc(_selectedBrands)
        .collection(_selectedModel)
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
    dataUser();
    _addListenerBrands();
    _addListenerColors();
    _addListenerDisplay();
    _partsModel = PartsModel();
  }

  dataUser()async{
    DocumentSnapshot snapshot = await db
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser.email)
        .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    print('teste : ${data['store']}');
    if(data['store']!=null){
      setState(() {
        storeUser = data['store']??'';
      });
    }
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
        title: Text('PEÇAS'),
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
                child: Text('Cadastrar Peças',
                  style: TextStyle(fontSize: 20,color: PaletteColor.darkGrey),),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text('Loja: $storeUser',
                  style: TextStyle(fontSize: 15,color: PaletteColor.darkGrey),),
              ),
              DropdownItens(
                  streamBuilder: streamBrands(),
                  onChanged: (valor){
                    setState(() {
                      _selectedBrands = valor;
                    });
                  }),
              DropdownItens(
                  streamBuilder: streamModel(),
                  onChanged: (valor){
                    setState(() {
                      _selectedModel = valor;
                    });
                  }
              ),
              TextTitle(text: 'Ref : $_selectedRef' , fonts: fonts),
              saving?Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    TextTitle(text: 'Salvando informações ...')
                  ],
                ),
              ):Container(),
              _cont==1 && saving==false ? Column(
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
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_switchPCB?_registerDatabase('PCB','PCB',""):null
                  ),
                ],
              ):Container(),
              _cont==2 && saving==false ?Column(
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
                      titlePrice: 'Preço Venda',
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
              _cont==3 && saving==false ?Column(
                children: [
                  GroupStock(
                      title: 'Película 3D',
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
              _cont==4 && saving==false ?Column(
                children: [
                  GroupStock(
                      title: 'Película 3D Privativa',
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
              _cont==5 && saving==false ?Column(
                children: [
                  GroupStock(
                      title: 'Película de Vidro',
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
              _cont==6 && saving==false ?Column(
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
              _cont==7 && saving==false ?Column(
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
              _cont==8 && saving==false ?Column(
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
                      titlePrice: 'Preço Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Tampa_$_selectedLow',"Tampa",_selectedLow)
                  ),
                ],
              ):Container(),
              _cont==9 && saving==false ?Column(
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
                      titlePrice: 'Preço Venda',
                      showCamera: true
                  ),
                  ControlRegisterParts(
                      onPressedBack: _back,
                      onPressedForward: _forward,
                      onTapRegister: ()=>_registerDatabase('Chassi_$_selectedLow',"Chassi",_selectedLow)
                  ),
                ],
              ):Container(),
              _cont==10 && saving==false ?Column(
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
              _cont==11 && saving==false ?Column(
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
              _cont==12 && saving==false ?Column(
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
              _cont==13 && saving==false ?Column(
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
              _cont==14 && saving==false ?Column(
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
              _cont==15 && saving==false ?Column(
                children: [
                  GroupStock(
                      title: 'Lente da Câmera',
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
              _cont==16 && saving==false ?Column(
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
              _cont==17 && saving==false ?Column(
                children: [
                  GroupStock(
                      title: 'Câmera Frontal',
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
              _cont==18 && saving==false ?Column(
                children: [
                  GroupStock(
                      title: 'Câmera Traseira',
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
              _cont==19 && saving==false ?Column(
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
              _cont==20 && saving==false ?Column(
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
              _cont==21 && saving==false ?Column(
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