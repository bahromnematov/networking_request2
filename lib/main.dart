import 'package:flutter/material.dart';
import 'package:networking_request2/product/product_page.dart';

import 'crypto/crypto_page.dart';
import 'library/library_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: CryptoPage(),
    );
  }
}
