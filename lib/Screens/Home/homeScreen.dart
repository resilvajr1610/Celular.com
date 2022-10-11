import '../../Utils/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controllerBroadcast = StreamController<QuerySnapshot>.broadcast();
  String _selectedStore;
  String storeUser;

  @override
  void initState() {
    super.initState();
    if(auth.currentUser==null){
      Future.delayed(Duration.zero,(){
        print("não entrou");
        Navigator.pushReplacementNamed(context, "/login");
      });
    }else{
      dataUser();
    };
  }

  dataUser()async{
    DocumentSnapshot snapshot = await db
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser.email)
        .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    // if(data['store']!=null){
    //   setState(() {
    //     storeUser = data['store']??'';
    //     _selectedStore = storeUser;
    //   });
    // }
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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: PaletteColor.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: PaletteColor.appBar,
          actions: [
            Container(
              width: width,
              child: Image.asset("assets/logoSmall.png"),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                DropdownItens(
                    streamBuilder: streamStories(),
                    onChanged: (valor){
                      setState(() {
                        _selectedStore = valor;
                      });
                    }),
                ButtonsEnterScreens(
                    text: "Cadastrar Categorias",
                    onPressed: () => Navigator.pushNamed(context, "/categories")),
                ButtonsEnterScreens(
                    text: "Cadastro de Estoque",
                    onPressed: () => Navigator.pushNamed(context, "/inventoryControl")),
                ButtonsEnterScreens(
                    text: "Histórico de preços",
                    onPressed: () => Navigator.pushNamed(context, "/priceHistory")),
                ButtonsEnterScreens(
                    text: "Relatório de Estoque",
                    onPressed: () => Navigator.pushNamed(context, "/stockReport")),
                ButtonsEnterScreens(
                    text: "Alerta de Estoque",
                    onPressed: () => Navigator.pushNamed(context, "/stockAlert")),
              ],
            ),
          ),
        ));
  }
}
