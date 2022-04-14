import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Model/colors.dart';
import '../../Model/export.dart';

class InventoryControlScreen extends StatefulWidget {
  const InventoryControlScreen({Key key}) : super(key: key);

  @override
  _InventoryControlScreenState createState() => _InventoryControlScreenState();
}

class _InventoryControlScreenState extends State<InventoryControlScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: PaletteColor.white,
        appBar: AppBar(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 15,
            color: PaletteColor.white,
            fontWeight: FontWeight.w700,
          ),
          backgroundColor: PaletteColor.appBar,
          title: Text('CONTROLE DE ESTOQUE'),
          actions: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: 55,
              child: Image.asset("assets/celularcom_ImageView_32-41x41.png"),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Column(
              children: [
                ButtonsEnterScreens(
                    text: "Entrada",
                    onPressed: () => Navigator.pushNamed(context, "/input")),
                ButtonsEnterScreens(
                    text: "Saída",
                    onPressed: () => Navigator.pushNamed(context, "/output")),
              ],
            ),
          ),
        ));
  }
}
