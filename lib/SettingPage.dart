import 'package:flutter/material.dart';
import 'package:closely/MainPage.dart';
import 'package:closely/AccountPage.dart';
import 'package:closely/FavoritePage.dart';
import 'package:closely/ClothingListPage.dart';
import 'MenuPage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false; // 기본 테마는 Light
  String selectedLanguage = 'Korean'; // 기본 언어
  bool isNotificationOn = true; // 기본 알림 설정
  int _currentIndex = 1; // BottomNavigationBar의 현재 선택된 탭 인덱스 (설정 페이지는 인덱스 1)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '앱 설정',
          style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
        ),
        backgroundColor: isDarkTheme ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        elevation: 1,
      ),
      body: Container(
        color: isDarkTheme ? Colors.black : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 테마 설정 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isDarkTheme = false; // 화이트 테마로 변경
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text('화이트 테마'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isDarkTheme = true; // 블랙 테마로 변경
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('블랙 테마'),
                  ),
                ],
              ),
            ),

            // 언어 설정
            _buildSettingItem(
              title: '언어',
              value: selectedLanguage,
              onTap: () {
                setState(() {
                  selectedLanguage =
                  selectedLanguage == 'Korean' ? 'English' : 'Korean';
                });
              },
            ),

            // 알림 설정
            _buildSettingItem(
              title: '알림 설정',
              value: isNotificationOn ? '예' : '아니요',
              onTap: () {
                setState(() {
                  isNotificationOn = !isNotificationOn;
                });
              },
            ),

            // 로그아웃 버튼
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // 로그아웃 동작 추가
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                    foregroundColor: isDarkTheme ? Colors.white : Colors.black,
                  ),
                  child: Text('로그아웃'),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // 현재 선택된 탭의 인덱스
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // 인덱스에 따라 페이지 이동
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ClothingListPage()), // MainPage로 이동
            );
          } else if (index == 1) {
            // 현재 페이지 유지
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AccountPage()), // AccountPage로 이동
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '메뉴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
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

  // 설정 항목 빌더
  Widget _buildSettingItem({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
