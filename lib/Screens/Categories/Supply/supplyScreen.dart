import 'package:celular/Model/RefModel.dart';
import 'package:celular/Model/SupplyModel.dart';

import '../../../Utils/export.dart';

class SupplyScreen extends StatefulWidget {
  const SupplyScreen({Key key}) : super(key: key);

  @override
  _SupplyScreenState createState() => _SupplyScreenState();
}

class _SupplyScreenState extends State<SupplyScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _controllerSearch = TextEditingController();
  TextEditingController _controllerRegister = TextEditingController();
  var _controllerColors = StreamController<QuerySnapshot>.broadcast();
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;


  _data() async {
    var data = await db.collection("supply").get();

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
        var brands = SupplyModel.fromSnapshot(items).supply.toLowerCase();

        if (brands.contains(_controllerSearch.text.toLowerCase())) {
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

  _deleteRef(String supply) {

    db.collection("supply")
        .doc(supply)
        .delete()
        .then((_){
      Navigator.pushReplacementNamed(context, "/supply");
    });
  }

  _showDialogDelete(String ref) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmar"),
            content: Text("Deseja realmente excluir esse fornecedor?"),
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
                onPressed: () => _deleteRef(ref),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _data();
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
        backgroundColor: PaletteColor.white,
        appBar: AppBar(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: PaletteColor.white,
            fontWeight: FontWeight.w700,
          ),
          backgroundColor: PaletteColor.appBar,
          title: Text('FORNECEDORES'),
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
                  InputSearch(controller: _controllerSearch),
                  ButtonsAdd(onPressed: ()=>Navigator.pushReplacementNamed(context, '/add_supply'))
                ],
              ),
              Container(
                height: height * 0.5,
                child: StreamBuilder(
                  stream: _controllerColors.stream,
                  builder: (context, snapshot) {

                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if(_resultsList.length == 0){
                          return Center(
                              child: Text('Sem dados!',style: TextStyle(fontSize: 20),)
                          );
                        }else {
                          return ListView.separated(
                              separatorBuilder: (context, index) => DividerList(),
                              itemCount: _resultsList.length,
                              itemBuilder: (BuildContext context, index) {
                                DocumentSnapshot item = _resultsList[index];

                                return ItemsList(
                                  showDelete: true,
                                  data: item["supply"],
                                  onPressedDelete: () => _showDialogDelete(item["supply"]),
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
