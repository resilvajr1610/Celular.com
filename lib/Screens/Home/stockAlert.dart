import 'package:celular/widgets/buttonsRegister.dart';
import 'package:celular/widgets/dividerList.dart';
import 'package:celular/widgets/exampleDataReport.dart';
import 'package:celular/widgets/textTitle.dart';
import 'package:flutter/material.dart';

import '../../Model/export.dart';
import '../../widgets/dropDownItens.dart';
import '../../widgets/exampleDataHistory.dart';
import '../../widgets/inputSearch.dart';

class StockAlert extends StatefulWidget {
  const StockAlert({Key key}) : super(key: key);

  @override
  _StockAlertState createState() => _StockAlertState();
}

class _StockAlertState extends State<StockAlert> {

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
  String _selectedParts;
  String _selectedMobiles;
  String _selectedDisplay;
  String _selectedColors;
  String _input;
  String _output;
  String _alls;
  String _value;
  static double fonts=12;

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
        ),value: '',)
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
        title: Text('ALERTA DE ESTOQUE'),
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
                // DropdownItens(
                //     listItens: _listItensBrands,
                //     onChanged: (value){
                //       setState(() {
                //         _selectedBrands = value.toString();
                //       });
                //     },
                //     selected: _selectedBrands
                // ),
                // DropdownItens(
                //     listItens: _listItensModels,
                //     onChanged: (value){
                //       setState(() {
                //         _selectedModels = value.toString();
                //       });
                //     },
                //     selected: _selectedModels
                // ),
                // DropdownItens(
                //     listItens: _listItensMobiles,
                //     onChanged: (value){
                //       setState(() {
                //         _selectedMobiles = value.toString();
                //       });
                //     },
                //     selected: _selectedMobiles
                // ),
                // DropdownItens(
                //     listItens: _listItensParts,
                //     onChanged: (value){
                //       setState(() {
                //         _selectedParts = value.toString();
                //       });
                //     },
                //     selected: _selectedParts
                // ),
                Row(
                  children: [
                    Radio(
                        value: 'alerta',
                        groupValue: _input,
                        activeColor: PaletteColor.darkGrey,
                        onChanged: (value){
                          setState(() {
                            _value = value;
                            print('teste '+ _value.toString());
                          });
                        }
                    ),
                    TextTitle(
                        text: 'Abaixo do estoque',
                        fonts: 14
                    ),
                    Radio(
                        value: 'todos',
                        groupValue: _output,
                        activeColor: PaletteColor.darkGrey,
                        onChanged: (value){
                          setState(() {
                            _value = value;
                            print('teste '+ _value.toString());
                          });
                        }
                    ),
                    TextTitle(
                        text: 'Todos',
                        fonts: 14
                    ),
                  ],
                ),
                DividerList(),
                ExampleDataReport(
                  showImagem: false,
                  title: 'Display',
                  colorsUp: 'Dourado',
                  colorsLow: '15',
                  unidUp: 10,
                  unidLow: 05,
                ),
                DividerList(),
                ExampleDataReport(
                  showImagem: false,
                  title: 'Película 3D Privativa',
                  colorsUp: 'N/C',
                  colorsLow: '20',
                  unidUp: 15,
                  unidLow: 00,
                ),
                DividerList(),
                ExampleDataReport(
                  showImagem: false,
                  title: 'Película de Vidro',
                  colorsUp: 'N/C',
                  colorsLow: '10',
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
