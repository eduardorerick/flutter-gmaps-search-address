import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_maps_search/maps_sample.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> controller =
        Completer<GoogleMapController>();

    onPressed() async {
      var addressValue = address.text;
      var apikey = dotenv.env['GEOCODEMAPS_API_KEY'];

      final response = await http.get(Uri.parse(
          'https://geocode.maps.co/search?q=$addressValue&api_key=$apikey'));
      if (response.statusCode == 200) {
        var location = jsonDecode(response.body)[0];
        CameraPosition newCameraPosition = CameraPosition(
          target: LatLng(
              double.parse(location["lat"]), double.parse(location["lon"])),
          zoom: 15.9000,
        );
        final GoogleMapController _controller = await controller.future;
        await _controller
            .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
      } else {
        throw Exception('Failed to load album');
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 500,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 50,
                                width: 300,
                                child: TextField(
                                  controller: address,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(0))),
                                    labelText: 'Procure um país aqui...',
                                  ),
                                )),
                            SizedBox(
                                height: 50,
                                width: 100,
                                child: FilledButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(00),
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(00),
                                              topRight: Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    onPressed: onPressed,
                                    child: const Text('Buscar')))
                          ]))
                ],
              ),
            )),
            SizedBox(
              height: 400,
              width: 400,
              child: MapSample(
                controller: controller,
              ),
            )
          ],
        ),
      ),
    );
  }
}
