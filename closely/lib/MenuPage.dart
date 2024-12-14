import 'package:flutter/material.dart';
import 'package:closely/AccountPage.dart';
import 'package:closely/SettingPage.dart';
import 'package:closely/FavoritePage.dart';
import 'package:closely/ClothingListPage.dart';
import 'package:closely/LaundryPage.dart';
import 'package:closely/SeasonClothPage.dart';
import 'package:closely/closeappend.dart';
import 'package:closely/ClothPlus.dart';
import 'package:closely/NotificationPage.dart'; // NotificationPage 임포트
import 'MainPage.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '메뉴',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
      ),
      body: ListView(
        children: [
          // 내 보유중인 옷
          _buildMenuItem(context, '내 보유중인 옷', Icons.checkroom, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClothingListPage()),
            );
          }),

          // 계절별 옷
          _buildMenuItem(context, '계절별 옷', Icons.person, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SeasonCloth()),
            );
          }),

          // 즐겨찾기
          _buildMenuItem(context, '즐겨찾기', Icons.star, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritePage()),
            );
          }),

          // 근처 세탁소 찾기
          _buildMenuItem(context, '근처 세탁소 찾기', Icons.local_laundry_service, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LaundryPage()),
            );
          }),

          // 의류 관리 알림
          _buildMenuItem(context, '의류 관리 알림', Icons.notifications, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()), // NotificationPage로 이동
            );
          }),

          // 앱 설정
          _buildMenuItem(context, '앱 설정', Icons.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }),
        ],
      ),
    );
  }

  // 메뉴 아이템 빌더
  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}
