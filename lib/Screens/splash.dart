import 'package:celular/Screens/Home/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Model/export.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Future<bool> _mockCheckForSession()async{
    await Future.delayed(Duration(milliseconds: 5000),(){});

    return true;
  }

  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then(
            (status) {
          if(status){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: ( BuildContext context) => HomeScreen()
                )
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: PaletteColor.appBar,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 180,
                width: 182,
                child:
                Image.asset("assets/celularcom_ImageView_19-182x180.png"),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(color: PaletteColor.white)
            ],
          ),
        ));
  }
}
