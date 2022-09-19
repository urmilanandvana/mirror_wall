import 'package:flutter/material.dart';
import 'package:ott_platforms/screen/amazon.dart';
import 'package:ott_platforms/screen/disney.dart';
import 'package:ott_platforms/screen/homepage.dart';
import 'package:ott_platforms/screen/hotstar.dart';
import 'package:ott_platforms/screen/netflix.dart';
import 'package:ott_platforms/screen/sony_liv.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
        'netflix_page': (context) => const NetflixPage(),
        'amazon_page': (context) => const AmazonPage(),
        'disney_page': (context) => const DisneyPage(),
        'sony_liv_page': (context) => const SonyLivPage(),
        'hotstar_Page': (context) => const HotstarPage(),
      },
    ),
  );
}
