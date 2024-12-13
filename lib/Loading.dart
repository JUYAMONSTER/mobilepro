import 'package:flutter/material.dart';
import 'package:closely/Login.dart'; // LoginPage를 가져옵니다.
import 'dart:async'; // Future.delayed를 위해 필요

class MainLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 5초 후 로그인 화면으로 자동 이동
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // 5초 후 로그인 페이지로 이동
      );
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(
              top: 168,
              left: 59,
              right: 60,
              bottom: 192,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12), // 모서리 둥글게
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'MY Closetly',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Josefin Slab',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20), // 로딩 화면에서 스페이싱 추가
                CircularProgressIndicator( // 로딩 스피너
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
