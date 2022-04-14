import 'package:celular/widgets/buttonsAdd.dart';
import 'package:celular/widgets/buttonsRegister.dart';
import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/dropDownItens.dart';
import 'package:celular/widgets/inputRegister.dart';
import 'package:celular/widgets/inputSearch.dart';
import 'package:celular/widgets/itemsList.dart';
import 'package:flutter/material.dart';
import '../../../Model/export.dart';
import '../../../Model/export.dart';

class PartsScreen extends StatefulWidget {
  const PartsScreen({Key key}) : super(key: key);

  @override
  _PartsScreenState createState() => _PartsScreenState();
}

class _PartsScreenState extends State<PartsScreen> {

  TextEditingController _controllerSerch = TextEditingController();
  TextEditingController _controllerRegister = TextEditingController();
  List<DropdownMenuItem<String>>_listItensBrands = [];
  List<DropdownMenuItem<String>>_listItensModels = [];
  String _selectedBrands;
  String _selectedModels;

  static List<DropdownMenuItem<String>> getBrands(){
    List<DropdownMenuItem<String>> itensDrop = [];

    itensDrop.add(
        DropdownMenuItem(child: Text(
          "Selecione a marca",style: TextStyle(fontSize: 15,color: Colors.black54),
        ),value: null,)
    );
    itensDrop.add(
        DropdownMenuItem(child: Text("Apple",style: TextStyle(fontSize: 15,color: Colors.black54),),value: "Apple",)
    );
    return itensDrop;
  }
  static List<DropdownMenuItem<String>> getModels(){
    List<DropdownMenuItem<String>> itensDrop = [];

    itensDrop.add(
        DropdownMenuItem(child: Text(
          "Todos os modelos",style: TextStyle(fontSize: 15,color: Colors.black54),
        ),value: null,)
    );
    itensDrop.add(
        DropdownMenuItem(child: Text("iPhone 5",style: TextStyle(fontSize: 15,color: Colors.black54),),value: "iPhone 5",)
    );
    itensDrop.add(
        DropdownMenuItem(child: Text("iPhone 6",style: TextStyle(fontSize: 15,color: Colors.black54),),value: "iPhone 6",)
    );
    return itensDrop;
  }

  _carregarItensDropdown(){
    _listItensBrands = getBrands();
    _listItensModels = getModels();
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
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
          title: Text('MODELO'),
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
                  ButtonsAdd(onPressed: ()=> Navigator.pushNamed(context, "/partsRegister"))
                ],
              ),
              DropdownItens(
                  listItens: _listItensBrands,
                  onChanged: (valor){
                    setState(() {
                      _selectedBrands = valor;
                    });
                  }),
              DropdownItens(
                  listItens: _listItensModels,
                  onChanged: (valor){
                    setState(() {
                      _selectedModels = valor;
                    });
                  }),
              ItemsList(item: "A1522"),
              DividerList(),
              ItemsList(item: "A1563"),
              DividerList(),
              ItemsList(item: "A2221"),
              DividerList(),
              ItemsList(item: "A2227"),
            ],
          ),
        ));
  }
}
