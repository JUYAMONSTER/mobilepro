import 'package:closely/Loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth 패키지 임포트
import 'package:closely/MenuPage.dart';
import 'package:closely/MainPage.dart';
import 'package:closely/Loading.dart'; // LoginPage 클래스를 임포트

class AccountPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth 인스턴스 생성

  // 로그아웃 함수
  Future<void> _logout(BuildContext context) async {
    await _auth.signOut(); // Firebase 로그아웃
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainLoading()), // LoginPage로 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser; // 현재 로그인한 사용자 정보 가져오기
    String displayName = user?.email ?? 'Guest'; // 이메일 또는 기본 값 설정

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MY Closetly',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
      ),
      body: Center( // Center 위젯으로 감싸서 중앙 정렬
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
          crossAxisAlignment: CrossAxisAlignment.center, // 가로 중앙 정렬
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 80, color: Colors.grey),
            ),
            SizedBox(height: 16), // 아바타와 텍스트 간격
            Text(
              displayName, // 로그인한 사용자의 이메일 표시
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24), // 이메일과 버튼 간격
            ElevatedButton(
              onPressed: () => _logout(context), // 로그아웃 버튼 클릭 시 로그아웃 함수 호출
              child: Text('로그아웃'),
            ),
          ],
        ),
      ),

      // 하단 네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // 계정 페이지가 선택된 상태
        onTap: (index) {
          // 탭에 따라 페이지 이동 처리
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuPage()), // 메뉴 페이지로 이동
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Mainpage()), // 홈 페이지로 이동
            );
          } else if (index == 2) {
            // 현재 페이지 유지
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '메뉴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '계정',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
