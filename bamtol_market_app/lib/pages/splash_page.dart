import 'package:bamtol_market_app/components/app_font.dart';
import 'package:bamtol_market_app/components/getx_listener.dart';
import 'package:bamtol_market_app/consts/authentication_status.dart';
import 'package:bamtol_market_app/consts/step_type.dart';
import 'package:bamtol_market_app/controllers/authentication_controller.dart';
import 'package:bamtol_market_app/controllers/data_load_controller.dart';
import 'package:bamtol_market_app/controllers/splash_controller.dart';
import 'package:bamtol_market_app/utls/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetxListener<AuthenticationStatus>(
          listen: (AuthenticationStatus status) {
            logger.d("status: $status");
            switch (status) {
              case AuthenticationStatus.authentication:
                Get.offNamed("/home");
                break;
              case AuthenticationStatus.unAuthenticated:
                var userModel =
                    Get.find<AuthenticationController>().userModel.value;
                Get.offNamed("/signup/${userModel.uid}");
                break;
              case AuthenticationStatus.unknown:
                Get.offNamed("/login");
                break;
              case AuthenticationStatus.init:
                break;
            }
          },
          stream: Get.find<AuthenticationController>().status,
          child: GetxListener<bool>(
            listen: (bool value) {
              if (value) {
                controller.loadStep(StepType.dataLoad);
              }
            },
            stream: Get.find<DataLoadController>().isDataLoad,
            child: GetxListener<StepType>(
              initCall: () {
                controller.loadStep(StepType.dataLoad);
              },
              listen: (StepType value) {
                switch (value) {
                  case StepType.init:
                  case StepType.dataLoad:
                    Get.find<DataLoadController>().loadData();
                    break;
                  case StepType.authCheck:
                    Get.find<AuthenticationController>().authCheck();
                    break;
                }
              },
              stream: controller.loadStep,
              child: const _SplashView(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashView extends GetView<SplashController> {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 200),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                width: 99,
                height: 116,
                child: Image.asset('assets/images/logo_simbol.png'),
              ),
              const SizedBox(height: 40),
              const AppFont(
                '당신 근처의 밤톨마켓',
                fontWeight: FontWeight.bold,
                size: 20,
              ),
              const SizedBox(height: 15),
              AppFont(
                '중고 거래부터 동네 정보까지\n지금 내 동네를 선택하고 시작해보세요!',
                align: TextAlign.center,
                size: 18,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Column(
            children: [
              Obx(
                () => Text(
                  '${controller.loadStep.value.label}중 입니다.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
