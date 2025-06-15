import 'package:bamtol_market_app/components/app_font.dart';
import 'package:bamtol_market_app/controller/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Get.width * 0.6,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            children: [
              const AppFont(
                text: '아라동',
                fontWeight: FontWeight.bold,
                size: 20,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              SvgPicture.asset("assets/svg/icons/bottom_arrow.svg"),
            ],
          ),
        ),
        actions: [
          SvgPicture.asset('assets/svg/icons/search.svg'),
          const SizedBox(width: 15),
          SvgPicture.asset('assets/svg/icons/list.svg'),
          const SizedBox(width: 15),
          SvgPicture.asset('assets/svg/icons/bell.svg'),
          const SizedBox(width: 15),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Get.find<AuthenticationController>().logout();
          },
          child: const AppFont(text: 'Home'),
        ),
      ),
    );
  }
}
