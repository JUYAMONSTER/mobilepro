import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> favoriteClothes = []; // 즐겨찾기 의상 리스트

  @override
  void initState() {
    super.initState();
    _loadFavoriteClothingData(); // 즐겨찾기 데이터 로드
  }

  // SharedPreferences에서 즐겨찾기 데이터 로드
  Future<void> _loadFavoriteClothingData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString('clothingData');

    if (existingData != null) {
      try {
        List<dynamic> decodedData = jsonDecode(existingData);
        setState(() {
          favoriteClothes = decodedData
              .where((item) => item['favorite'] == 1) // favorite이 1인 의상만 필터링
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        });
      } catch (e) {
        print("Error loading data: $e");
        setState(() {
          favoriteClothes = [];
        });
      }
    }
  }

  // 즐겨찾기 삭제 함수 (favorite 값을 0으로 변경)
  void _removeFavoriteClothing(int index) async {
    // 해당 의상의 favorite 값을 0으로 변경
    final itemToUpdate = favoriteClothes[index];
    itemToUpdate['favorite'] = 0;

    // 원본 데이터에서 favorite 값을 업데이트
    await _updateClothingData(itemToUpdate);

    setState(() {
      favoriteClothes.removeAt(index); // UI에서 제거
    });
  }

  // SharedPreferences에 데이터 업데이트
  Future<void> _updateClothingData(Map<String, dynamic> updatedItem) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString('clothingData');

    if (existingData != null) {
      List<dynamic> decodedData = jsonDecode(existingData);
      for (var item in decodedData) {
        if (item['name'] == updatedItem['name']) { // 이름으로 비교 (또는 다른 고유 키 사용)
          item['favorite'] = updatedItem['favorite'];
          break;
        }
      }
      await prefs.setString('clothingData', jsonEncode(decodedData)); // 업데이트된 데이터 저장
    }
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
                  final item = favoriteClothes[index];
                  final String? imagePath = item['image'];
                  final String? name = item['name'];

                  // Null 값 처리
                  if (imagePath == null || name == null || imagePath.isEmpty) {
                    return Center(child: Text('잘못된 데이터가 있습니다.'));
                  }

                  return Stack(
                    children: [
                      // 회색 네모 박스
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey, // 회색 네모 박스
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: imagePath.startsWith('http')
                                  ? Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                              )
                                  : Image.memory(
                                base64Decode(imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                name, // 옷 이름 표시
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
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
          ],
        ),
      ),
    );
  }
}
