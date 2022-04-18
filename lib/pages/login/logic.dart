import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'state.dart';
import 'package:sp_util/sp_util.dart';

class LoginLogic extends GetxController {
  Rx<LoginState> state = LoginState(admin:'',checked: false, passwordVisible: false).obs;
  late TextEditingController passwordController;
  late TextEditingController adminController;

  @override
  void onInit(){
    passwordController = TextEditingController();
    adminController = TextEditingController();
    super.onInit();
  }
  @override
  void onClose() {
    passwordController.dispose();
    adminController.dispose();
    super.onClose();
  }
  void changeChecked(v){
    state.value.checked = v;
    state.refresh();
  }
  void passwordVisible(){
    state.value.passwordVisible = !state.value.passwordVisible;
    state.refresh();
  }
  void changeAdmin(v){
    state.value.admin = v;
  }
  void login(){
    SpUtil.putString('admin', state.value.admin);
    SpUtil.putString('userId', '123456');
    SpUtil.putBool("isLogin", true);
    Get.back(result:'123456');
  }
  // void changePassword(v){
  //   state.value.password = v;
  //   state.refresh();
  // }
}
