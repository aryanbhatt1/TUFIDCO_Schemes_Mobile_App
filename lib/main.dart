import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/platform_interface.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'backevent_notifier.dart';
import 'package:flutter/services.dart';
import 'webview.dart';


void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => BackEventNotifier(),
        child:  MyApp(),
      ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      const Duration(seconds: 2), ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Webpage())),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      child: Center(


        child:Column(

          children: [
            const SizedBox(height: 200),
            const Padding(padding: EdgeInsets.only(bottom:50,)),
            Image.asset(
                'assets/logo.png',
                width: 300,
                height: 150,
            ),
            const Padding(padding: EdgeInsets.only(bottom:50,)),
            const Text("Tamil Nadu Urban Finance And Infrastructure Development Corporation LTD",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(20, 95, 142, 1),
                  decoration: TextDecoration.none,
              ),
            ),
          ],
        ),

      ),

    );
  }
}
