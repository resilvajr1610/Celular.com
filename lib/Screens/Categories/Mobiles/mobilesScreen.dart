import '../../../Model/export.dart';

class MobilesScreen extends StatefulWidget {
  const MobilesScreen({Key key}) : super(key: key);

  @override
  _MobilesScreenState createState() => _MobilesScreenState();
}

class _MobilesScreenState extends State<MobilesScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controllerMobiles = StreamController<QuerySnapshot>.broadcast();
  TextEditingController _controllerSerch = TextEditingController();
  TextEditingController _controllerBrands = TextEditingController();
  TextEditingController _controllerModel = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  TextEditingController _controllerRef = TextEditingController();
  TextEditingController _controllerColor = TextEditingController();
  TextEditingController _controllerPriceSale = TextEditingController();
  TextEditingController _controllerPricePurchase = TextEditingController();
  TextEditingController _controllerStockMin = TextEditingController();
  TextEditingController _controllerStock = TextEditingController();
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
              FlatButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: Colors.red,
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

  _edit(
      String idParts){

    db.collection('pecas')
        .doc(idParts)
        .update({
          'marca'         :_controllerBrands.text,
          'modelo'        :_controllerModel.text,
          'descricao'     :_controllerDescription.text,
          'referencia'    :_controllerRef.text,
          'cor'           :_controllerColor.text,
          'precoVenda'    :_controllerPriceSale.text,
          'precoCompra'   :_controllerPricePurchase.text,
          'estoqueMinimo' :_controllerStockMin.text,
          'estoque'       :_controllerStock.text,
          'item'          :_controllerBrands.text+"_"+_controllerModel.text+"_"+_controllerDescription.text+"_"+_controllerColor.text+"_"+_controllerRef.text,
    })
        .then((_) {
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, "/mobiles");
    });
  }

  _showDialogEdit( String idParts) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Alterar dados das peças"),
            content: SingleChildScrollView(
              child: Container(
                height: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text("Marca"),
                        Expanded(
                            child:  InputRegister(keyboardType: TextInputType.text, controller: _controllerBrands, hint: "Marca",fonts: 20,obscure: false,)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Modelo"),
                        Expanded(
                            child:  InputRegister(keyboardType: TextInputType.text, controller: _controllerModel, hint: "Modelo",fonts: 20,obscure: false,)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Descrição"),
                        Expanded(
                            child:  InputRegister(keyboardType: TextInputType.text, controller: _controllerDescription, hint: "Descrição",fonts: 20,obscure: false,)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Referência"),
                        Expanded(
                            child:  InputRegister(keyboardType: TextInputType.text, controller: _controllerRef, hint: "Referência",fonts: 20,obscure: false,)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Cor"),
                        Expanded(
                            child:  InputRegister(keyboardType: TextInputType.text, controller: _controllerColor, hint: "Cor",fonts: 20,obscure: false,)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Preço Venda"),
                        Expanded(
                            child:  InputRegister(keyboardType: TextInputType.text, controller: _controllerPriceSale, hint: "Preço Venda",fonts: 20,obscure: false,)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Preço Compra"),
                        Expanded(
                            child:  InputRegister(keyboardType: TextInputType.text, controller: _controllerPricePurchase, hint: "Preço Compra",fonts: 20,obscure: false,)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Estoque Mínimo"),
                        Expanded(
                            child:  InputRegister(keyboardType: TextInputType.text, controller: _controllerStockMin, hint: "Estoque Mínimo",fonts: 20,obscure: false,)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Estoque"),
                        Expanded(
                            child:  InputRegister(keyboardType: TextInputType.text, controller: _controllerStock, hint: "Estoque",fonts: 20,obscure: false,)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: PaletteColor.blueButton,
                child: Text(
                  "Alterar",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _edit(idParts),
              )
            ],
          );
        });
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
                                  _controllerBrands = TextEditingController(text: ErrorList(item,"marca"));
                                  _controllerModel = TextEditingController(text: ErrorList(item,"modelo"));
                                  _controllerDescription = TextEditingController(text: ErrorList(item,"descricao"));
                                  _controllerRef = TextEditingController(text: ErrorList(item,"referencia"));
                                  _controllerColor = TextEditingController(text: ErrorList(item,"cor"));
                                  _controllerPriceSale = TextEditingController(text: ErrorList(item,"precoVenda"));
                                  _controllerPricePurchase = TextEditingController(text: ErrorList(item,"precoCompra"));
                                  _controllerStockMin = TextEditingController(text: ErrorList(item,"estoqueMinimo"));
                                  _controllerStock = TextEditingController(text: ErrorList(item,"estoque"));

                                  _showDialogEdit(idParts);
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
