import 'package:bamtol_market_app/repository/authentication_repository.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthenticationRepository authenticationRepository;

  LoginController(this.authenticationRepository);

  void gLogin() async {
    await authenticationRepository.signInWithGoogle();
  }

  void aLogin() async {
    await authenticationRepository.signInWithApple();
  }
}
