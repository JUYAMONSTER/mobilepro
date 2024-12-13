import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // 옷 리스트 데이터 (동적으로 관리)
  List<String> favoriteClothes = ['옷 1', '옷 2', '옷 3'];

  // 옷 추가 함수
  void _addFavoriteClothing() {
    setState(() {
      favoriteClothes.add('옷 ${favoriteClothes.length + 1}');
    });
  }

  // 옷 삭제 함수
  void _removeFavoriteClothing(int index) {
    setState(() {
      favoriteClothes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('즐겨찾기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // "즐겨찾기 옷 리스트" 제목
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '즐겨찾기 옷 리스트',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16), // 간격 추가

            // 즐겨찾기 옷 리스트 (회색 네모 박스 + 별 아이콘 + 삭제 버튼)
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 한 줄에 두 개의 아이템
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 4, // 네모 비율 설정
                ),
                itemCount: favoriteClothes.length, // 옷 개수에 따라 리스트 생성
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      // 회색 네모 박스
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey, // 회색 네모 박스
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            favoriteClothes[index], // 옷 이름 표시
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      // 오른쪽 아래 별 아이콘
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 24,
                        ),
                      ),
                      // 오른쪽 위 삭제 버튼
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _removeFavoriteClothing(index),
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 20), // 간격 추가

            // 하단 "즐겨찾기 추가" 버튼
            ElevatedButton(
              onPressed: _addFavoriteClothing, // 옷 추가 함수 호출
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // 버튼 색상 설정
                minimumSize: Size(double.infinity, 50), // 버튼 크기
              ),
              child: Text(
                '즐겨찾기 추가',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
