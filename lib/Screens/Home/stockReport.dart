import 'package:celular/widgets/buttonsRegister.dart';
import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/exampleDataReport.dart';
import 'package:celular/widgets/textTitle.dart';
import 'package:flutter/material.dart';

import '../../Model/export.dart';
import '../../widgets/dropDownItens.dart';
import '../../widgets/exampleDataHistory.dart';
import '../../widgets/inputSearch.dart';

class StockReport extends StatefulWidget {
  const StockReport({Key key}) : super(key: key);

  @override
  _StockReportState createState() => _StockReportState();
}

class _StockReportState extends State<StockReport> {

  TextEditingController _controllerSeach = TextEditingController();
  TextEditingController _controllerStock = TextEditingController();
  TextEditingController _controllerPriceSale = TextEditingController();
  List<DropdownMenuItem<String>>_listItensBrands = [];
  List<DropdownMenuItem<String>>_listItensModels = [];
  List<DropdownMenuItem<String>>_listItensParts = [];
  List<DropdownMenuItem<String>>_listItensMobiles = [];
  List<DropdownMenuItem<String>>_listItensDisplay = [];
  List<DropdownMenuItem<String>>_listItensColors = [];
  String _selectedBrands;
  String _selectedModels;
  String _selectedParts="";
  String _selectedMobiles;
  String _selectedDisplay;
  String _selectedColors;
  static double fonts=15.0;

  static List<DropdownMenuItem<String>> getBrands(){
    List<DropdownMenuItem<String>> itensDrop = [];

    //categorias
    itensDrop.add(
        DropdownMenuItem(child: Text("Selecione a marca",style: TextStyle(fontSize: fonts,color: Colors.black54)),value: "",));
    itensDrop.add(
        DropdownMenuItem(child: Text("Apple",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "Apple",));
    return itensDrop;
  }

  static List<DropdownMenuItem<String>> getMobiles(){
    List<DropdownMenuItem<String>> itensDrop = [];

    itensDrop.add(DropdownMenuItem(child: Text("Selecione o celular",style: TextStyle(fontSize: fonts,color: Colors.black54)),value: ""));
    itensDrop.add(DropdownMenuItem(child: Text("A1428",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "A1428"));

    return itensDrop;
  }

  static List<DropdownMenuItem<String>> getModels(){
    List<DropdownMenuItem<String>> itensDrop = [];

    itensDrop.add(
        DropdownMenuItem(child: Text(
          "Todos os modelos",style: TextStyle(fontSize: fonts,color: Colors.black54),
        ),value: null,)
    );
    itensDrop.add(
        DropdownMenuItem(child: Text("iPhone 5",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "iPhone 5",)
    );
    itensDrop.add(
        DropdownMenuItem(child: Text("iPhone 6",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "iPhone 6",)
    );
    return itensDrop;
  }

  static List<DropdownMenuItem<String>> getParts(){
    List<DropdownMenuItem<String>> itensDrop = [];

    itensDrop.add(
        DropdownMenuItem(child: Text(
          "Todas as peças",style: TextStyle(fontSize: fonts,color: Colors.black54),
        ),value: "",)
    );
    itensDrop.add(
        DropdownMenuItem(child: Text("Display",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "Display",)
    );
    itensDrop.add(
        DropdownMenuItem(child: Text("Câmera Frontal",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "Câmera Frontal",)
    );
    return itensDrop;
  }

  static List<DropdownMenuItem<String>> getDisplay(){
    List<DropdownMenuItem<String>> itensDrop = [];

    itensDrop.add(
        DropdownMenuItem(child: Text("LCD",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "LCD")
    );
    itensDrop.add(
        DropdownMenuItem(child: Text("OLED",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "OLED")
    );
    return itensDrop;
  }

  static List<DropdownMenuItem<String>> getColors(){
    List<DropdownMenuItem<String>> itensDrop = [];

    itensDrop.add(
        DropdownMenuItem(child: Text("Dourado",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "Dourado")
    );
    itensDrop.add(
        DropdownMenuItem(child: Text("Azul",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "Azul")
    );
    itensDrop.add(
        DropdownMenuItem(child: Text("Preto",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "Preto")
    );
    itensDrop.add(
        DropdownMenuItem(child: Text("Branco",style: TextStyle(fontSize: fonts,color: Colors.black54),),value: "Branco")
    );
    return itensDrop;
  }

  _loadingItensDropdown(){
    _listItensBrands = getBrands();
    _listItensModels = getModels();
    _listItensParts = getParts();
    _listItensMobiles = getMobiles();
    _listItensDisplay = getDisplay();
    _listItensColors = getColors();
  }

  @override
  void initState() {
    super.initState();
    _loadingItensDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        label: Text('Gerar PDF'),
      ),
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
            child: Image.asset("assets/celularcom_ImageView_32-41x41.png"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                InputSearch(controller: _controllerSeach),
                DropdownItens(
                    listItens: _listItensBrands,
                    onChanged: (value){
                      setState(() {
                        _selectedBrands = value.toString();
                      });
                    },
                    selected: _selectedBrands
                ),
                DropdownItens(
                    listItens: _listItensModels,
                    onChanged: (value){
                      setState(() {
                        _selectedModels = value.toString();
                      });
                    },
                    selected: _selectedModels
                ),
                DropdownItens(
                    listItens: _listItensMobiles,
                    onChanged: (value){
                      setState(() {
                        _selectedMobiles = value.toString();
                      });
                    },
                    selected: _selectedMobiles
                ),
                DropdownItens(
                    listItens: _listItensParts,
                    onChanged: (value){
                      setState(() {
                        _selectedParts = value.toString();
                      });
                    },
                    selected: _selectedParts
                ),
                DividerList(),
                ExampleDataReport(
                  showImagem: true,
                  title: 'Display',
                  colorsUp: 'Dourado',
                  colorsLow: 'Preto',
                  unidUp: 10,
                  unidLow: 05,
                ),
                DividerList(),
                ExampleDataReport(
                  showImagem: true,
                  title: 'Película 3D Privativa',
                  colorsUp: 'N/C',
                  colorsLow: 'N/C',
                  unidUp: 15,
                  unidLow: 00,
                ),
                DividerList(),
                ExampleDataReport(
                  showImagem: true,
                  title: 'Película de Vidro',
                  colorsUp: 'N/C',
                  colorsLow: 'N/C',
                  unidUp: 08,
                  unidLow: 05,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
