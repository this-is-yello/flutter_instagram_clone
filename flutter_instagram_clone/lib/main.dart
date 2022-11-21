import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.blue),
          appBarTheme: AppBarTheme(
              color: Colors.grey,
              actionsIconTheme: IconThemeData(color: Colors.blue)),
          textTheme: TextTheme(bodyText2: TextStyle(color: Colors.red))),
      home: MyApp()));
}

var a = TextStyle();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [Icon(Icons.star)],
      ),
      body: Text(
        '안녕',
        style: a,
      ),
    );
  }
}
