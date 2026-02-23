import 'package:get/get.dart';
import 'package:placementt/view_models/controller/details_controller/details_controller.dart';
import 'package:placementt/view_models/controller/home_controller/home_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {}
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsViewModel>(() => DetailsViewModel());
  }
}