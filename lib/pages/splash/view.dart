import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _timer;
  int _time = 0;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _time += 100;
      if (_time >= 3000) {
        _timer.cancel();
        Get.offNamed('/home');
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children: [
        FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 1,
          child: Image.asset('assets/ad.webp', fit: BoxFit.cover),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: CircularProgressIndicator(
            value: _time / 3000,
          )),
        Positioned(
          top: 40,
          right: 26,
          child: GestureDetector(
            onTap: (){
              Get.offNamed('/home');
            },
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '跳过',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                    '${(3 - _time / 1000).ceil()}秒',
                    style: const TextStyle(fontSize: 12)
                )
              ],
            ),
          )
        )
      ],
    ));
  }
}
