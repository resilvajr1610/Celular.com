import '../../Utils/export.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
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
          title: Text('CATEGORIAS'),
          actions: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: 55,
              child: Image.asset("assets/logoBig.png"),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Column(
              children: [
                ButtonsEnterScreens(
                    text: "Marcas",
                    onPressed: () => Navigator.pushNamed(context, "/brands")),
                ButtonsEnterScreens(
                    text: "Peças",
                    onPressed: () => Navigator.pushNamed(context, "/mobiles")),
                ButtonsEnterScreens(
                    text: "Cores",
                    onPressed: () => Navigator.pushNamed(context, "/colors")),
              ],
            ),
          ),
        ));
  }
}
