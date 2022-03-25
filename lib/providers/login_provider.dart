
import 'dart:collection';

import 'package:firbase_auth_flutter/Api_services/api_service.dart';
import 'package:firbase_auth_flutter/constant/functions.dart';
import 'package:firbase_auth_flutter/models/Ip_model.dart';
import 'package:firbase_auth_flutter/screens/plugin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier{
  final DatabaseReference mRoot = FirebaseDatabase.instance.ref();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  FocusNode myFocusNode=FocusNode();


  bool showLoading=false;
  bool isOtp=false;

  String verificationId='';

  IpModel? ipModel;






  getOtp(String phoneNumber,BuildContext context) async {
    showLoading=true;
    isOtp=true;
    notifyListeners();

    await _auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 5),
      phoneNumber: "+91" + phoneController.text,
      verificationCompleted: (phoneAuthCredential) async {
          showLoading = false;
          notifyListeners();
      },
      verificationFailed: (verificationFailed) async {
          showLoading = false;
          notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    verificationFailed.message ?? "")));
      },
      codeSent: (verificationId, resendingToken) async {
          showLoading = false;
          notifyListeners();

          this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  Future<void> onLogin(String otp,BuildContext context) async {
    showLoading = true;
    notifyListeners();

    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
    notifyListeners();

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

        showLoading = false;
      notifyListeners();

      if (authCredential.user != null) {



        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
             "Success",
            style: TextStyle(color: Colors.white),
          ),
        ));
        LoginProvider loginProvider = Provider.of<LoginProvider>(context,listen: false);
        loginProvider.saveUserDetails(authCredential.user!);
        callNext(PluginScreen(uid:authCredential.user!.phoneNumber! ), context);
        // userAuthorized(phoneNumber);
      }
    } on FirebaseAuthException catch (e) {
        showLoading = false;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          e.message ?? "",
          style: const TextStyle(color: Colors.black),
        ),
      ));
    }
  }

  Future<void> saveUserDetails(User user) async {
    ipModel=await ApiService().getIp();
    HashMap<String, Object> dataMap = HashMap();
    dataMap['PhoneNumber']=user.phoneNumber.toString();
    if(ipModel!=null){
      dataMap['IpAddress']=ipModel!.query;
      dataMap['Location']=ipModel!.city;
    }
    dataMap['DateTime']=DateTime.now().millisecondsSinceEpoch.toString();

    mRoot.child('Users').child(user.phoneNumber!).update(dataMap);
    mRoot.child('LastLogin').child(user.phoneNumber!).set(DateTime.now().millisecondsSinceEpoch.toString());
  }

}
