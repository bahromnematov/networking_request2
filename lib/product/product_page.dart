import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:networking_request2/product/product_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<ProductModel> products = [];

  Future<List<ProductModel>> getApiProducts() async {
    final response = await http.get(
      Uri.parse("https://fakestoreapi.com/products"),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var a in data) {
        products.add(ProductModel.fromJson(a));
      }
      return products;
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: FutureBuilder<List<ProductModel>>(
        future: getApiProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Image.network(data[index].image),
                  title: Text(
                    data[index].title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(data[index].description),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(data[index].price.toString())],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
