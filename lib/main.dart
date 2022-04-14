import 'package:celular/Model/RouteGenerator.dart';
import 'package:celular/Screens/splash.dart';
import 'package:flutter/material.dart';

String urlInicial = "/";

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splash(),
    initialRoute: urlInicial,
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}