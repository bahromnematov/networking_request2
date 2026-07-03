import 'package:flutter/material.dart';
import 'package:networking_request2/model/post_model.dart';
import 'package:networking_request2/service/networking_service.dart';

import 'model/albom_model.dart';
import 'model/comment_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<AlbomModel> items = [];

  _apiPostList() async {
    setState(() {
      isLoading = true;
    });
    var response = await NetworkingService.GET(
      NetworkingService.API_LIST,
      NetworkingService.paramsEmpty(),
    );
    if (response != null) {
      setState(() {
        isLoading = false;
      });
      items = NetworkingService.parsePostList(response);
    }
  }

  @override
  void initState() {
    super.initState();
    _apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post App"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: Text(
                    items[index].id.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  title: Text(
                    items[index].title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(items[index].userId.toString()),
                );
              },
            ),
    );
  }
}
