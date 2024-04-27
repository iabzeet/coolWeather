import 'package:coolweather/bloc/weather_bloc_bloc.dart';
import 'package:coolweather/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
              return BlocProvider<WeatherBlocBloc>(
                create: (context) => WeatherBlocBloc()..add(FetchWeather(snapshot.data as Position)),
                child: const HomePage(),
              );
          } else {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      "Processing..",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            );
          }
        },   
      ),
    );
  }
}

//determine te current position of the device 
//
//whent the location services are not enabled or permissions
//are denied the 'Future' will return an error
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  //test if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    //location services are not enabled dont continue
    //accessing the position and request users of the
    //app to enable the location services
    return Future.error("Location services are diabled");
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      //permission are denied, next time you could try 
      //requesting permissions again (this is also where
      //Adroid's shouldShowRequestPermissionRationale
      //returned true. According to Android guidelines
      //your App should show an explanatory UI now
      return Future.error("Location permissions are denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
