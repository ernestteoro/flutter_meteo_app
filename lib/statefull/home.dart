import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_meteo_app/model/temps.dart';
import 'package:flutter_meteo_app/my_flutter_app_icons.dart';


class HomePage extends StatefulWidget {
  HomePage(String ville, {Key key, this.title}) : super(key: key){
    this.villeUtilisateur = ville;
  }

  final String title;
  String villeUtilisateur;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String keys="villes";

  List<String> villes = [];

  Temps tempsActuel = null;

  @override
  void initState(){
    super.initState();
    getDataFromSharedPreferences();
    appelApi();
  }

  String villeChoisie= "San Francisco" ;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Container(
          child: ListView.builder(
              itemCount: villes.length+2,
              itemBuilder: (context,i){
                if(i==0){
                  return DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        textAvecStyle("Mes villes ", fontSize: 22.5),
                        RaisedButton(
                          elevation: 7.5,
                            onPressed: (){
                              ajouterVille();
                            },
                          color: Colors.white,
                          child: textAvecStyle("Ajouter une ville ", color: Colors.blue),
                        )
                      ],
                    ),

                  );
                }
                if(i==1){
                  return ListTile(
                    title: textAvecStyle(widget.villeUtilisateur,fontSize: 35.0,fontStyle: FontStyle.normal,),
                    onTap: (){
                      setState(() {
                        villeChoisie =null;
                        appelApi();
                        Navigator.pop(context);
                      });
                    },
                  );
                } else{
                  String ville = villes[i-2];
                  return ListTile(
                    title: textAvecStyle(ville),
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: (){
                          supprimerVille(ville);
                        },
                      color: Colors.white,
                    ),
                    onTap: (){
                      setState(() {
                        villeChoisie = ville;
                        appelApi();
                        Navigator.pop(context);
                      });
                    },
                  );
                }
              }),
          color: Colors.blue,
        )

      ),
      body:(tempsActuel==null)?
      Center(
        child: Text((villeChoisie==null) ? widget.villeUtilisateur : villeChoisie),
      ):
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(assetName()),
            fit: BoxFit.cover
          )
        ),
        //padding: EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            textAvecStyle(tempsActuel.name,  fontSize: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                textAvecStyle("${tempsActuel.temp}°C", fontSize: 60.0),
                Image.asset(tempsActuel.icon)
              ],
            ),
            textAvecStyle(tempsActuel.main,fontSize: 30.0),
            textAvecStyle(tempsActuel.description, fontSize: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(MyFlutterApp.temperatire, size: 35.0,),
                    textAvecStyle(tempsActuel.pressure.toString(),fontSize: 25.0),
                  ],
                ),

                Column(
                  children: <Widget>[
                    Icon(MyFlutterApp.droplet, size: 35.0,),
                    textAvecStyle(tempsActuel.humidity.toString(),fontSize: 25.0),
                  ],
                ),

                Column(
                  children: <Widget>[
                    Icon(MyFlutterApp.arrow_downward, size: 35.0,),
                    textAvecStyle(tempsActuel.temp_min.toString(),fontSize: 25.0),
                  ],
                ),

                Column(
                  children: <Widget>[
                    Icon(MyFlutterApp.arrow_upward, size: 35.0,),
                    textAvecStyle(tempsActuel.temp_max.toString(),fontSize: 25.0),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // function to get asset name
  String assetName(){
      if(tempsActuel.icon.contains("d")){
        return "assets/n.jpg";
      }else if(tempsActuel.icon.contains("01") || tempsActuel.icon.contains("02") || tempsActuel.icon.contains("03")){
        return "assets/d1.jpg";
      }else{
        return "assets/d2.jpg";
      }
    return "assets/dn1.jpg";
  }
  // function to show dialog box
  Future<Null> ajouterVille() async{
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext){
        return SimpleDialog(
          contentPadding: EdgeInsets.all(20.0),
          title: textAvecStyle("Ajout nouvelle ville",fontSize: 22.0, color: Colors.blue),
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Nouvelle ville"),
              onSubmitted: (String inputData){
                setDataFromSharedPreferences(inputData);
                Navigator.pop(buildContext);
              },
            )
          ],
        );
      }
    );
  }

  // function to return a text view with style
  Text textAvecStyle(String data,{color: Colors.white, fontSize:20.5,
    fontStyle: FontStyle.italic, textAlign: TextAlign.center}){
    return Text(data,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontStyle: fontStyle
      ),
    );
  }

  // function to get data from sharedPreferences
  void getDataFromSharedPreferences() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> list = await sharedPreferences.getStringList(keys);
    if(list!=null){
      setState(() {
        villes = list;
      });
    }
  }

  // function to set data in shared preferences
  void setDataFromSharedPreferences(String data) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    villes.add(data);
    await sharedPreferences.setStringList(keys, villes);
    getDataFromSharedPreferences();
  }

  // function to delete city from the list
  void supprimerVille(String value) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      villes.remove(value);
    });
    await sharedPreferences.setStringList(keys, villes);
  }

  // Function to get coordinates from city name
  void appelApi() async{
    String city;

    if((villeChoisie==null)&& (widget.villeUtilisateur!="Gölbaşı")){
      city = widget.villeUtilisateur;
    }else{
      city = villeChoisie;
    }
    List<Address> listAddress = await Geocoder.local.findAddressesFromQuery(city);
    if(!listAddress.isEmpty){
      final lat = listAddress.first.coordinates.latitude;
      final lon = listAddress.first.coordinates.longitude;
      final lang = Localizations.localeOf(context).languageCode;
      final key ="b4ddd47c36b994beb6f9f1ceb52be8d2";
      String apiUrl ="http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&lang=$lang&APPID=$key";
      final response =await http.get(apiUrl);
      if(response.statusCode==200){
        Temps temps =Temps();
        print(response.body);
        Map map = json.decode(response.body);
        temps.fromJSON(map);
        print("Current presure  ");
        print(temps.pressure);
        setState(() {
          tempsActuel = temps;
        });
      }
    }
  }
}
