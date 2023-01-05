import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/Products.dart';



class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();



  Future<Product> createProduct(String title, String description, int price) async {
    if(_controllerName.text.isNotEmpty&&_controllerDesc.text.isNotEmpty&&_controllerPrice.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse('https://my-json-server.typicode.com/AntoineBrevet/montresJson/montres'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title, 'description': description, 'price': price
        }),
      );

      if (response.statusCode == 201) {
        print('succes');
        return Product.fromJson(jsonDecode(response.body));
      } else {
        print(response.statusCode);
        throw Exception('Failed to create Product.');
      }
    }else {
      throw Exception('Empty field.');
    }

  }


  Future<Product>? _futureProduct;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'formulaire',
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('form'),
        ),
        body: buildColumn(),
      ),
    );
  }

  Column buildColumn(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controllerName,
          decoration: const InputDecoration(hintText: 'Entre un titre'),
        ),
        TextField(
          controller: _controllerDesc,
          decoration: const InputDecoration(hintText: 'Entre une desc'),
        ),
        TextField(
          keyboardType: TextInputType.number,
          controller: _controllerPrice,
          decoration: const InputDecoration(hintText: 'Entre un prix'),
        ),
        ElevatedButton(onPressed: () => {
          print(_controllerName.text),
          setState(() {
            _futureProduct = createProduct(_controllerName.text, _controllerDesc.text,int.parse(_controllerPrice.text));
          })
        }, child: const Text('cree un Product'))
      ],
    );
  }
}
