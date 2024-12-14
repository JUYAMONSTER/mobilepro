import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:closely/ClothPlus.dart';

class WinterClothPage extends StatefulWidget {
  @override
  _WinterClothPageState createState() => _WinterClothPageState();
}

class _WinterClothPageState extends State<WinterClothPage> {
  List<Map<String, String>> winterClothingItems = []; // 겨울 옷 리스트

  @override
  void initState() {
    super.initState();
    _loadWinterClothes(); // 겨울 옷 로드
  }

  // SharedPreferences에서 겨울 옷 로드
  Future<void> _loadWinterClothes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString('clothingData');

    if (existingData != null) {
      List<Map<String, dynamic>> clothingList = List<Map<String, dynamic>>.from(jsonDecode(existingData));

      setState(() {
        winterClothingItems = clothingList
            .where((item) => item['season'] == '겨울') // 겨울 옷 필터링
            .map((item) => {
          'name': item['name'] as String,
          'image': item['image'] as String,
          'season': item['season'] as String,
        })
            .toList();
      });
    }
  }

  // 옷 추가 함수
  void _addClothingItem(String name, String imagePath, String season) {
    if (name.isNotEmpty && imagePath.isNotEmpty && season.isNotEmpty) {
      setState(() {
        winterClothingItems.add({'name': name, 'image': imagePath, 'season': season});
      });
    }
  }

  // 옷 삭제 함수
  void _removeClothingItem(int index) {
    setState(() {
      winterClothingItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('겨울 옷 관리'),
      ),
      body: Column(
        children: [
          Expanded(
            child: winterClothingItems.isEmpty
                ? Center(child: Text('겨울 옷이 없습니다.'))
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 줄에 두 개의 아이템
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4, // 네모 비율 설정
              ),
              itemCount: winterClothingItems.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    // 옷 이미지 표시
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.memory(
                              base64Decode(winterClothingItems[index]['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              winterClothingItems[index]['name']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 삭제 버튼
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeClothingItem(index),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // 추가 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final newItem = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClothPlus()),
                );

                if (newItem != null && newItem is Map<String, String>) {
                  _addClothingItem(
                    newItem['name']!,
                    newItem['image']!,
                    newItem['season']!,
                  );
                }
              },
              child: Text('옷 추가하기'),
            ),
          ),
        ],
      ),
    );
  }
}
