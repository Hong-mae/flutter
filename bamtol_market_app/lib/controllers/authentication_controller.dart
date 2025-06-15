import 'package:bamtol_market_app/consts/authentication_status.dart';
import 'package:bamtol_market_app/model/user_model.dart';
import 'package:bamtol_market_app/repository/authentication_repository.dart';
import 'package:bamtol_market_app/repository/user_repository.dart';
import 'package:bamtol_market_app/utls/logger.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  Rx<AuthenticationStatus> status = AuthenticationStatus.init.obs;
  Rx<UserModel> userModel = const UserModel().obs;

  AuthenticationController(
    this._authenticationRepository,
    this._userRepository,
  );

  void authCheck() async {
    logger.d("Auth Check");
    // await Future.delayed(const Duration(milliseconds: 1000));
    // isLogined.value = true;
    _authenticationRepository.user.listen((user) {
      _userStateChangedEvent(user);
    });
  }

  void logout() async {
    await _authenticationRepository.logout();
  }

  void _userStateChangedEvent(UserModel? user) async {
    if (user == null) {
      status(AuthenticationStatus.unknown);
    } else {
      var result = await _userRepository.findUserOne(user.uid!);

      if (result == null) {
        userModel.value = user;
        status(AuthenticationStatus.unAuthenticated);
      } else {
        status(AuthenticationStatus.authentication);
        userModel.value = result;
      }
    }
  }
}
