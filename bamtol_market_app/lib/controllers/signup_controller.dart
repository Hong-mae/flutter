import 'package:bamtol_market_app/model/user_model.dart';
import 'package:bamtol_market_app/repository/user_repository.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final UserRepository _userRepository;
  final uid;

  SignupController(this._userRepository, this.uid);

  RxString userNickName = ''.obs;
  RxBool isPossibleUseNickName = false.obs;

  @override
  void onInit() {
    super.onInit();
    debounce(
      userNickName,
      (callback) {},
      time: const Duration(milliseconds: 500),
    );
  }

  void checkDuplicationNickName(String value) async {
    var isPossibleUse = await _userRepository.checkDuplicationNickName(value);
    isPossibleUseNickName.value = isPossibleUse;
  }

  void changeNickName(String nickName) {
    userNickName.value = nickName;
  }

  Future<String?> signup() async {
    var newUser = UserModel.create(userNickName.value, uid);
    var result = await _userRepository.signup(newUser);

    return result;
  }
}
