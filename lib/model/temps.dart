

class Temps{
  String name;
  String main;
  String description;
  String icon;
  var temp;
  var pressure;
  var humidity;
  var temp_min;
  var temp_max;

  Temps(){

  }


  void fromJSON(Map map){
    this.name = map["name"];
    List weather = map["weather"];
    Map mapWeather = weather[0];
    this.main = mapWeather["main"];
    this.description =mapWeather["description"];
    String monIcon = mapWeather["icon"];
    this.icon = "assets/${monIcon.replaceAll("d", "").replaceAll("n", "")}.png";

    Map mainMap = map["main"];
    this.temp = mainMap["temp"];
    this.pressure= mainMap["pressure"];
    this.humidity = mainMap["humidity"];
    this.temp_min = mainMap["temp_min"];
    this.temp_max = mainMap["temp_max"];


  }
}