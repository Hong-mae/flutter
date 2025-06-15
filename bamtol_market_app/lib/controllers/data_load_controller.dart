import 'package:bamtol_market_app/utls/logger.dart';
import 'package:get/get.dart';

class DataLoadController extends GetxController {
  RxBool isDataLoad = false.obs;

  void loadData() async {
    logger.d("Data Load");
    await Future.delayed(const Duration(milliseconds: 2000));
    isDataLoad.value = true;
  }
}
