///Ahmet Emir Kalafat tarafından oluşturuldu.
///18.11.2022
///Birden fazla kronometre oluşturulabilen flutter uygulaması.

import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Bu widget uygulamanın köküdür.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Çoklu Kronometre Uygulaması',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
      ),
      home: const MyHomePage(title: 'MultiKronometre'),
    );
  }
}
