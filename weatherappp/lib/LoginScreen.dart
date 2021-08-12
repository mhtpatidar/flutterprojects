import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  late SharedPreferences sharedPreferences;

  String phoneNo = "";
  String smsOTP = "";
  String verificationId ="";
  String errorMessage = '';
  final _codeController = TextEditingController();



  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initView();
  }

  initView() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: new TextField(
                decoration: new InputDecoration(labelText: "Enter your number Eg. +910000000000'",
                    hintText: '+910000000000'),

                onChanged: (value) {
                  this.phoneNo = value;
                },
              ),

            ),
            (errorMessage != ''
                ? Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            )
                : Container()),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                verifyPhone();
              },
              child: Text('Verify'),
              textColor: Colors.white,
              elevation: 7,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }


  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int? forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context);
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
          smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      print(e.toString());
    }
  }

  Future smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  controller: _codeController,
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () async {
                  signIn();
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
    /*  final User user = (await _auth.signInWithCredential(credential)) as User;
      final User currentUser = await _auth.currentUser!;
      assert(user.uid == currentUser.uid);*/
      _auth.signInWithCredential(credential)
          .then((value) {
        if (value.user != null) {
          setState(() {
            //status = 'Authentication successful';
          });

          sharedPreferences.setString("isLogin", "1");
          sharedPreferences.setString("mobilenumber", phoneNo);
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => HomeScreen()
          ));
        } else {
          setState(() {
            //status = 'Invalid code/invalid authentication';
          });
        }
      });

    } catch (e) {
      // handleError(e);
    }
  }


  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message!;
        });

        break;
    }
  }
}