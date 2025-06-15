import 'package:bamtol_market_app/consts/step_type.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Rx<StepType> loadStep = StepType.dataLoad.obs;

  void changeStep(StepType type) {
    loadStep.value = type;
  }
}
