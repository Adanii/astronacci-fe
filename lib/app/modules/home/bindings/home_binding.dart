import 'package:astronacci_fe/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<HomeController>()) {
    } else {
      Get.lazyPut<HomeController>(() {
        return HomeController();
      }, fenix: true);
    }
  }
}
