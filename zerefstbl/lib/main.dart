// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String textResults = "Informe seu peso e altura!";

  String? errorText;

  void resetFields() {
    weightController.clear();
    heightController.clear();
    setState(() {
      errorText = null;
      textResults = 'Informe seu peso e altura!!';
    });
  }

  void imcCalculator () {
    setState(() {
      if (weightController.text.isEmpty | heightController.text.isEmpty) {
        errorText = 'Os dois campos são obrigatórios!';
        return;
      }

      errorText = null;
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      if(imc < 18.6) {
        textResults = "Abaixo do peso (${imc.toStringAsPrecision(3)})";
      } else {
        textResults = "Seu imc é de (${imc.toStringAsPrecision(3)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        centerTitle: true,
        backgroundColor: Color(0xff00d7f3),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              resetFields();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.person_outline, size: 140, color: Color(0xff00d7f3)),
            TextField(keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Peso em KG",
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
                controller: weightController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Altura (cm)",
                errorText: errorText,
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
              controller: heightController,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: imcCalculator,
                child: Text('Calcular', style: TextStyle(fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff00d7f3),
                ),
              ),
            ),
            Text(textResults, style: TextStyle(
              color: Color(0xff00d7f3),
            ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}