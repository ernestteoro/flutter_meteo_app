import 'package:flutter/material.dart';
import 'package:flutter_meteo_app/statefull/home.dart';

class MyApp extends StatelessWidget {

  MyApp(String ville){
    this.ville = ville;
  }

  String ville;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meteo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(ville, title: 'Meteo App'),
      debugShowCheckedModeBanner: false,
    );
  }
}