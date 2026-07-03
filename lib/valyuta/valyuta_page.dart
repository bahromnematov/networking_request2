import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:networking_request2/valyuta/valyuta_model.dart';

class ValyutaPage extends StatefulWidget {
  const ValyutaPage({super.key});

  @override
  State<ValyutaPage> createState() => _ValyutaPageState();
}

class _ValyutaPageState extends State<ValyutaPage> {
  Future<List<ValyutaModel>> getValyutaApi() async {
    final response = await http.get(
      Uri.parse("https://cbu.uz/uz/arkhiv-kursov-valyut/json/"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data as List)
          .map((e) => ValyutaModel.fromJson(e))
          .toList();
    }

    throw Exception("Xatolik");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Valyuta Kursi"),
      ),
      body: FutureBuilder<List<ValyutaModel>>(
        future: getValyutaApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(data[index].ccyNmUz),
                  subtitle: Text(data[index].ccy),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(data[index].rate),
                        const SizedBox(width: 8),
                        Text(data[index].diff),
                      ],
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
