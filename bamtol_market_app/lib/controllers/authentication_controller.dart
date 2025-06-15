import 'package:bamtol_market_app/utls/logger.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  RxBool isLogined = false.obs;

  void authCheck() async {
    logger.d("Auth Check");
    await Future.delayed(const Duration(milliseconds: 1000));
    isLogined.value = true;
  }

  void logout() {
    isLogined.value = false;
  }
}
