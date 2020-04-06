import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position position;
  void getLocation() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("position=");
    // print(position);
    // print(position.latitude);
    // print(position.longitude);
    // print(position.accuracy);
    // print(position.timestamp);
  }

  var data, temp;

  Future getData() async {
    //This url for latitude and longitude
    var url =
        "http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=64e220448cf1af7c0486e8e3dab0dd0a&units=metric";
    //This url for Your input location
    // var url ="http://api.openweathermap.org/data/2.5/weather?q=mumbai&appid=64e220448cf1af7c0486e8e3dab0dd0a&units=metric";
    var responce = await http.get(Uri.encodeFull(url));
    print(responce.body);
    setState(() {
      var convertData = json.decode(responce.body);
      data = convertData;
      temp = data['main']['temp'];
      print(convertData);
      print("Temp= $temp");
    });
  }

  Widget customList(String day, var temp, var status, var date) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    day,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    date,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Container(
                width: 100,
                child: Row(
                  children: <Widget>[
                    Text(
                      temp,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      status,
                      color: Colors.white,
                      size: 30.0,
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: temp < 20 ? Color(0xff1D274B) : Color(0xffBB76A2),
        body: data == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 22.0),
                    child: ListTile(
                      leading: Icon(Icons.flight_takeoff,
                          size: 30.0, color: Colors.white),
                      title: Text(
                        "${(data['name'])}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 27.0,
                          color: Colors.white,
                          letterSpacing: 3.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing:
                          Icon(Icons.search, size: 30.0, color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16.0),
                    height: MediaQuery.of(context).size.height * 0.20,
                    width: double.infinity,
                    child: Image(
                        fit: BoxFit.contain,
                        image: temp < 20
                            ? AssetImage("images/pic2.png")
                            : AssetImage("images/pic1.png")),
                  ),
                  SizedBox(
                    height: 22.0,
                  ),
                  Text(
                    "${(data['weather'][0]['description'])},${(data['main']['temp'])} ℃",
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 4.0,
                    ),
                  ),
                  SizedBox(
                    height: 22.0,
                  ),
                  //Here you pass nect five day weather
                  customList("Tuesday", "28°", Icons.wb_sunny, "7 April 2020"),
                  customList(
                      "Wednesday", "31°", Icons.wb_sunny, "8 April 2020"),
                  customList("Thursday", "26°", Icons.wb_sunny, "9 April 2020"),
                  customList("Friday", "30°", Icons.wb_sunny, "10 April 2020"),
                  customList(
                      "Saturday", "33°", Icons.wb_sunny, "11 April 2020"),
                ],
              ),
      ),
    );
  }
}
