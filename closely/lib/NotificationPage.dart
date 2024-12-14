import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> expiredClothes = []; // 15초 이상 안 입은 의상 목록
  bool isNotificationOn = true; // 알림 설정 상태

  @override
  void initState() {
    super.initState();
    _checkExpiredClothes(); // 앱 시작 시 만료된 의상 확인
    _loadNotificationSetting(); // 알림 설정 로드
  }

  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationOn = prefs.getBool('isNotificationOn') ?? true; // 기본값은 true
    });
  }

  Future<void> _checkExpiredClothes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString('clothingData');

    if (existingData != null) {
      List<dynamic> clothingList = jsonDecode(existingData);
      DateTime now = DateTime.now();

      for (var item in clothingList) {
        if (item['wearCount'] == 0) { // 입은 횟수가 0인 의상만 확인
          DateTime dateAdded = DateTime.parse(item['dateAdded']);
          if (now.difference(dateAdded).inSeconds >= 15) { // 15초 이상
            expiredClothes.add(item);
          }
        }
      }
      setState(() {}); // 상태 업데이트
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: expiredClothes.isEmpty
            ? Center(child: Text('15초 이상 입지 않은 의상이 없습니다.'))
            : ListView.builder(
          itemCount: expiredClothes.length,
          itemBuilder: (context, index) {
            final item = expiredClothes[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0), // 블록 간격
              padding: EdgeInsets.all(16.0), // 블록 내부 여백
              decoration: BoxDecoration(
                color: isNotificationOn ? Colors.blue[100] : Colors.grey[300], // 배경색
                borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5.0,
                    offset: Offset(0, 3), // 그림자 위치
                  ),
                ],
              ),
              child: Text(
                isNotificationOn
                    ? '${item['name']}을(를) 안 입은지 15초가 지났습니다.'
                    : '알림이 꺼져 있습니다.', // 알림이 꺼져 있을 때
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
