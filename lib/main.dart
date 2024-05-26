import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
   return MaterialApp(
     theme: ThemeData(
       //brightness: Brightness.dark,
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark)
     ),
     debugShowCheckedModeBanner: false,
     home: const HomePage(),
   );
  }
}
