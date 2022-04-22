import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Model/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  _logar()async{

    //auth.signOut();
    auth.signInWithEmailAndPassword(
        email: "adm@gmail.com",
        password: "admcelular123"
    ).then((firebaseUser) {

      print("usuario logado");

    }).catchError((error){
      auth.signInWithEmailAndPassword(
        email: "admcelular@gmail.com",
        password: "admcelular123",
      ).then((value) => print("usuario logado segundo usuario"));
    }
    );
  }

  @override
  void initState() {
    super.initState();
    _logar();
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
              child: Image.asset("assets/Group_ImageView_26-241x41.png"),
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
