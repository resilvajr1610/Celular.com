import 'package:celular/Screens/Categories/Referencies/add_ref_screen.dart';
import 'package:celular/Screens/Categories/Referencies/refScreen.dart';
import 'package:celular/Screens/Categories/Stories/add_store_screen.dart';
import 'package:celular/Screens/Categories/Supply/add_supply_screen.dart';
import 'package:celular/Screens/Categories/Supply/supplyScreen.dart';
import 'package:celular/Utils/export.dart';
import 'package:celular/Screens/Home/stockReport.dart';
import '../Screens/Categories/Stories/StoreScreen.dart';

class RouteGenerator{
    static Route<dynamic> generateRoute(RouteSettings settings){
      final args = settings.arguments;
      switch(settings.name){
        case "/" :
          return MaterialPageRoute(
              builder: (_) => HomeScreen()
          );
        case "/home" :
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
              builder: (_) => PartsScreen()
          );
        case "/colors" :
          return MaterialPageRoute(
              builder: (_) => ColorsScreen()
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
        case "/login" :
          return MaterialPageRoute(
              builder: (_) => Login()
          );
        case "/ref" :
          return MaterialPageRoute(
              builder: (_) => RefScreen()
          );
        case "/add_ref" :
          return MaterialPageRoute(
              builder: (_) => AddRefScreen(id: args,)
          );
        case "/supply" :
          return MaterialPageRoute(
              builder: (_) => SupplyScreen()
          );
        case "/add_supply" :
          return MaterialPageRoute(
              builder: (_) => AddSupplyScreen()
          );
        case "/store" :
          return MaterialPageRoute(
              builder: (_) => StoreScreen()
          );
        case "/add_store" :
          return MaterialPageRoute(
              builder: (_) => AddStoreScreen()
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