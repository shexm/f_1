import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'logic.dart';
import 'package:f_1/widgets/LoginButton/view.dart';
import 'package:f_1/pages/home/view.dart';

class LoginPage extends GetView<LoginLogic> {
  final _url = 'https://www.baidu.com';
  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.0, 1.0],
                  colors: <Color>[
                    Color.fromRGBO(170, 207, 211, 1.0),
                    Color.fromRGBO(93, 142, 155, 1.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: devicePadding.top + 50.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Image.network(
                      'https://www.baidu.com/img/flexible/logo/pc/result.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: TextFormField(
                                onEditingComplete: () {
                                  controller.changeAdmin(controller.passwordController.text);
                                  FocusScope.of(context).nextFocus();
                                },
                                decoration: const InputDecoration(
                                  hintText: '账户是admin',
                                  labelText: '账户',
                                ),
                                controller: controller.adminController,
                                obscureText: false,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Obx(()=>TextFormField(
                                // onEditingComplete: (){
                                //
                                // },
                                decoration:  InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: (){
                                      controller.passwordVisible();
                                    },
                                    child:  !controller.state.value.passwordVisible ? const Icon(Icons.visibility) : const Icon(Icons.password),
                                  ),
                                  hintText: '密码是1234',
                                  labelText: '密码',
                                ),
                                controller: controller.passwordController,
                                obscureText: !controller.state.value.passwordVisible,
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Transform(transform: Matrix4.translationValues(-20, 0, 0),child: Row(
                                children: [
                                  Obx(()=>Checkbox(
                                      value: controller.state.value.checked,
                                      onChanged: (v){
                                        controller.changeChecked(v);
                                      }
                                  )),
                                  GestureDetector(
                                    onTap: () async {
                                      if (!await launch(_url)) throw 'Could not launch $_url';
                                    },
                                    child: const Text('同意《xxxx》协议',style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                    ),),
                                  )
                                ],
                              ))
                            ),
                            LoginButton(
                              child: const Text("登录",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if(controller.passwordController.text == '1234' && controller.adminController.text == 'admin' && controller.state.value.checked){
                                  controller.login();
                                  controller.passwordController.clear();
                                  controller.adminController.clear();
                                  controller.changeChecked(false);
                                } else {
                                  Get.showSnackbar(const GetSnackBar(duration: Duration(milliseconds: 3000), message: '登录失败',));
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
