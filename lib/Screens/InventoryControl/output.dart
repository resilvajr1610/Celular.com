import '../../Utils/export.dart';

class Output extends StatefulWidget {
  const Output({Key key}) : super(key: key);

  @override
  _OutputState createState() => _OutputState();
}

class _OutputState extends State<Output> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _controllerSearch = TextEditingController();
  TextEditingController _controllerStock = TextEditingController();
  TextEditingController _controllerPriceSale = TextEditingController();
  var _controllerItem = StreamController<QuerySnapshot>.broadcast();
  final _controllerBroadcast = StreamController<QuerySnapshot>.broadcast();
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
  String storeUser = '';
  String _selectedStore;

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

    _updatesModel.type = 'saida';
    _updatesModel.quantity = _controllerStock.text;
    _updatesModel.part = _part;
    _updatesModel.brand = _brand;
    _updatesModel.date = DateTime.now().toString();
    _updatesModel.price = _controllerPriceSale.text;
    _updatesModel.item = _item;
    _updatesModel.store = storeUser;

    int total = int.parse(_stock)-int.parse(_controllerStock.text);

    db
        .collection("pecas")
        .doc(_id)
        .update({
      "precoVenda$storeUser":_controllerPriceSale.text,
      "estoque$storeUser":total.toString()
    }).then((_) {

      db.collection("historicoPrecos")
          .doc(_updatesModel.id)
          .set(_updatesModel.toMap())
          .then((_){
        setState(() {
          _visibility = false;
          _controllerStock.clear();
          _controllerPriceSale.clear();
          _id = "";
          _part = "";
          _brand = "";
          _item = "";
          _stock = "";
          _data();
        });
      });

    });
  }


  Future<Stream<QuerySnapshot>> _addListenerStories()async{

    Stream<QuerySnapshot> stream = db
        .collection("store")
        .snapshots();

    stream.listen((data) {
      _controllerBroadcast.add(data);
    });
  }

  Widget streamStories() {

    _addListenerStories();

    return StreamBuilder<QuerySnapshot>(
      stream:_controllerBroadcast.stream,
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
                        _selectedStore = value;
                        db.collection('user').doc(auth.currentUser.email).set({
                          'user' : auth.currentUser.email,
                          'store' : _selectedStore
                        }).then((value){
                          dataUser();
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
                                          child:  Text('Lojas atualizada com sucesso')
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
                    },
                    value: _selectedStore,
                    isExpanded: false,
                    hint: new Text(
                      "Escolha uma loja",
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
        title: Text('SAÍDA'),
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
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DropdownItens(
                  streamBuilder: streamStories(),
                  onChanged: (valor){
                    setState(() {
                      _selectedStore = valor;
                    });
                  }),
            ),
            InputSearch(controller: _controllerSearch,widthCustom: 0.9),
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

                        _item   = ErrorList(item,"item");
                        String stock    = ErrorList(item,"estoque$storeUser")??"";
                        String priceSale= ErrorList(item,"precoVenda$storeUser")??"";
                        _brand    = ErrorList(item,"marca")??"";
                        _part    = ErrorList(item,"peca")??"";

                        return ItemsList(
                          onTapItem: (){
                            setState(() {
                              _id        = item["id"];
                              _stock="";
                              _stock    = ErrorList(item,"estoque$storeUser")??"";
                              _visibility=true;
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
                  GroupStock(
                      title: "",
                      fontsTitle: 16,
                      width: width * 0.5,
                      showCod: false,
                      showDropDownUp: false,
                      showDropDownLow: false,
                      controllerPriceSale: _controllerPriceSale,
                      controllerStock: _controllerStock,
                      onTapCamera: () => {},
                      showStockmin: false,
                      showPrice: false,
                      titlePrice: 'Preço venda',
                      showCamera: false,
                      showStockAndPrice: true,
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
                          color: PaletteColor.darkGrey),
                      ButtonsRegister(
                          onTap: (){
                            if(storeUser!=''){
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
                          text: 'Dar Baixa',
                          color: PaletteColor.blueButton),
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
