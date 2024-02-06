import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:climate_flutter/services/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const apiKey = 'a0e60a27635cf6bb429d145003996f75';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late double latitude;
  late double longitude;

  void determinePosition() async {
    Location location = Location();
    await location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;
    print(longitude);
    print(latitude);

    var weatherData = await getData();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocationScreen(
            locationData: weatherData,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    determinePosition();
  }

  // void loadPosition() {
  //   determinePosition();
  // }

  String metric = 'metric';
  Future<String> getData() async {
    var url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'appid': apiKey,
      'units': metric
    });
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var data = response.body;

      // var temperature = jsonDecode(data)['main']['temp'];
      // var condition = jsonDecode(data)['weather'][0]['id'];
      // var cityName = jsonDecode(data)['name'];
      //
      // print(temperature);
      // print(condition);
      // print(cityName);

      return data;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SpinKitDoubleBounce(
        color: Colors.white,
        size: 100.0,
      )),
    );
  }
}
