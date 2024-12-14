import 'package:flutter/material.dart';
import 'package:closely/AccountPage.dart';
import 'package:closely/SettingPage.dart';
import 'package:closely/FavoritePage.dart';
import 'package:closely/ClothingListPage.dart';
import 'package:closely/MenuPage.dart';
import 'package:closely/LaundryPage.dart';
import 'package:closely/ClothPlus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Mainpage(),
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
    );
  }
}

class Mainpage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Mainpage> {
  int _currentIndex = 1; // 기본 탭: 홈

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '앱 사용법 안내',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '앱 사용법',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. 아래 버튼을 눌러 의상을 추가하세요!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClothPlus()),
                );
              },
              child: Text('의상 추가하기'),
            ),
            SizedBox(height: 16),
            Text(
              '2. 추가된 의상은 메뉴에 내 보유중인 옷 메뉴나 계절별 옷 메뉴를 통해 확인할 수 있습니다!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              '3. 등록된 옷을 클릭하면 나타나는 오늘 입기 버튼과 즐겨찾기 버튼을 눌러 작업을 수행하세요!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              '4. 근처 세탁소를 찾으신다면 근처 세탁소 찾기 메뉴를 사용해 보세요!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              '5. 2년 동안 입지 않은 옷은 알림이 갑니다.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),

      // 하단 네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // 현재 선택된 탭의 인덱스
        onTap: (index) {
          setState(() {
            _currentIndex = index; // 현재 인덱스 업데이트
          });

          // 인덱스에 따라 페이지 이동
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuPage()), // MenuPage로 이동
              );
              break;
            case 1:
            // 현재 페이지 유지
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()), // AccountPage로 이동
              );
              break;
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
