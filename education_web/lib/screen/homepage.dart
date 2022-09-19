import 'package:education_web/screen/javapoint.dart';
import 'package:education_web/screen/tutorialsPoint.dart';
import 'package:education_web/screen/w3Schools.dart';
import 'package:education_web/screen/wikipedia.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff202D58),
        title: const Text("Education"),
        centerTitle: true,
      ),
      body: Column(
        children: Global.data.map((e) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                setState(() {
                  Navigator.of(context).pushNamed("${e['page']}");
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: const Color(0xff202D58),
              textColor: Colors.white,
              title: Text("${e['name']}"),
            ),
          );
        }).toList(),
      ),
    );
  }
}
