import 'package:bamtol_market_app/const/authentication_status.dart';
import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:bamtol_market_app/src/user/repository/authentication_repository.dart';
import 'package:bamtol_market_app/src/user/repository/user_repository.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  AuthenticationController(
    this._authenticationRepository,
    this._userRepository,
  );

  RxBool isLogined = false.obs;
  Rx<AuthenticationStatus> status = AuthenticationStatus.init.obs;
  Rx<UserModel> userModel = const UserModel().obs;

  void authCheck() async {
    _authenticationRepository.user.listen((user) {
      _userStateChangeEvent(user);
    });
  }

  void _userStateChangeEvent(UserModel? user) async {
    if (user == null) {
      status(AuthenticationStatus.unknown);
    } else {
      var result = await _userRepository.findUserOne(user.uid!);

      if(result == null) {
        userModel(user);
        status(AuthenticationStatus.unAuthenticated);
      } else {
        status(AuthenticationStatus.authentication);
        userModel(result);
      }
    }
  }

  void logout() {
    isLogined(false);
  }
}
