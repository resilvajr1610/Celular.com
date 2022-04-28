import '../../Model/export.dart';
import 'package:pdf/widgets.dart' as pdfLib;

class StockAlert extends StatefulWidget {
  const StockAlert({Key key}) : super(key: key);

  @override
  _StockAlertState createState() => _StockAlertState();
}

class _StockAlertState extends State<StockAlert> {

  TextEditingController _controllerSearch = TextEditingController();
  var _controllerItem = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;

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

  _createPdf(BuildContext context)async{

    double width = 80;

    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    pdf.addPage(pdfLib.MultiPage(
      build: (context)=>[

        pdfLib.Container(
          padding: pdfLib.EdgeInsets.symmetric(vertical: 4),
          child: pdfLib.Text('Relatório Alerta de Estoque',style: pdfLib.TextStyle(fontSize: 30))
        ),
        pdfLib.Container(
            padding: pdfLib.EdgeInsets.symmetric(vertical: 4),
            child: pdfLib.Text(DateTime.now().toString())
        ),
        pdfLib.Row(
          mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
          children: [
            pdfLib.Container(
                width: width,
                child: pdfLib.Text('Marca')
            ),
            pdfLib.Container(
                width: width,
                child: pdfLib.Text('Modelo')
            ),
            pdfLib.Container(
                width: width,
                child: pdfLib.Text('Peça')
            ),
            pdfLib.Container(
                width: 50,
                child: pdfLib.Text('Cor')
            ),
            pdfLib.Container(
                width: 50,
                child: pdfLib.Text('Mínimo')
            ),
            pdfLib.Container(
                width: 70,
                child: pdfLib.Text('Estoque')
            ),
            pdfLib.Container(
                width: 120,
                alignment: pdfLib.Alignment.centerRight,
                child: pdfLib.Text('Quantidade\nFaltante')
            ),
          ],
        ),

        pdfLib.ListView.builder(
            itemCount: _resultsList.length,
        itemBuilder: (context, index) {
          DocumentSnapshot item = _resultsList[index];

          String id = item["id"];
          String stock = ErrorList(item,"estoque") ?? "";
          String stockMin = ErrorList(item,"estoqueMinimo") ?? "";
          String peca = ErrorList(item,"peca") ?? "";
          String selecionado2 = ErrorList(item,"selecionado2") ?? "";
          String brands = ErrorList(item,"marca") ?? "";
          String model = ErrorList(item,"modelo") ?? "";
          String description = ErrorList(item,"descricao") ?? "";
          String color = ErrorList(item,"cor") ?? "";

          if(stock==""){
            stock ="0";
          }
          if(stockMin==""){
            stockMin ="0";
          }

          int dif = int.parse(stockMin) - int.parse(stock);

          return dif<0?pdfLib.Container():pdfLib.Row(
            mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
            children: [
              pdfLib.Container(
                  width: width,
                  child: pdfLib.Text(brands)
              ),
              pdfLib.Container(
                  width: width,
                  child: pdfLib.Text(model)
              ),
              pdfLib.Container(
                  width: width,
                  child: pdfLib.Text(description)
              ),
              pdfLib.Container(
                  width: 40,
                  child: pdfLib.Text(color)
              ),
              pdfLib.Container(
                  alignment: pdfLib.Alignment.centerRight,
                  width: 50,
                  child: pdfLib.Text(stockMin)
              ),
              pdfLib.Container(
                  width: 50,
                  alignment: pdfLib.Alignment.centerRight,
                  child: pdfLib.Text(stock)
              ),
              pdfLib.Container(
                  padding: pdfLib.EdgeInsets.symmetric(horizontal: 30),
                  width: 120,
                  alignment: pdfLib.Alignment.centerRight,
                  child: pdfLib.Text(dif<0?"0":dif.toString())
              ),
            ],
          );
        }
        ),
      ]
    ));

  final String dir = (await getApplicationDocumentsDirectory()).path;

  final String path = '$dir/AlertaEstoque.pdf';

  final File file = File(path);
  file.writeAsBytesSync(pdf.save());
  
  Navigator.push(context,MaterialPageRoute(builder: (context)=>PDFScreen(path)));

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
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 15,
          color: PaletteColor.white,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: PaletteColor.appBar,
        title: Text('ALERTA DE ESTOQUE'),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: 55,
            child: Image.asset("assets/logoBig.png"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              InputSearch(controller: _controllerSearch),
              DividerList(),
              Container(
                height: height * 0.6,
                child: StreamBuilder(
                  stream: _controllerItem.stream,
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: _resultsList.length,
                        itemBuilder: (BuildContext context, index) {
                          DocumentSnapshot item = _resultsList[index];

                          String id           = item["id"];
                          String stock        = ErrorList(item,"estoque")??"";
                          String stockMin     = ErrorList(item,"estoqueMinimo")??"";
                          String peca         = ErrorList(item,"descricao")??"";
                          String selecionado2 = ErrorList(item,"selecionado2")??"";
                          String brands       = ErrorList(item,"marca")??"";
                          String model        = ErrorList(item,"modelo")??"";
                          String ref          = ErrorList(item,"referencia")??"";

                          if(stock==null || stock==""){
                            stock ="0";
                          }
                          if(stockMin==null || stockMin ==""){
                            stockMin="0";
                          }

                          int dif = int.parse(stockMin)-int.parse(stock);

                          return dif<0?Container():Column(
                            children: [
                              ExampleDataReport(
                                model: model,
                                ref: ref,
                                showImagem: false,
                                title: 'Peça : '+peca,
                                unidMin: int.parse(stockMin),
                                unidUp: int.parse(stock),
                                difference: dif<0?0:dif,
                                brands: brands,
                                colorsUp: selecionado2,
                              ),
                              DividerList()
                            ],
                          );
                        });
                  },
                ),
              ),
              ElevatedButton(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Gerar PDF'),
                    Icon(Icons.description,
                      color: PaletteColor.white,
                    ),
                  ],
                ) ,
                onPressed:()=> _resultsList.length!=0?_createPdf(context):showSnackBar(context, "Sem dados para o PDF"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PDFScreen extends StatelessWidget {
  PDFScreen(this.pathPDF);

  final String pathPDF;

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar:AppBar(
          title: Text('Alerta de Estoque'),
          actions: [
            IconButton(
                onPressed: (){
                  ShareExtend.share(pathPDF, 'file',sharePanelTitle: "Enviar PDF");
                },
                icon: Icon(Icons.share)
            )
          ],
        ) ,
        path: pathPDF
    );
  }
}
