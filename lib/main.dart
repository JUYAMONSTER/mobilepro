import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core 패키지 추가
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth 패키지 추가
import 'Login.dart'; // LoginPage를 가져옵니다.
import 'MainPage.dart'; // MainPage를 가져옵니다.
import 'firebase_options.dart'; // Firebase 설정 파일 추가

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Firebase 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Closely',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // 스플래시 스크린으로 변경
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 앱이 시작될 때 로그인 상태에 따라 페이지 이동
    Future.delayed(Duration(seconds: 3), () async {
      User? user = FirebaseAuth.instance.currentUser; // 현재 사용자 확인

      if (user == null) {
        // 로그인이 되어 있지 않다면 로그인 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), // 로그인 페이지로 이동
        );
      } else {
        // 로그인이 되어 있다면 MainPage로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mainpage()), // 메인 페이지로 이동
        );
      }
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // 로딩 스피너 표시
      ),
    );
  }
}
