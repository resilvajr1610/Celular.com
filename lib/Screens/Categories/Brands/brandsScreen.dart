import 'package:celular/widgets/buttonsAdd.dart';
import 'package:celular/widgets/buttonsRegister.dart';
import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/inputRegister.dart';
import 'package:celular/widgets/inputSearch.dart';
import 'package:celular/widgets/itemsList.dart';
import 'package:flutter/material.dart';
import '../../../Model/export.dart';
import '../../../widgets/showDialogRegister.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({Key key}) : super(key: key);

  @override
  _BrandsScreenState createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {

  TextEditingController _controllerSerch = TextEditingController();
  TextEditingController _controllerRegister = TextEditingController();

  _cadastrar(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return ShowDialogRegister(
            title: 'Cadastrar Marca',
            hint: 'Nova Marca',
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
          title: Text('MARCA'),
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
              ItemsList(item: 'Apple'),
              DividerList(),
              ItemsList(item: 'Motorola'),
              DividerList(),
              ItemsList(item: 'LG'),
              DividerList(),
              ItemsList(item: 'Samsung')
            ],
          ),
        ));
  }
}
