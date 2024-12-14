import 'package:closely/AutumnClothPage.dart';
import 'package:closely/SpringClothPage.dart';
import 'package:closely/WinterClothPage.dart';
import 'package:flutter/material.dart';
import 'package:closely/SummerClothPage.dart';


class SeasonCloth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '계절별 옷',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
      ),
      body: ListView(
        children: [
          _buildMenuItem(context, '봄', Icons.wb_sunny, Colors.orange, (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpringClothPage()),
            );
          }),
          _buildMenuItem(context, '여름', Icons.wb_cloudy, Colors.blue, (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SummerClothPage()),
            );
          }),
          _buildMenuItem(context, '가을', Icons.wb_twilight, Colors.brown, (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AutumnClothPage()),
            );
          }),
          _buildMenuItem(context, '겨울', Icons.ac_unit, Colors.lightBlue, (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WinterClothPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Color iconColor, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      onTap: onTap,
    );
  }
}
