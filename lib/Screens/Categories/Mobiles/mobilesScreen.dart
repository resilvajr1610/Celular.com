import '../../../Utils/export.dart';

class MobilesScreen extends StatefulWidget {
  const MobilesScreen({Key key}) : super(key: key);

  @override
  _MobilesScreenState createState() => _MobilesScreenState();
}

class _MobilesScreenState extends State<MobilesScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controllerMobiles = StreamController<QuerySnapshot>.broadcast();
  TextEditingController _controllerSerch = TextEditingController(text: "");
  String _selectedBrands;
  String _selectedColor="";
  String _selected1="";
  final _controllerBrandsBroadcast = StreamController<QuerySnapshot>.broadcast();
  final _controllerColorsBroadcast = StreamController<QuerySnapshot>.broadcast();
  TextEditingController _controllerModel = TextEditingController(text: "");
  TextEditingController _controllerRef = TextEditingController(text: "");
  TextEditingController _controllerPriceSale = TextEditingController(text: "");
  TextEditingController _controllerPricePurchase = TextEditingController(text: "");
  TextEditingController _controllerStockMin = TextEditingController(text: "");
  TextEditingController _controllerStock = TextEditingController(text: "");
  String _urlPhoto;
  String _description = "";
  List _resultsList = [];
  List _allResults = [];

  _data() async {
    var data = await db.collection("pecas").get();

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

  _deleteMobiles(String idParts) {

    db.collection('pecas')
        .doc(idParts)
        .delete()
        .then((_) {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, "/mobiles");
    });
  }

  _showDialogDelete(String idParts, String part) {

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmar"),
            content: Text("Deseja realmente excluir $part?"),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  "Remover",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _deleteMobiles(idParts),
              )
            ],
          );
        });
  }

  _showDialogEdit(
      String idParts,
      String brands,
      String description,
      String color,
      String selected1,
      final controllerModel,
      final controllerPricePurchase,
      final controllerPriceSale,
      final controllerRef,
      final controllerStock,
      final controllerStockMin,
      String urlPhoto,
      ) {

    showDialog(
        context: context,
        builder: (_) {
          return DialogEdit(
            idParts: idParts,
            brands: brands,
            description: description,
            color: color,
            selected1: selected1,
            controllerModel: controllerModel,
            controllerPricePurchase: controllerPricePurchase,
            controllerPriceSale: controllerPriceSale,
            controllerRef: controllerRef,
            controllerStock: controllerStock,
            controllerStockMin: controllerStockMin,
            urlPhoto : urlPhoto
          );
        });
  }

  Future<Stream<QuerySnapshot>> _addListenerBrands()async{

    Stream<QuerySnapshot> stream = db
        .collection("marcas")
        .snapshots();

    stream.listen((data) {
      _controllerBrandsBroadcast.add(data);
    });
  }

  Widget streamBrands() {

    _addListenerBrands();

    return StreamBuilder<QuerySnapshot>(
      stream:_controllerBrandsBroadcast.stream,
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
                      "",
                      style: TextStyle(color: PaletteColor.darkGrey,fontSize: 10),
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InputSearch(controller: _controllerSerch),
                  ButtonsAdd(onPressed: ()=> Navigator.pushReplacementNamed(context, "/partsRegister"))
                ],
              ),
              Container(
                height: height * 0.7,
                child: StreamBuilder(
                  stream: _controllerMobiles.stream,
                  builder: (context, snapshot) {
                    if(snapshot.hasError)
                      return Text("Erro ao carregar dados!");

                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                        case ConnectionState.done:
                        if(_resultsList.length == 0){
                            return Center(
                                child: Text('Sem dados!',style: TextStyle(fontSize: 20),)
                            );
                            }else{
                              return ListView.separated(
                              separatorBuilder: (context, index) => DividerList(),
                              itemCount: _resultsList.length,
                              itemBuilder: (BuildContext context, index) {
                              DocumentSnapshot item = _resultsList[index];
                          
                              String idParts      = item["id"];
                              String part = ErrorList(item,"marca")!=""?ErrorList(item,"marca")+" / "+ErrorList(item,"modelo")+" / "+ErrorList(item,"descricao")+" / "+ErrorList(item,"cor")+" / "+ErrorList(item,"modelo")+" / "+ErrorList(item,"descricao"):"";

                              return ItemsList(
                                showDelete: true,
                                data: part,
                                onPressedEdit: (){
                                  _selectedBrands = ErrorList(item,"marca");
                                  _selectedColor = ErrorList(item,"cor")==''?'Branco':ErrorList(item,"cor");
                                  _selected1 = ErrorList(item,"selecionado1")==''?'N/A':ErrorList(item,"selecionado1");
                                  _controllerModel = TextEditingController(text: ErrorList(item,"modelo"));
                                  _description = ErrorList(item,"descricao");
                                  _controllerRef = TextEditingController(text: ErrorList(item,"referencia"));
                                  _controllerPriceSale = TextEditingController(text: ErrorList(item,"precoVenda"));
                                  _controllerPricePurchase = TextEditingController(text: ErrorList(item,"precoCompra"));
                                  _controllerStockMin = TextEditingController(text: ErrorList(item,"estoqueMinimo"));
                                  _controllerStock = TextEditingController(text: ErrorList(item,"estoque"));
                                  _urlPhoto = ErrorList(item, "foto");

                                  _showDialogEdit(
                                      idParts,
                                      _selectedBrands,
                                      _description,
                                      _selectedColor,
                                      _selected1,
                                      _controllerModel,
                                      _controllerPricePurchase,
                                      _controllerPriceSale,
                                      _controllerRef,
                                      _controllerStock,
                                      _controllerStockMin,
                                      _urlPhoto
                                  );
                                },
                                onPressedDelete: () =>_showDialogDelete(idParts,part),
                              );
                              });
                            }
                        }
                      },
                ),
              ),
            ],
          ),
        ));
  }
}

class DialogEdit extends StatefulWidget {
  String brands;
  String color;
  String selected1;
  String idParts;
  String description;
  Widget streamBrands;
  TextEditingController controllerModel;
  TextEditingController controllerRef;
  TextEditingController controllerPriceSale;
  TextEditingController controllerPricePurchase;
  TextEditingController controllerStockMin;
  TextEditingController controllerStock;
  String urlPhoto;

  DialogEdit({
    this.brands,
    this.description,
    this.idParts,
    this.controllerModel,
    this.color,
    this.selected1,
    this.controllerStockMin,
    this.controllerPricePurchase,
    this.controllerPriceSale,
    this.controllerRef,
    this.controllerStock,
    this.streamBrands,
    this.urlPhoto
  });

  @override
  State<DialogEdit> createState() => _DialogEditState();
}

class _DialogEditState extends State<DialogEdit> {

  final _controllerBrandsBroadcast = StreamController<QuerySnapshot>.broadcast();
  final _controllerColorsBroadcast = StreamController<QuerySnapshot>.broadcast();
  final _controllerDisplayBroadcast = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  File photo;
  bool _updatePhoto=true;

  Future _savePhoto(String namePhoto, String idParts)async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 50);
      if(image ==null)return;

      final imageTemporary = File(image.path);
      this.photo = imageTemporary;

      _updatePhoto=false;

      _uploadImage(namePhoto,idParts);
    } on PlatformException catch (e){
      print('Error : $e');
    }
  }

  Future _uploadImage(String namePhoto,String idParts)async{
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
        .child("pecas")
        .child(widget.brands+"_"+namePhoto + ".jpg");

    UploadTask task = arquivo.putFile(photo);

    Future.delayed(const Duration(seconds: 6),()async{
      String urlImage = await task.snapshot.ref.getDownloadURL();
      if(urlImage!=null){
        _urlImageFirestore(urlImage,namePhoto,idParts);
        setState(() {
          widget.urlPhoto = urlImage;
        });
      }
    });
  }

  _urlImageFirestore(String url, String namePhoto,String idParts){

    Map<String,dynamic> dateUpdate = {
      "foto" : url,
    };

    db.collection("pecas")
        .doc(idParts)
        .update(dateUpdate).then((value){
      _updatePhoto=true;
      Navigator.pushReplacementNamed(context, "/mobiles");
    });
  }

  Future<Stream<QuerySnapshot>> _addListenerBrands()async{

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("marcas")
        .snapshots();

    stream.listen((data) {
      _controllerBrandsBroadcast.add(data);
    });
  }

  Future<Stream<QuerySnapshot>> _addListenerColors()async{

    Stream<QuerySnapshot> stream = db
        .collection("cores")
        .snapshots();

    stream.listen((data) {
      _controllerColorsBroadcast.add(data);
    });
  }

  Future<Stream<QuerySnapshot>> _addListenerDisplay()async{

    Stream<QuerySnapshot> stream = db
        .collection("display")
        .snapshots();

    stream.listen((data) {
      _controllerDisplayBroadcast.add(data);
    });
  }

  Widget streamBrands() {

    _addListenerBrands();

    return StreamBuilder<QuerySnapshot>(
      stream:_controllerBrandsBroadcast.stream,
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
                        widget.brands = value;
                      });
                    },
                    value: widget.brands,
                    isExpanded: false,
                    hint: new Text(
                      "",
                      style: TextStyle(color: PaletteColor.darkGrey,fontSize: 10),
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }

  Widget streamDisplay() {

    _addListenerDisplay();

    return StreamBuilder<QuerySnapshot>(
      stream:_controllerDisplayBroadcast.stream,
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
                        style: TextStyle(color: PaletteColor.darkGrey,fontSize: 15),
                      ),
                      value: "${snap.id}",
                    )
                );
              }
              espItems.add(
                  DropdownMenuItem(
                    child: Text(
                      'N/A',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PaletteColor.darkGrey,fontSize: 15),
                    ),
                    value: "N/A",
                  )
              );
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    items: espItems,
                    onChanged: (value) {
                      setState(() {
                        widget.selected1 = value;
                      });
                    },
                    value: widget.selected1,
                    isExpanded: false,
                    hint: new Text(
                      "",
                      style: TextStyle(color: PaletteColor.darkGrey,fontSize: 10),
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }

  Widget streamColors() {

    _addListenerColors();

    return StreamBuilder<QuerySnapshot>(
        stream:_controllerColorsBroadcast.stream,
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
                          snap.id!=0? snap.id : "",
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
                          widget.color = value;
                        });
                      },
                      value: widget.color!=""?widget.color:widget.color="cor",
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

  _edit(String idParts){

    db.collection('pecas')
        .doc(idParts)
        .update({
      'marca'         :widget.brands,
      'selecionado1'  :widget.selected1,
      'modelo'        :widget.controllerModel.text,
      'descricao'     :widget.description,
      'referencia'    :widget.controllerRef.text,
      'cor'           :widget.color,
      'precoVenda'    :widget.controllerPriceSale.text,
      'precoCompra'   :widget.controllerPricePurchase.text,
      'estoqueMinimo' :widget.controllerStockMin.text,
      'estoque'       :widget.controllerStock.text,
      'item'          :widget.brands+"_"+widget.controllerModel.text+"_"+widget.description+"_"+widget.color+"_"+widget.controllerRef.text,
    })
        .then((_) {
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, "/mobiles");
    });
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      actionsAlignment: MainAxisAlignment.spaceAround,
      contentPadding: EdgeInsets.all(3),
      title: Text("Alterar dados das peças"),
      content: SingleChildScrollView(
        child: Container(
          height: 800,
          child: _updatePhoto==false? Row(
            children: [
              CircularProgressIndicator(),
              Text('Enviando Foto ...')
            ],
          ):Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: height * 0.15,
                child: Row(
                  children: [
                    Text("Marca"),
                    DropdownItens(
                        width: width * 0.35,
                        streamBuilder: streamBrands(),
                        onChanged: (valor) {
                          setState(() {
                            widget.brands = valor;
                          });
                        }),
                  ],
                ),
              ),
              Row(
                children: [
                  Text("Modelo"),
                  Expanded(
                      child: InputRegister(
                        keyboardType: TextInputType.text,
                        controller: widget.controllerModel,
                        hint: "Modelo",
                        fonts: 20,
                        obscure: false,)
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Descrição"),
                  Expanded(
                      child: TextTitle(text: widget.description, fonts: 15)
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Referência"),
                  Expanded(
                      child: InputRegister(
                        keyboardType: TextInputType.text,
                        controller: widget.controllerRef,
                        hint: "Referência",
                        fonts: 20,
                        obscure: false,)
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Cor"),
                  DropdownItens(
                      width: width * 0.42,
                      streamBuilder: streamColors(),
                      onChanged: (valor) {
                        setState(() {
                          widget.color = valor;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  Text("Display"),
                  DropdownItens(
                      width: width * 0.33,
                      streamBuilder: streamDisplay(),
                      onChanged: (valor) {
                        setState(() {
                          widget.selected1 = valor;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  Text("Preço Venda"),
                  Expanded(
                      child: InputRegister(
                        keyboardType: TextInputType.text,
                        controller: widget.controllerPriceSale,
                        hint: "Preço Venda",
                        fonts: 20,
                        obscure: false,)
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Preço Compra"),
                  Expanded(
                      child: InputRegister(
                        keyboardType: TextInputType.text,
                        controller: widget.controllerPricePurchase,
                        hint: "Preço Compra",
                        fonts: 20,
                        obscure: false,)
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Estoque Mínimo"),
                  Expanded(
                      child: InputRegister(
                        keyboardType: TextInputType.text,
                        controller: widget.controllerStockMin,
                        hint: "Estoque Mínimo",
                        fonts: 20,
                        obscure: false,)
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Estoque"),
                  Expanded(
                      child: InputRegister(
                        keyboardType: TextInputType.text,
                        controller: widget.controllerStock,
                        hint: "Estoque",
                        fonts: 20,
                        obscure: false)
                  ),
                ],
              ),
              widget.urlPhoto != ""? Visibility(
                visible: _updatePhoto,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _savePhoto(widget.description, widget.idParts);
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(widget.urlPhoto,
                        errorBuilder: (BuildContext context,
                            Object exception, StackTrace stackTrace) {
                          return Container(height: 150,
                              width: 150,
                              child: Icon(Icons.do_not_disturb));
                        },
                      ),
                    ),
                  ),
                ),
              ) : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonsRegister(
                    text: 'Inserir Foto',
                    color: PaletteColor.blueButton,
                    onTap: () {
                      Navigator.of(context).pop();
                      _savePhoto(widget.description, widget.idParts);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
          ),
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: PaletteColor.blueButton,
          ),
          child: Text(
            "Alterar",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => _edit(widget.idParts),
        )
      ],
    );
  }
}

