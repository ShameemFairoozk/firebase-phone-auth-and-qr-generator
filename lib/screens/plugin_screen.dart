import 'package:firbase_auth_flutter/constant/functions.dart';
import 'package:firbase_auth_flutter/providers/home_provider.dart';
import 'package:firbase_auth_flutter/screens/last_login.dart';
import 'package:firbase_auth_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constant/colors.dart';

class PluginScreen extends StatelessWidget {
  String uid;
   PluginScreen({Key? key,required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider=Provider.of<HomeProvider>(context,listen: false);

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var width = queryData.size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            color: blue,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 70,
                width: 110,
                decoration: BoxDecoration(
                    color: blueLight,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(80),
                        bottomLeft: Radius.circular(120))),
                child: TextButton(
                  onPressed: (){
                    homeProvider.signOut();
                    callNext(LoginScreen(), context);
                  },
                  child:  Text('Logout',style: TextStyle(color: white,fontSize: 16,fontWeight: FontWeight.normal),),
                ),
              ),
            ),
          ),
          Container(

            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            margin: const EdgeInsets.only(top: 70),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width,
                  height: 180,
                  margin: const EdgeInsets.only(top: 180,right: 30,left:30),
                  decoration: BoxDecoration(
                      color: grayDark,
                  ),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size:  Size(300,( 180).toDouble()),
                        painter: CustomContainerShapeBorder(),

                      ),
                      Column(

                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Center(child: Text("Generated number",style: TextStyle(color: white,fontSize: 18),)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Center(child: Consumer<HomeProvider>(
                              builder: (context,value,child) {
                                return Text(value.randomNumber,style: TextStyle(color: white,fontSize: 40),);
                              }
                            )),
                          ),

                        ],
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextButton(
                      style: ButtonStyle(
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: white)
                              ))
                      ),
                      onPressed: () {
                        homeProvider.onSelectDay('Today');
                        callNext(const LastLogin(), context);
                      },
                      child: SizedBox(
                          width: double.maxFinite,
                          height: 40,

                          child: Center(
                              child: Consumer<HomeProvider>(
                                builder: (context,value,child) {
                                  return Text(
                                    'Last Login ${value.lastLoginTime}',
                                    style: TextStyle(fontSize: 16, color: white),
                                  );
                                }
                              )))),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(gray),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                      onPressed: () {
                        homeProvider.onSave(uid,context);
                      },
                      child: SizedBox(
                          width: double.maxFinite,
                          height: 40,

                          child: Center(
                              child: Text(
                                'SAVE',
                                style: TextStyle(fontSize: 16, color: white),
                              )))),
                ),

              ],
            ),
          ),
          Positioned(
            top: 140,
            right: width / 2 - 75,

            child: Container(

              child: Consumer<HomeProvider>(
                builder: (context,value,child) {
                  return QrImage(
                    data: value.randomNumber,
                    version: QrVersions.auto,
                    size: 150,
                    gapless: false,
                  );
                }
              ),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
          ),
          Positioned(
            top: 55,
            right: width / 2 - 50,
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                  color: skyBlue, borderRadius: BorderRadius.circular(5)),
              alignment: Alignment.center,
              child: Text(
                'PLUGIN',
                style: TextStyle(fontSize: 18, color: white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
class CustomContainerShapeBorder extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color =  blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;


    Path path0 = Path();
    path0.lineTo(size.width*1,size.height*1);
    path0.lineTo(size.width,0);
    path0.close();

    canvas.drawPath(path0, paint0);



  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
