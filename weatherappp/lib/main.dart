import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';
import 'LoginScreen.dart';

void main() => runApp(


  MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,

      fontFamily: 'Georgia',
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    ),
  ),
);


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late SharedPreferences sharedPreferences;
  bool isLoginCall = false;

  @override
  void initState() {
    super.initState();

    initView();
  }

  initView() async {

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    sharedPreferences = await SharedPreferences.getInstance();

    String isLogin = sharedPreferences.getString("isLogin").toString();
    if (isLogin != null && !isLogin.isEmpty) {

      if (isLogin== "1") {
        setState(() {
          isLoginCall = true;
        });
      } else {
        setState(() {
          isLoginCall = false;
        });
      }
    } else {
      setState(() {
        isLoginCall = false;
      });
    }
    Timer(
        Duration(seconds: 2),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
            isLoginCall ? HomeScreen() : LoginScreen())));

  }

  Color color1 =
  const Color(0x2C3980); // Second `const` is optional in assignments.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        child: Text("Weather",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Colors.amberAccent,
                            )),
                      ),

                    ],
                  ),
                  alignment: FractionalOffset.center,
                ),
              ),

            ],
          )),
    );
  }
}





