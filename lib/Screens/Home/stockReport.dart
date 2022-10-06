import '../../Utils/export.dart';
import 'package:pdf/widgets.dart' as pdfLib;

class StockReport extends StatefulWidget {
  const StockReport({Key key}) : super(key: key);

  @override
  _StockReportState createState() => _StockReportState();
}

class _StockReportState extends State<StockReport> {

  TextEditingController _controllerSearch = TextEditingController();
  var _controllerItem = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;
  String storeUser = '';

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
    var data = await db.collection("pecas").where('store$storeUser',isEqualTo: storeUser).get();

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

    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    double width = 80;
    int lines = 32;
    int pages = (_resultsList.length/lines).round()+1;
    int pag=0;
    for(var i=0;pages>i;i++){
      pdf.addPage(pdfLib.MultiPage(
          build: (context)=>[

            pdfLib.Container(
                padding: pdfLib.EdgeInsets.symmetric(vertical: 4),
                child: pdfLib.Text('Relatório de Estoque',style: pdfLib.TextStyle(fontSize: 30))
            ),
            pdfLib.Container(
                padding: pdfLib.EdgeInsets.symmetric(vertical: 4),
                child: pdfLib.Text(DateTime.now().toString())
            ),
            pdfLib.Row(
              mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
              children: [
                pdfLib.Container(
                    padding: pdfLib.EdgeInsets.symmetric(vertical: 5),
                    width: 120,
                    child: pdfLib.Text('Marca')
                ),
                pdfLib.Container(
                    width: 90,
                    child: pdfLib.Text('Modelo')
                ),
                pdfLib.Container(
                    width: 100,
                    child: pdfLib.Text('Peça')
                ),
                pdfLib.Container(
                    width: 80,
                    child: pdfLib.Text('Cor')
                ),
                pdfLib.Container(
                    width: 60,
                    child: pdfLib.Text('Mínimo')
                ),
                pdfLib.Container(
                    width: 70,
                    child: pdfLib.Text('Estoque')
                ),
              ],
            ),

            pdfLib.ListView.builder(
                itemCount: lines,
                itemBuilder: (context, index) {
                  int indexGeral = index+pag;
                  DocumentSnapshot item = _resultsList[indexGeral>=_resultsList.length?0:indexGeral];

                  // print('index ${indexGeral>=_resultsList.length?0:indexGeral}');

                  String id = item["id"];
                  String stock = ErrorList(item,"estoque$storeUser") ?? "";
                  String stockMin = ErrorList(item,"estoqueMinimo$storeUser") ?? "";
                  String brands = ErrorList(item,"marca") ?? "";
                  String model = ErrorList(item,"modelo") ?? "";
                  String description = ErrorList(item,"descricao") ?? "";
                  String color = ErrorList(item,"cor") ?? "";

                  if(stock=="" || stock=="sem dados"){
                    stock ="0";
                  }
                  if(stockMin=="" || stockMin=="sem dados"){
                    stockMin ="0";
                  }

                  int dif = int.parse(stockMin) - int.parse(stock);
                  return indexGeral>=_resultsList.length
                    ?pdfLib.Container(): pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                    children: [
                      pdfLib.Container(
                          padding: pdfLib.EdgeInsets.symmetric(vertical: 2),
                          width: 90,
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
                          child: pdfLib.Text(color==""?"N/C":color)
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
                    ],
                  );
                }
            ),
          ]
      ));
      pag = pag+lines;
    }

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

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
        title: Text('RELATÓRIO DE ESTOQUE'),
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
            Column(
              children: [
                InputSearch(controller: _controllerSearch),
                DividerList(),
                Container(
                  height: height * 0.6,
                  child: StreamBuilder(
                    stream: _controllerItem.stream,
                    builder: (context, snapshot) {
                      return ListView.separated(
                          separatorBuilder: (context, index) => DividerList(),
                          itemCount: _resultsList.length,
                          itemBuilder: (BuildContext context, index) {
                            DocumentSnapshot item = _resultsList[index];

                            String id        = item["id"];
                            String stock    = ErrorList(item,"estoque$storeUser")??"";
                            String peca    = ErrorList(item,"descricao")??"";
                            String cor    = ErrorList(item,"cor")??"";
                            String foto    = ErrorList(item,"foto")??"";
                            String brands    = ErrorList(item,"marca")??"";
                            String model    = ErrorList(item,"modelo")??"";
                            String ref    = ErrorList(item,"referencia")??"";

                            if(stock==null || stock=="" || stock=="sem dados"){
                              stock ="0";
                            }

                            return ExampleDataReport(
                              showImagem: true,
                              photo: foto,
                              title: peca,
                              model: model,
                              brands: brands,
                              ref: ref,
                              colorsUp: cor==""?"N/C":cor,
                              unidUp: int.parse(stock),
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
          ],
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
          title: Text('Relatório de Estoque',style: TextStyle(fontSize: 15),),
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
