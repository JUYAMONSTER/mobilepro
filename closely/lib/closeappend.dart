import 'package:flutter/material.dart';

class appendclose extends StatelessWidget {
  int _currentIndex = 1; // 기본 탭: 홈

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
      body: Column(
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
                '추가할 옷의 종류를 골라주세요',
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
              crossAxisCount: 4, // 열 개수
              mainAxisSpacing: 16, // 행 간격
              crossAxisSpacing: 16, // 열 간격
              padding: const EdgeInsets.symmetric(horizontal: 16),
              childAspectRatio: 3 / 4, // 네모 칸의 비율
              children: [
                _buildClothingBox('상의'),
                _buildClothingBox('하의'),
                _buildClothingBox('아우터'),
                _buildClothingBox('기타'),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '어떨때 입는지 골라주세요',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),


          Expanded(
            child: GridView.count(
              crossAxisCount: 4, // 열 개수
              mainAxisSpacing: 16, // 행 간격
              crossAxisSpacing: 16, // 열 간격
              padding: const EdgeInsets.symmetric(horizontal: 16),
              childAspectRatio: 3 / 4, // 네모 칸의 비율
              children: [
                _buildClothingBox('봄,가을'),
                _buildClothingBox('여름'),
                _buildClothingBox('겨울'),
                _buildClothingBox('기타'),
              ],
            ),
          )



        ],
      ),



      // 하단 네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // 현재 선택된 탭의 인덱스
        onTap: (index) {
          // 단순히 선택된 탭을 업데이트
          _currentIndex = index;
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
