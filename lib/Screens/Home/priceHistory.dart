import '../../Model/export.dart';

class PriceHistory extends StatefulWidget {
  const PriceHistory({Key key}) : super(key: key);

  @override
  _PriceHistoryState createState() => _PriceHistoryState();
}

class _PriceHistoryState extends State<PriceHistory> {

  TextEditingController _controllerSearch = TextEditingController();
  var _controllerItem = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String _input;
  String _output;
  String _alls;
  String _value;
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;

  _data() async {
    var data = await db.collection("historicoPrecos").orderBy('data').get();

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
        var parts = UpdatesModel.fromSnapshot(items).item.toLowerCase();

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

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 15,
          color: PaletteColor.white,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: PaletteColor.appBar,
        title: Text('HIST??RICO DE PRE??OS'),
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
            DividerList(),
            Container(
              height: height/1.5,
              child: StreamBuilder(
                stream: _controllerItem.stream,
                builder: (context, snapshot) {
                  return ListView.separated(
                      separatorBuilder: (context, index) => DividerList(),
                      itemCount: _resultsList.length,
                      itemBuilder: (BuildContext context, index) {
                        DocumentSnapshot item = _resultsList[index];

                        String id         = item["id"];
                        String date       = item["data"];
                        String quantity   = item["quantidade"]??"";
                        String priceSale  = item["preco"]??"";
                        String brand      = item["marca"]??"";
                        String part       = item["peca"]??"";
                        String type       = item["tipo"]??"";

                        var outputFormat = DateFormat('dd/MM/yyyy');
                        var newdate = outputFormat.format(DateTime.parse(date));

                        return ExampleDataHistory(
                          date: newdate,
                          quantity: quantity,
                          price: priceSale,
                          part: part,
                          brand: brand,
                          type: type,
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
