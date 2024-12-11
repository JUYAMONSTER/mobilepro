import 'package:flutter/material.dart';
import 'package:closely/AccountPage.dart';
import 'package:closely/SettingPage.dart';
import 'package:closely/FavoritePage.dart';
import 'package:closely/ClothingListPage.dart';
import 'package:closely/MenuPage.dart';

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

  // 각 페이지의 인스턴스를 미리 생성하여 보관
  final List<Widget> _pages = [
    MenuPage(),
    MainContentPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
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
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // 하단 네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // 현재 선택된 탭의 인덱스
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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

class MainContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 검색창
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: '오늘의 코디는?',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),

        // 나의 옷장 리스트
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '나의 옷장 리스트',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),

        // 옷 네모 칸 리스트
        Expanded(
          child: GridView.count(
            crossAxisCount: 2, // 열 개수
            mainAxisSpacing: 16, // 행 간격
            crossAxisSpacing: 16, // 열 간격
            padding: const EdgeInsets.symmetric(horizontal: 16),
            childAspectRatio: 3 / 4, // 네모 칸의 비율
            children: [
              _buildClothingBox('검정 맨투맨'),
              _buildClothingBox('청바지'),
              _buildClothingBox('회색 스웨터'),
              _buildClothingBox('줄무늬 반팔티'),
            ],
          ),
        ),
      ],
    );
  }

  // 옷 네모 칸 빌더
  Widget _buildClothingBox(String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
