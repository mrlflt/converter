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
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
      ),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double euro, dolar;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

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
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                this.dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                this.euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                //Rthis.real = snapshot.data["results"]["currencies"]["BRL"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      buildTextField("Reais", "R\$ ", realController, _realChanged),
                      Divider(),
                      buildTextField("Dólar", "\$ ", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euro", "€ ", euroController, _euroChanged),
                    ],
                  ),
                );
              }
              break;
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label0, String prefix0, TextEditingController tec, Function f) {
  return TextField(
    controller: tec,
    decoration: InputDecoration(
      labelText: label0,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix0,
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(
      decimal: true,
      signed: false,
    ),
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  print(json.decode(response.body));
  return json.decode(response.body);
}
