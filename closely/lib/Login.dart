import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:closely/SignUpPage.dart';  // 필요한 페이지
import 'MainPage.dart';  // 메인 페이지로 이동할 페이지
import 'package:google_sign_in/google_sign_in.dart';  // google_sign_in 패키지 임포트

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId: '691328470279-d28kh7fole22giesrqhs6q84rv2av1dm.apps.googleusercontent.com',
  ); // clientId 제거

  // Firebase 로그인 메서드 (이메일/비밀번호)
  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        // 화면 전환을 안전하게 처리
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mainpage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? '로그인에 실패하였습니다.');
    }
  }

  // Google 로그인 메서드
  Future<void> _googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // 사용자가 로그인 취소한 경우
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase 인증
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null && mounted) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mainpage()),
        );
      }
    } catch (e) {
      print("Google 로그인 실패: $e");
      _showErrorDialog('Google 로그인에 실패했습니다.');
    }
  }

  // 오류 다이얼로그
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('오류'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'MY Closetly',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: '이메일 주소',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Color(0xB2D9D9D9),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Color(0xB2D9D9D9),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('로그인'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF21ADF9),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Google 로그인 버튼을 계정 만들기 버튼 위로 이동
                  ElevatedButton.icon(
                    onPressed: _googleLogin,
                    icon: Icon(Icons.g_mobiledata), // 구글 아이콘
                    label: Text('Google로 로그인'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
                      foregroundColor: Colors.black, // 글자색을 검정색으로 설정
                      minimumSize: Size(double.infinity, 50),
                      side: BorderSide(color: Colors.grey), // 테두리 추가
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      '계정 만들기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '아이디 찾기/비밀번호 찾기',
                      style: TextStyle(
                        color: Color(0xFF21ADF9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
