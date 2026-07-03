import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:networking_request2/library/library_model.dart';
import 'package:http/http.dart' as http;

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Doc> libararys = [];

  Future<List<Doc>> getApiLibrary() async {
    final response = await http.get(
      Uri.parse("https://openlibrary.org/search.json?q=flutter"),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['docs'];
      for (var a in data) {
        libararys.add(Doc.fromJson(a));
      }
      return libararys;
    }
    return libararys;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Doc>>(
        future: getApiLibrary(),
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
                  leading: Image.network(
                    width: 80,
                    fit: BoxFit.cover,
                    "https://covers.openlibrary.org/b/id/${data[index].coverI}-M.jpg",
                  ),
                  title: Text("${data[index].title}\n"),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[index].authorName != null &&
                                data[index].authorName!.isNotEmpty
                            ? data[index].authorName!.first
                            : "Author not found",
                      ),
                      Text("${data[index].firstPublishYear.toString()}\n"),
                    ],
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
