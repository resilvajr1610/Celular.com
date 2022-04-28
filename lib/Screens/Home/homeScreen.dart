import '../../Model/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if(auth.currentUser==null){
      Future.delayed(Duration.zero,(){
        print("não entrou");
        Navigator.pushReplacementNamed(context, "/login");
      });
    };
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
