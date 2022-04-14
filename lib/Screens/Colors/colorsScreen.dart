import 'package:celular/widgets/buttonsAdd.dart';
import 'package:celular/widgets/buttonsRegister.dart';
import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/inputRegister.dart';
import 'package:celular/widgets/inputSearch.dart';
import 'package:celular/widgets/itemsList.dart';
import 'package:celular/widgets/showDialogRegister.dart';
import 'package:flutter/material.dart';
import '../../Model/export.dart';

class ColorsScreen extends StatefulWidget {
  const ColorsScreen({Key key}) : super(key: key);

  @override
  _ColorsScreenState createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {

  TextEditingController _controllerSerch = TextEditingController();
  TextEditingController _controllerRegister = TextEditingController();

  _cadastrar(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return ShowDialogRegister(
              title: 'Cadastrar Cor',
              hint: 'Cor',
              list: [
                ButtonsRegister(onTap: ()=>Navigator.pop(context), text: 'Cancelar', color: PaletteColor.greyButton),
                Spacer(),
                ButtonsRegister(onTap: ()=>Navigator.pop(context), text: 'Incluir', color: PaletteColor.blueButton),
              ],
          );
        }
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
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: PaletteColor.white,
            fontWeight: FontWeight.w700,
          ),
          backgroundColor: PaletteColor.appBar,
          title: Text('COR'),
          actions: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: 55,
              child: Image.asset("assets/celularcom_ImageView_32-41x41.png"),
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
                  ButtonsAdd(onPressed: ()=> _cadastrar())
                ],
              ),
              ItemsList(item: 'Dourado'),
              DividerList(),
              ItemsList(item: 'Azul'),
              DividerList(),
              ItemsList(item: 'Preto'),
              DividerList(),
              ItemsList(item: 'Branco'),
            ],
          ),
        ));
  }
}
