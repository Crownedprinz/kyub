import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Kyub Global',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home:LoginPage(),
    );
  }
}


