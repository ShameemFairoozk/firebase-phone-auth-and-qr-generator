import 'package:firbase_auth_flutter/providers/home_provider.dart';
import 'package:firbase_auth_flutter/providers/login_provider.dart';
import 'package:firbase_auth_flutter/screens/last_login.dart';
import 'package:firbase_auth_flutter/screens/login_screen.dart';
import 'package:firbase_auth_flutter/screens/plugin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
  User? user=  FirebaseAuth.instance.currentUser;


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>LoginProvider()),
          ChangeNotifierProvider(create: (context)=>HomeProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:  user==null?LoginScreen():PluginScreen(uid: user!.phoneNumber!),
        ),
      );


  }
}


