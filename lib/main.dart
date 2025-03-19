import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/db_helper.dart';
import 'package:to_do_app/controllers/dbprovider.dart';
import 'package:to_do_app/views/home.dart';
import 'package:to_do_app/views/splash_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => DBProvider(dbRef: DbHelper.getInstance()),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showSplash = true;
  showSplashScreen() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showSplash = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    showSplashScreen();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: showSplash ? SplashScreen() : HomePage(),
    );
  }
}
