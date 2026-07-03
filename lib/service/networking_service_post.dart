import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:networking_request2/model/albom_model.dart';
import 'package:networking_request2/model/comment_model.dart';
import 'package:networking_request2/model/post_model.dart';

class NetworkingServicePosts {
  static String BASE = "jsonplaceholder.typicode.com";

  static Map<String, String> headers = {
    'Content-type': 'application/json; charset=UTF-8',
  };

  //endpoint

  static String API_LIST = "/posts"; //get
  static String API_CREATE = "/posts"; //post
  static String API_UPDATE = "/posts/"; //update
  static String API_DELETE = "/posts/"; //delete

  //http functions request

  static Future<String> GET(String api, Map<String, String> params) async {
    var uri = Uri.https(BASE, api, params);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Urlda xatolik bor";
    }
  }

  static Future<String> POST(String api, Map<String, String> params) async {
    var uri = Uri.https(BASE, api);
    var response = await http.post(
      uri,
      body: jsonEncode(params),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      return "Apida xatolik bor";
    }
  }

  static Future<String> PUT(String api, Map<String, String> params) async {
    var uri = Uri.https(BASE, api);
    var response = await http.put(
      uri,
      body: jsonEncode(params),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Apida xatolik bor";
    }
  }

  static Future<String> DELETE(String api, Map<String, String> params) async {
    var uri = Uri.https(BASE, api);
    var response = await http.delete(uri, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Apida xatolik bor";
    }
  }

  //params

  static Map<String, String> paramsEmpty() {
    Map<String, String> params = Map();
    return params;
  }

  static Map<String, String> paramsCreate(PostModel post) {
    Map<String, String> params = Map();
    params.addAll({
      "title": post.title,
      "body": post.body,
      "userId": post.userId.toString(),
    });
    return params;
  }

  static Map<String, String> paramsUpdate(PostModel post) {
    Map<String, String> params = Map();
    params.addAll({
      "title": post.title,
      "body": post.body,
      "userId": post.userId.toString(),
      "id": post.id.toString(),
    });
    return params;
  }

  static List<PostModel> parsePostList(String response) {
    dynamic json = jsonDecode(response);
    var data = List<PostModel>.from(json.map((x) => PostModel.fromJson(x)));
    return data;
  }
}
