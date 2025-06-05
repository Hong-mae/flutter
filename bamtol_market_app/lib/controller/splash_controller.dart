import 'package:bamtol_market_app/const/step_type.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Rx<StepType> loadStep = StepType.dataLoad.obs;

  changeStep(StepType type) {
    loadStep(type);
  }
}
