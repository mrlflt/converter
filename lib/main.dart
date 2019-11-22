import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=c8cff307";

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$Converter\$"),
        centerTitle: false,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Data loading...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.9,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
                break;
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error to load data :(",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0,
                      ),
                    ),
                  );
                } else {
                  return Container(color: Colors.green,);
                }
                break;
            }
          }),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  print(json.decode(response.body));
}
