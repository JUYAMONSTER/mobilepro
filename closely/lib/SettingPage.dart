import 'package:flutter/material.dart';
import 'package:closely/MainPage.dart';
import 'package:closely/AccountPage.dart';
import 'package:closely/FavoritePage.dart';
import 'package:closely/ClothingListPage.dart';
import 'package:closely/LaundryPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MenuPage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationOn = true; // 기본 알림 설정
  int _currentIndex = 1; // BottomNavigationBar의 현재 선택된 탭 인덱스 (설정 페이지는 인덱스 1)

  @override
  void initState() {
    super.initState();
    _loadNotificationSetting(); // 알림 설정 로드
  }

  // SharedPreferences에서 알림 설정 로드
  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationOn = prefs.getBool('isNotificationOn') ?? true; // 기본값은 true
    });
  }

  // SharedPreferences에 알림 설정 저장
  Future<void> _saveNotificationSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationOn', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '앱 설정',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 1,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 알림 설정 스위치
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '알림 설정',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Switch(
                    value: isNotificationOn,
                    onChanged: (value) {
                      setState(() {
                        isNotificationOn = value;
                        _saveNotificationSetting(value); // 설정 변경 시 저장
                      });
                    },
                  ),
                ],
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
}
