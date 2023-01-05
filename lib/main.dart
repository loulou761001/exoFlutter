import 'dart:async';
import 'dart:convert';

import 'package:exo4/model/products.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'form.dart';




void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Magasin de montres en fl*tter 🤮'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
FutureOr<List<Product>> parseProducts(String message) {
  final parsed = jsonDecode(message).cast<Map<String, dynamic>>();
  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

class _MyHomePageState extends State<MyHomePage> {

  late Future<List<Product>> futureAllProducts;

  @override
  void initState() {
    super.initState();
    futureAllProducts = getWatches();
  }

  Future<List<Product>> getWatches() async {
    final result = await http.get(Uri.parse('https://my-json-server.typicode.com/AntoineBrevet/montresJson/montres/'));
    print(result);
    if (result.statusCode == 200) {
      return compute(parseProducts, result.body);
    } else {
      throw Exception('Failed to load album');
    }

  }

  void _pageTest(watch) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {

      return Scaffold(
          appBar: AppBar(
              title: Text(watch.title)
          ),
          body: Column(
              children: [
                Text(watch.price.toString()+'\$'),
                Text(watch.description),
              ]
          )
      );
    }));
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>const FormWidget())),
          child: const Icon(
              Icons.menu
          ),
        ),
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Product>>(
          future: futureAllProducts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => {
                      _pageTest(snapshot.data![index])
                    },
                    title: Text(snapshot.data![index].title),
                    subtitle: Row(
                      children: [
                        Text(snapshot.data![index].price.toString()+'\$'),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        )
      ),
    );
  }
}
