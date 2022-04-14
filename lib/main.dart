import 'package:celular/Model/RouteGenerator.dart';
import 'package:celular/Screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

String urlInicial = "/";

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splash(),
    initialRoute: urlInicial,
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}