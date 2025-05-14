import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  static final LatLng companyLatLng = LatLng(37.5233273, 126.921525);
  static final Marker marker = Marker(
    markerId: MarkerId("company"),
    position: companyLatLng,
  );
  static final Circle circle = Circle(
    circleId: CircleId("choolCheckCircle"),
    center: companyLatLng,
    fillColor: Color(Colors.blue.toARGB32()).withAlpha(127),
    radius: 100,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == "위치 권한이 허용되었습니다.") {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: companyLatLng,
                      zoom: 16,
                    ),
                    markers: {marker},
                    circles: {circle},
                    myLocationEnabled: true,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timelapse_outlined,
                        size: 50.0,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          final curPosition =
                              await Geolocator.getCurrentPosition();
                          final distance = Geolocator.distanceBetween(
                            curPosition.latitude,
                            curPosition.longitude,
                            companyLatLng.latitude,
                            companyLatLng.longitude,
                          );

                          bool canCheck = distance < 100;

                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("출근하기"),
                                content: Text(
                                  canCheck
                                      ? "출근 체크를 하시겠습니까?"
                                      : "100m 이내에서만 출근 체크가 가능합니다.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(context);
                                    },
                                    child: Text("취소"),
                                  ),
                                  if (canCheck)
                                    TextButton(
                                      onPressed: () {
                                        // 출근 체크 로직 추가
                                        Navigator.of(context).pop(context);
                                      },
                                      child: Text("확인"),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("출근하기!"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Center(child: Text(snapshot.data.toString()));
        },
      ),
      appBar: renderAppBar(),
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        '오늘도 출첵',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return "위치 서비스를 활성화 해주세요.";
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return "위치 권한을 허용해주세요.";
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return "설정에서 위치 권한을 허용해주세요.";
    }

    return "위치 권한이 허용되었습니다.";
  }
}
