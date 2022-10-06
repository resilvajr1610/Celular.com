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
    print('teste : ${data['store']}');
    setState(() {
      storeUser = data['store']??'';
    });
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

    int total = int.parse(_controllerStock.text)+int.parse(_stock);

    db
        .collection("pecas")
        .doc(_id)
        .update({
          "precoCompra$storeUser":_controllerPriceSale.text,
          "estoque$storeUser":total.toString(),
          'store$storeUser': storeUser
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
                          onTap: ()=>_updateValue(),
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
