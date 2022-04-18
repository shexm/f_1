import 'package:f_1/pages/login/logic.dart';
import 'package:get/get.dart';

import 'logic.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailLogic(Get.parameters['id']));
  }
}
