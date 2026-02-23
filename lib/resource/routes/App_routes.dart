import 'package:get/get.dart';
import 'package:placementt/resource/routes/routs.dart';
import 'package:placementt/view/Splash_screen/Splash_screen.dart';
import 'package:placementt/view/details_page/details_page.dart';
import 'package:placementt/view/home_page/home_Page.dart';
import '../../data/binding/App_binding.dart';

class AppRoutes {
  static List<GetPage> appRoutes() => [

    GetPage(
      name: AppRouteNames.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRouteNames.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: AppRouteNames.details,
      page: () => DetailsScreen(),
      binding: DetailsBinding(),
    ),
  ];
}