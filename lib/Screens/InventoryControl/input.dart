import '../../Utils/export.dart';

class Input extends StatefulWidget {
  const Input({Key key}) : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  var _controllerItem = StreamController<QuerySnapshot>.broadcast();
  TextEditingController _controllerSearch = TextEditingController();
  TextEditingController _controllerStock = TextEditingController();
  TextEditingController _controllerPriceSale = TextEditingController();
  final _controllerBrands = StreamController<QuerySnapshot>.broadcast();
  String _selectedSupply;
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;
  bool _visibility=false;
  String _id;
  String _part;
  String _brand;
  String _item;
  String _stock;
  UpdatesModel _updatesModel;
  String storeUser='';

  dataUser()async{
    DocumentSnapshot snapshot = await db
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser.email)
        .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if(data['store']!=null){
      setState(() {
        storeUser = data['store']??'';
      });
    }
    _data();
  }

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

    if (_controllerSearch.text != "") {
      for (var items in _allResults) {
        var parts = PartsModel.fromSnapshot(items).item.toLowerCase();

        if (parts.contains(_controllerSearch.text.toLowerCase())) {
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

  _updateValue(){

    _updatesModel = UpdatesModel.createId();

    _updatesModel.type = 'entrada';
    _updatesModel.quantity = _controllerStock.text;
    _updatesModel.part = _part;
    _updatesModel.brand = _brand;
    _updatesModel.date = DateTime.now().toString();
    _updatesModel.price = _controllerPriceSale.text;
    _updatesModel.item = _item;
    _updatesModel.store = storeUser;
    _updatesModel.supply = _selectedSupply;

    int total = int.parse(_controllerStock.text)+int.parse(_stock);

    db
        .collection("pecas")
        .doc(_id)
        .update({
          "precoCompra$storeUser":_controllerPriceSale.text,
          "estoque$storeUser":total.toString(),
          'store$storeUser': storeUser,
          'supply$storeUser':_selectedSupply
        }).then((_) {

      db.collection("historicoPrecos")
          .doc(_updatesModel.id)
          .set(_updatesModel.toMap())
          .then((_){
            setState(() {
              _controllerStock.clear();
              _controllerPriceSale.clear();
              _id = "";
              _part = "";
              _brand = "";
              _item = "";
              _stock = "";
              _visibility = false;
              _data();
            });
        });

    });
  }

  Future<Stream<QuerySnapshot>> _addListenerSupply()async{

    Stream<QuerySnapshot> stream = db
        .collection("supply")
        .snapshots();

    stream.listen((data) {
      _controllerBrands.add(data);
    });
  }


  Widget streamSupply() {

    _addListenerSupply();

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
                        _selectedSupply = value;
                      });
                    },
                    value: _selectedSupply,
                    isExpanded: false,
                    hint: new Text(
                      "Escolha o fornecedor",
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

  @override
  void initState() {
    super.initState();
    dataUser();
    _controllerSearch.addListener(_search);
  }

  @override
  void dispose() {
    super.dispose();
    _controllerSearch.removeListener(_search);
    _controllerSearch.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = _search();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: PaletteColor.white,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: PaletteColor.appBar,
        title: Text('ENTRADA'),
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
            InputSearch(controller: _controllerSearch),
            Container(
              height: height * 0.4,
              child: StreamBuilder(
                stream: _controllerItem.stream,
                builder: (context, snapshot) {
                  return ListView.separated(
                      separatorBuilder: (context, index) => DividerList(),
                      itemCount: _resultsList.length,
                      itemBuilder: (BuildContext context, index) {
                        DocumentSnapshot item = _resultsList[index];

                        _id   = item["id"];
                        _item = ErrorList(item,"item");
                        String priceSale = ErrorList(item,"precoCompra$storeUser");
                        _brand    = ErrorList(item,"marca");
                        _part    = ErrorList(item,"peca");

                        return ItemsList(
                          onTapItem: (){
                            setState(() {
                              _visibility=true;
                              _stock="";
                              _stock = ErrorList(item,"estoque$storeUser")==''?'0':ErrorList(item,"estoque$storeUser");
                              print('stock $_stock');
                            });
                          },
                          data: _item,
                          showDelete: false,
                        );
                      });
                },
              ),
            ),
            Visibility(
              visible: _visibility,
              child: Column(
                children: [
                  DropdownItens(
                      streamBuilder: streamSupply(),
                      onChanged: (valor){
                        setState(() {
                          _selectedSupply = valor;
                        });
                      }),
                  GroupStock(
                      title: "",
                      fontsTitle: 16,
                      width: width*0.5,
                      showCod: false,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      showStockmin: false,
                      showPrice: false,
                      titlePrice: 'Preço compra',
                      showCamera: false
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      alignment: Alignment.centerLeft,
                      child: Text('Estoque atual : $_stock',
                        style: TextStyle(color: PaletteColor.darkGrey),
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonsRegister(
                          onTap: (){
                            setState(() {
                              _visibility=false;
                            });
                          },
                          text: 'Cancelar',
                          color: PaletteColor.darkGrey
                      ),
                      ButtonsRegister(
                          onTap: (){
                            if(_selectedSupply!=null && _controllerStock.text.isNotEmpty && _controllerPriceSale.text.isNotEmpty){
                              _updateValue();
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
                          },
                          text: 'Atualizar',
                          color: PaletteColor.blueButton
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
