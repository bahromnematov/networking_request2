import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:networking_request2/crypto/crypto_model.dart';

import 'details_page.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  List<CryptoModel> cryptos = [];

  Future<List<CryptoModel>> getApiCryptos() async {
    final response = await http.get(
      Uri.parse(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1",
      ),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var a in data) {
        try {
          cryptos.add(CryptoModel.fromJson(a));
        } catch (e) {
          print("ERROR: $e");
          print(a);
        }
      }
      return cryptos;
    }
    return cryptos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CryptoModel>>(
        future: getApiCryptos(),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return DetailsPage(
                            name: data[index].name ?? "",
                            imageurl: data[index].image ?? "",
                            price: data[index].currentPrice!
                                .toStringAsFixed(1)
                                .toString(),
                            id: data[index].id ?? "",
                          );
                        },
                      ),
                    );
                  },
                  leading: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(cryptos[index].image ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(cryptos[index].name ?? ""),
                  subtitle: Text(cryptos[index].symbol ?? ""),
                  trailing: Text(
                    "\$${data[index].currentPrice?.toStringAsFixed(2)}",
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
