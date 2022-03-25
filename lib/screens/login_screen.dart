import 'package:firbase_auth_flutter/constant/colors.dart';
import 'package:firbase_auth_flutter/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
  final _formKey= GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var width = queryData.size.width;
    LoginProvider loginProvider=Provider.of<LoginProvider>(context,listen: false);
    return Scaffold(
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
              decoration:  BoxDecoration(
              color: blueLight,
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(80),bottomLeft: Radius.circular(120))),),
          ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            margin: const EdgeInsets.only(top: 70),

            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Phone Number',style: TextStyle(color: white,fontSize: 16),),
                  Consumer<LoginProvider>(
                      builder: (context,value,child)  {
                      return TextFormField(

                        style:  TextStyle(color: white),
                        decoration:  InputDecoration(
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                            fillColor: blue,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                            )

                        ),
                        controller: value.phoneController,
                        onChanged: (txt){
                          if(txt.length==10){
                            value.myFocusNode.requestFocus();
                            loginProvider.getOtp(txt, context);
                          }
                        },
                        validator: (text){
                          if(text==null||text.isEmpty||text.length!=10){
                            return 'Invalid Phone Number';
                          }else{
                            return null;
                          }
                        },
                      );
                    }
                  ),
                  const SizedBox(height: 30,),
                   Text('OTP',style: TextStyle(color: white,fontSize: 16),),

                  Consumer<LoginProvider>(
                      builder: (context,value,child)   {
                      return TextFormField(
                        controller: value.otpController,
                        focusNode: value.myFocusNode,
                        style:  TextStyle(color: white),
                        decoration:  InputDecoration(
                          filled: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                          fillColor: blue,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)
                          )

                        ),
                        onChanged: (pin) {
                          if (pin.length == 6) {
                            loginProvider.onLogin(pin,context);

                          }
                        },
                        validator: (text){
                          if(text==null||text.isEmpty||text.length!=6){
                            return 'Invalid OTP';
                          }else{
                            return null;
                          }
                        },
                      );
                    }
                  ),
                  const SizedBox(height: 60,),

                  Consumer<LoginProvider>(
                      builder: (context,value,child) {
                      return TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(gray),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ))),
                          onPressed: (){

                        var form=_formKey.currentState;
                        if(form!.validate()){
                          if(!value.showLoading&&value.isOtp){
                            loginProvider.onLogin(value.otpController.text,context);
                          }
                        }

                      }, child: SizedBox(
                          width: double.maxFinite,
                          height: 30,

                          child: Center(child: value.showLoading?const CircularProgressIndicator():Text(value.isOtp?'LOGIN':'OTP',style: TextStyle(fontSize: 16,color: white),))));
                    }
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 55,
            right: width/2-50,
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: skyBlue,
                borderRadius: BorderRadius.circular(5)
              ),
              alignment: Alignment.center,
              child:  Text('LOGIN',style: TextStyle(fontSize: 18,color: white),),
            ),
          )
        ],
      ),
    );
  }
}
