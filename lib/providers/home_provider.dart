
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firbase_auth_flutter/models/last_login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class HomeProvider extends ChangeNotifier{
  final DatabaseReference mRoot = FirebaseDatabase.instance.ref();
  firebase_storage.Reference ref = FirebaseStorage.instance.ref("QrCodes");
  ScreenshotController screenshotController = ScreenshotController();


  String randomNumber='';
  String userIp='';
  String selectedDay='Today';
  String lastLoginTime='';

   List<LastLoginModel> lastLoginList=[];
   List<LastLoginModel> filterLastLoginList=[];


  HomeProvider(){
    getRandomDigit();
    getUsers();
    getLastUser();
  }

  void getRandomDigit() {
    randomNumber=Random().nextInt(99999).toString().padLeft(5, '0');
    notifyListeners();
  }
  onSave(String uid,BuildContext context) async {
    showLoaderDialog(context);
    HashMap<String ,Object> dataMap=HashMap();
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    ref = firebase_storage.FirebaseStorage.instance.ref().child(time);
    await screenshotController
        .captureFromWidget(
        QrImage(
          data: randomNumber,
          version: QrVersions.auto,
          size: 150,
          gapless: false,

        )
    )
        .then((Uint8List? image) async {
      if (image != null) {
        final tempDir = await getTemporaryDirectory();
        File file = await File('${tempDir.path}/image.png').create();
        file.writeAsBytesSync(image);

        await ref.putFile(file).whenComplete(() async {
          await ref.getDownloadURL().then((value) {
            dataMap['QRImage'] = value;
            dataMap['QRCode'] = randomNumber;
            mRoot.child('Users').child(uid).update(dataMap);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Success",
                style: TextStyle(color: Colors.white),
              ),
            ));
          });
        });

      }
    });


  }

  void onSelectDay(String s) {
    selectedDay=s;
    notifyListeners();

    if(s=='Today'){

      filterLastLoginList = lastLoginList
          .where((element) => element.time!=''&&daysBetween(DateTime.now(), DateTime.fromMillisecondsSinceEpoch(int.parse(element.time)))==0)
          .toList();
      notifyListeners();
    }else if(s=='Yesterday'){
      filterLastLoginList = lastLoginList
          .where((element) => element.time!=''&&daysBetween(DateTime.now(), DateTime.fromMillisecondsSinceEpoch(int.parse(element.time)))==-1)
          .toList();
      notifyListeners();
    }else{
      filterLastLoginList=lastLoginList
          .where((element) => element.time==''||daysBetween(DateTime.now(), DateTime.fromMillisecondsSinceEpoch(int.parse(element.time)))<-1)
          .toList();
      notifyListeners();

    }

    notifyListeners();
  }

  getUsers(){
    mRoot.child('Users').onValue.listen((event) {
      lastLoginList.clear();
      if(event.snapshot.exists){
        Map<dynamic,dynamic> map =event.snapshot.value as Map;
        map.forEach((key, value) {
          lastLoginList.add(LastLoginModel(value['PhoneNumber']??'', value['Location']??'', value['IpAddress']??'',  value['DateTime']??'', value['QRCode']??'', value['QRImage']??''));
          notifyListeners();
        });
      }
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void getLastUser() {
    mRoot.child('LastLogin').onValue.listen((event) {
      if(event.snapshot.exists){
        Map<dynamic,dynamic> map =event.snapshot.value as Map;
        lastLoginTime= '${getDate(map.values.last)}';
        notifyListeners();
      }else{
        lastLoginTime='Not Available';
        notifyListeners();
      }


    });
  }

  getDate(String millis) {
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(millis));
    var today=DateTime.now();
    var diff=daysBetween(today,dt);
    var day='';
    if(diff==0){
      day ='Today, ${DateFormat('hh:mm a').format(dt)}';
    }else if(diff==-1){
      day ='Yesterday, ${DateFormat('hh:mm a').format(dt)}';
    }else{
      day =DateFormat('dd/MM/yyyy hh:mm a').format(dt);

    }
    return day;
  }
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 7),child:const Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}
