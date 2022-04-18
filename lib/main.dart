import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:f_1/pages/login/view.dart';
import 'package:f_1/pages/login/binding.dart';
import 'package:f_1/pages/home/view.dart';
import 'package:f_1/pages/home/binding.dart';
import 'package:f_1/pages/splash/view.dart';
import 'package:f_1/pages/detail/binding.dart';
import 'package:f_1/pages/detail/view.dart';
import 'package:sp_util/sp_util.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance?.resamplingEnabled = true;
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.red
  ));
  await SpUtil.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(
            name: '/splash',
            page:()=>SplashPage(),
        ),
        GetPage(
          name: '/login',
          page:()=>LoginPage(),
          binding: LoginBinding()
        ),
        GetPage(
            name: '/home',
            page:()=>HomePage(),
            binding: HomeBinding()
        ),
        GetPage(
            name: '/detail',
            page:()=>DetailPage(),
            binding: DetailBinding()
        )
      ],
    );
  }
}




