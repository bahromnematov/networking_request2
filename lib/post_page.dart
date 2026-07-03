import 'package:flutter/material.dart';
import 'package:networking_request2/model/post_model.dart';
import 'package:networking_request2/service/networking_service.dart';
import 'package:networking_request2/service/networking_service_post.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isLoading = false;
  List<PostModel> items = [];

  _apiPostList() async {
    setState(() {
      isLoading = true;
    });
    var response = await NetworkingService.GET(
      NetworkingServicePosts.API_LIST,
      NetworkingServicePosts.paramsEmpty(),
    );
    if (response != null) {
      setState(() {
        isLoading = false;
      });
      items = NetworkingServicePosts.parsePostList(response);
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
      appBar: AppBar(title: Text("Post App")),
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
                  subtitle: Text(items[index].body),
                );
              },
            ),
    );
  }
}
