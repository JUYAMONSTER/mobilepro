import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        backgroundColor: Color(0xFF21ADF9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
              ),
              child: Column(
                children: [
                  // 회원가입 텍스트
                  Text(
                    '새 계정 만들기',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),

                  // 이메일 입력 필드
                  TextFormField(
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

                  // 비밀번호 입력 필드
                  TextFormField(
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
                  SizedBox(height: 20),

                  // 비밀번호 확인 필드
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호 확인',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Color(0xB2D9D9D9),
                    ),
                  ),
                  SizedBox(height: 40),

                  // 회원가입 버튼
                  ElevatedButton(
                    onPressed: () {
                      // 회원가입 처리 로직 추가
                      // 예시: 회원가입 정보 전송 또는 확인
                    },
                    child: Text('회원가입'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Color(0xFF21ADF9),
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
