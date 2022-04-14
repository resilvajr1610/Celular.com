import 'package:celular/widgets/buttonsAdd.dart';
import 'package:celular/widgets/buttonsRegister.dart';
import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/dropDownItens.dart';
import 'package:celular/widgets/inputRegister.dart';
import 'package:celular/widgets/inputSearch.dart';
import 'package:celular/widgets/itemsList.dart';
import 'package:flutter/material.dart';
import '../../../Model/export.dart';

class MobilesScreen extends StatefulWidget {
  const MobilesScreen({Key key}) : super(key: key);

  @override
  _MobilesScreenState createState() => _MobilesScreenState();
}

class _MobilesScreenState extends State<MobilesScreen> {

  TextEditingController _controllerSerch = TextEditingController();
  TextEditingController _controllerRegister = TextEditingController();
  List<DropdownMenuItem<String>>_listItens = [];
  String _selected;

  static List<DropdownMenuItem<String>> getMobile(){
    List<DropdownMenuItem<String>> itensDrop = [];

    itensDrop.add(
        DropdownMenuItem(child: Text("Selecione a marca",style: TextStyle(fontSize: 15,color: Colors.black54)),value: "",));
    itensDrop.add(
        DropdownMenuItem(child: Text("Apple",style: TextStyle(fontSize: 15,color: Colors.black54),),value: "Apple",)
    );
    return itensDrop;
  }

  _loadingItensDropdown(){
    _listItens = getMobile();
  }

  @override
  void initState() {
    super.initState();
    _loadingItensDropdown();
  }

  _cadastrar(){
    double width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return SingleChildScrollView(
            child: AlertDialog(
              title: Center(child: Text('Cadastrar Celular')),
              titleTextStyle: TextStyle(color: PaletteColor.darkGrey,fontSize: 20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownItens(
                      selected: _selected,
                      listItens: _listItens,
                      onChanged: (value){
                        setState(() {
                          _selected = value.toString();
                        });
                      }),
                  InputRegister(controller: _controllerRegister, hint: 'Celular',width: width*0.7,fonts: 20)
                ],
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              actions: [
                ButtonsRegister(onTap: ()=>Navigator.pop(context), text: 'Cancelar', color: PaletteColor.greyButton),
                Spacer(),
                ButtonsRegister(onTap: ()=>Navigator.pop(context), text: 'Incluir', color: PaletteColor.blueButton),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text('CELULAR'),
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
              DropdownItens(
                  listItens: _listItens,
                  onChanged: (valor){
                    setState(() {
                      _selected = valor;
                    });
                  }),
              ItemsList(item: "iPhone 5"),
              DividerList(),
              ItemsList(item: "iPhone 6"),
              DividerList(),
              ItemsList(item: "iPhone 7"),
              DividerList(),
              ItemsList(item: "iPhone 8"),
            ],
          ),
        ));
  }
}
