import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Image.asset('assets/img/logo.png'),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => onGoogleLogin(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: SECONDARY_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text("구글로 로그인"),
            ),
          ],
        ),
      ),
    );
  }
}

onGoogleLogin(BuildContext context) async {
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId:
        '561040616522-cftn74r7941hpkt7g1ksvc5lm9n74i35.apps.googleusercontent.com',
    serverClientId:
        '561040616522-t0ras4qhib8ebt35j7rbt2b3hkk9gble.apps.googleusercontent.com',
  );

  try {
    GoogleSignInAccount? account = await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await account?.authentication;

    // final credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth?.accessToken,
    //   idToken: googleAuth?.idToken,
    // );
    //
    // await FirebaseAuth.instance.signInWithCredential(credential);

    // logger.d(googleAuth);
    // logger.d(googleAuth?.accessToken);
    // logger.d(googleAuth?.idToken);
    //
    if (googleAuth == null ||
        googleAuth.idToken == null ||
        googleAuth.accessToken == null) {
      throw Exception("로그인 실패");
    }

    await Supabase.instance.client.auth.signInWithIdToken(
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken!,
      provider: OAuthProvider.google,
    );

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomeScreen()));
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('로그인 실패')));
  }
}

// import 'package:calendar_scheduler/component/login_text_field.dart';
// import 'package:calendar_scheduler/const/colors.dart';
// import 'package:calendar_scheduler/provider/schedule_provider.dart';
// import 'package:calendar_scheduler/screen/home_screen.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   String email = '';
//   String password = '';

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<ScheduleProvider>();

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Form(
//           key: formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,

//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Image.asset(
//                   'assets/img/logo.png',
//                   width: MediaQuery.of(context).size.width * 0.5,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               LoginTextField(
//                 onSaved: (String? v) {
//                   email = v!;
//                 },
//                 validator: (String? v) {
//                   if (v?.isEmpty ?? true) {
//                     return '이메일을 입력해주세요.';
//                   }

//                   RegExp reg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

//                   if (!reg.hasMatch(v!)) {
//                     return '이메일 형식이 아닙니다.';
//                   }

//                   return null;
//                 },
//                 hintText: "이메일",
//               ),
//               const SizedBox(height: 8),
//               LoginTextField(
//                 obscureText: true,
//                 onSaved: (String? v) {
//                   password = v!;
//                 },
//                 validator: (String? v) {
//                   if (v?.isEmpty ?? true) {
//                     return '비밀번호를 입력해주세요.';
//                   }

//                   if (v!.length < 4 || v.length > 8) {
//                     return '비밀번호는 4~8자 사이로 입력해주세요.';
//                   }

//                   return null;
//                 },
//                 hintText: "비밀번호",
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: SECONDARY_COLOR,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                 ),
//                 onPressed: () {
//                   onRegisterPress(provider);
//                 },
//                 child: Text("회원가입"),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: SECONDARY_COLOR,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                 ),
//                 onPressed: () {
//                   onLoginPress(provider);
//                 },
//                 child: Text("로그인"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   bool saveAndValidateForm() {
//     if (!formKey.currentState!.validate()) {
//       return false;
//     }

//     formKey.currentState!.save();

//     return true;
//   }

//   onRegisterPress(ScheduleProvider provider) async {
//     if (!saveAndValidateForm()) {
//       return;
//     }

//     String? message;

//     try {
//       await provider.register(email: email, password: password);
//     } on DioException catch (e) {
//       message = e.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
//     } catch (e) {
//       message = '알 수 없는 오류가 발생했습니다.';
//     } finally {
//       if (message != null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(message)));
//       } else {
//         Navigator.of(
//           context,
//         ).push(MaterialPageRoute(builder: (_) => HomeScreen()));
//       }
//     }
//   }

//   onLoginPress(ScheduleProvider provider) async {
//     if (!saveAndValidateForm()) {
//       return;
//     }

//     String? message;

//     try {
//       await provider.login(email: email, password: password);
//     } on DioException catch (e) {
//       message = e.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
//     } catch (e) {
//       message = '알 수 없는 오류가 발생했습니다.';
//     } finally {
//       if (message != null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(message)));
//       } else {
//         Navigator.of(
//           context,
//         ).push(MaterialPageRoute(builder: (_) => HomeScreen()));
//       }
//     }
//   }
// }
