import 'package:firbase_auth_flutter/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/colors.dart';
import '../constant/functions.dart';
import 'login_screen.dart';
class LastLogin extends StatelessWidget {
  const LastLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var width = queryData.size.width;
    HomeProvider homeProvider=Provider.of<HomeProvider>(context,listen: false);
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
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(80),bottomLeft: Radius.circular(120))),
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
            width: double.maxFinite,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            margin: const EdgeInsets.only(top: 70),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,30,0,10),
                  child: Row(
                    children: [
                      SizedBox(

                        child: Consumer<HomeProvider>(
                          builder: (context,value,child) {
                            return Column(
                              children: [
                                InkWell(
                                    child: Text('TODAY',style: TextStyle(color: white,fontSize:12 ),),
                                onTap: (){homeProvider.onSelectDay('Today');},
                                ),
                                value.selectedDay=='Today'?Divider(thickness: 5,color: white):const SizedBox()
                              ],
                            );
                          }
                        ),
                        width: 40,
                      ),
                      const SizedBox(width: 30,),
                      SizedBox(

                        child: Consumer<HomeProvider>(
                            builder: (context,value,child){
                            return Column(
                              children: [
                                InkWell(
                                    onTap: (){homeProvider.onSelectDay('Yesterday');},

                                    child: Text('Yesterday',style: TextStyle(color: white,fontSize:12 ),)),
                                value.selectedDay=='Yesterday'?Divider(thickness: 5,color: white):const SizedBox()
                              ],
                            );
                          }
                        ),
                        width: 60,
                      ),
                      const SizedBox(width: 30,),

                      SizedBox(

                        child: Consumer<HomeProvider>(
                            builder: (context,value,child){
                            return Column(
                              children: [
                                InkWell(
                                    onTap: (){homeProvider.onSelectDay('Other');},

                                    child: Text('Other',style: TextStyle(color: white,fontSize:12 ),)),
                                value.selectedDay=='Other'?Divider(thickness: 5,color: white):const SizedBox()
                              ],
                            );
                          }
                        ),
                        width: 40,
                      ),

                    ],
                  ),

                ),
                Consumer<HomeProvider>(
                  builder: (context,value,child) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: value.filterLastLoginList.length,
                        itemBuilder:
                            (BuildContext context, int index) {
                          var item = value.filterLastLoginList[index];
                          return InkWell(
                            onTap: () {

                            },
                            child: Card(
                              elevation: 1,
                              color: grayDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(homeProvider.getDate(item.time),style: TextStyle(color: white),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(item.ip,style: TextStyle(color: white),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(item.location,style: TextStyle(color: white),),
                                        ),                                ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: item.qrCodeImage!=''?Container(
                                      color: white,
                                        child: Image.network(item.qrCodeImage,height: 70,width: 70,)):const SizedBox(),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                )
              ],
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
              child:  Text('Last Login',style: TextStyle(fontSize: 18,color: white),),
            ),
          )
        ],
      ),
    );
  }

}
