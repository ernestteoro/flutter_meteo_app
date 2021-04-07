import 'package:flutter/material.dart';
import 'package:flutter_meteo_app/stateless/my_app.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
void main() async{
   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

   Location location = new Location();

   LocationData position;

   try{
      position = await location.getLocation();

   } on PlatformException catch(e){
     print("Erreur de location $e");
   }

   if(position!=null){
     final coordinates = Coordinates(position.latitude, position.latitude);
     Geocoder.local.findAddressesFromCoordinates(coordinates).then((onValue){
       runApp(MyApp(onValue.first.locality));
     }).catchError((onError){
       print(onError);
     });
   }else{
     print("Inside else of position  not null ");
     runApp(MyApp(""));
   }

}
