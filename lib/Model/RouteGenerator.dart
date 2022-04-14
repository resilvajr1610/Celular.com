import 'package:celular/Model/export.dart';
import 'package:celular/Screens/Categories/Parts/PartsRegister.dart';
import 'package:celular/Screens/Home/categoriesScreen.dart';
import 'package:celular/Screens/Categories/Brands/brandsScreen.dart';
import 'package:celular/Screens/Categories/Parts/partsScreen.dart';
import 'package:celular/Screens/Home/homeScreen.dart';
import 'package:celular/Screens/Home/inventoryControlScreen.dart';
import 'package:celular/Screens/Home/priceHistory.dart';
import 'package:celular/Screens/Home/stockAlert.dart';
import 'package:celular/Screens/Home/stockReport.dart';
import 'package:celular/Screens/InventoryControl/Input.dart';
import 'package:celular/Screens/InventoryControl/output.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/Colors/colorsScreen.dart';

class RouteGenerator{
    static Route<dynamic> generateRoute(RouteSettings settings){
      final args = settings.arguments;

      switch(settings.name){
        case "/" :
          return MaterialPageRoute(
              builder: (_) => HomeScreen()
          );
        case "/categories" :
          return MaterialPageRoute(
              builder: (_) => CategoriesScreen()
          );
        case "/brands" :
          return MaterialPageRoute(
              builder: (_) => BrandsScreen()
          );
        case "/mobiles" :
          return MaterialPageRoute(
              builder: (_) => MobilesScreen()
          );
        case "/colors" :
          return MaterialPageRoute(
              builder: (_) => ColorsScreen()
          );
        case "/parts" :
          return MaterialPageRoute(
              builder: (_) => PartsScreen()
          );
        case "/partsRegister" :
          return MaterialPageRoute(
              builder: (_) => PartsResgister()
          );
        case "/inventoryControl" :
          return MaterialPageRoute(
              builder: (_) => InventoryControlScreen()
          );
        case "/input" :
          return MaterialPageRoute(
              builder: (_) => Input()
          );
        case "/output" :
          return MaterialPageRoute(
              builder: (_) => Output()
          );
        case "/priceHistory" :
          return MaterialPageRoute(
              builder: (_) => PriceHistory()
          );
        case "/stockReport" :
          return MaterialPageRoute(
            builder: (_) => StockReport()
        );
        case "/stockAlert" :
          return MaterialPageRoute(
              builder: (_) => StockAlert()
          );

        default :
          _erroRota();
      }
    }
    static  Route <dynamic> _erroRota(){
      return MaterialPageRoute(
          builder:(_){
            return Scaffold(
              appBar: AppBar(
                title: Text("Tela em desenvolvimento"),
              ),
              body: Center(
                child: Text("Tela em desenvolvimento"),
              ),
            );
          });
    }
  }