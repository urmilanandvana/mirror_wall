import 'package:education_web/screen/homepage.dart';
import 'package:education_web/screen/javapoint.dart';
import 'package:education_web/screen/tutorialsPoint.dart';
import 'package:education_web/screen/w3Schools.dart';
import 'package:education_web/screen/wikipedia.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
        'wikipedia_page': (context) => const WikipediaPage(),
        'w3Schools_page': (context) => const W3SchoolsPage(),
        'javPoint_page': (context) => const JavaPointPAge(),
        'tutorialsPoint_page': (context) => const TutorialsPointPage(),
      },
    ),
  );
}
