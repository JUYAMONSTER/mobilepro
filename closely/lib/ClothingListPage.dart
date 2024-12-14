import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:closely/ClothPlus.dart';

class ClothingListPage extends StatefulWidget {
  @override
  _ClothingListPageState createState() => _ClothingListPageState();
}

class _ClothingListPageState extends State<ClothingListPage> {
  List<Map<String, dynamic>> clothingItems = []; // 모든 의상 정보를 저장
  String selectedBodyPart = "전체"; // 기본 필터: 전체

  @override
  void initState() {
    super.initState();
    _loadClothingData(); // SharedPreferences에서 데이터 로드
  }

  // SharedPreferences에서 데이터 로드
  Future<void> _loadClothingData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString('clothingData');

    if (existingData != null) {
      try {
        List<dynamic> decodedData = jsonDecode(existingData);
        setState(() {
          clothingItems = decodedData.map((item) {
            return Map<String, dynamic>.from(item);
          }).toList();
        });
      } catch (e) {
        print("Error loading data: $e");
        setState(() {
          clothingItems = [];
        });
      }
    }
  }

  // 옷 추가 함수
  void _addClothingItem(Map<String, dynamic> newItem) {
    setState(() {
      clothingItems.add(newItem);
    });
    _saveClothingData(); // 데이터 저장
  }

  // 옷 삭제 함수
  void _removeClothingItem(int index) {
    setState(() {
      clothingItems.removeAt(index);
    });
    _saveClothingData(); // 데이터 저장
  }

  // SharedPreferences에 데이터 저장
  Future<void> _saveClothingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('clothingData', jsonEncode(clothingItems));
  }

  // 선택된 신체 부위에 따라 필터링된 옷 반환
  List<Map<String, dynamic>> _filteredClothingItems() {
    if (selectedBodyPart == "전체") {
      return clothingItems; // 모든 옷 반환
    }
    return clothingItems
        .where((item) => item['bodyPart'] == selectedBodyPart)
        .toList(); // 특정 신체 부위의 옷만 반환
  }

  // 즐겨찾기 및 오늘 입기 버튼 처리
  void _toggleFavorite(int index) {
    setState(() {
      clothingItems[index]['favorite'] = 1; // 즐겨찾기 설정
    });
    _saveClothingData(); // 데이터 저장
  }

  void _wearToday(int index) {
    setState(() {
      // 입은 횟수 증가
      clothingItems[index]['wearCount'] = (clothingItems[index]['wearCount'] ?? 0) + 1;
    });
    _saveClothingData(); // 데이터 저장
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredClothingItems();

    return Scaffold(
      appBar: AppBar(
        title: Text('내 보유중인 옷'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newItem = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ClothPlus(),
                ),
              );
              if (newItem != null && newItem is Map<String, dynamic>) {
                _addClothingItem(newItem);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 신체 부위 선택 드롭다운
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text("신체 부위 필터: "),
                DropdownButton<String>(
                  value: selectedBodyPart,
                  onChanged: (value) {
                    setState(() {
                      selectedBodyPart = value!;
                    });
                  },
                  items: ["전체", "상체", "하체"]
                      .map<DropdownMenuItem<String>>((String bodyPart) {
                    return DropdownMenuItem<String>(
                      value: bodyPart,
                      child: Text(bodyPart),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredItems.isEmpty
                ? Center(child: Text('해당 신체 부위의 옷이 없습니다.'))
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 줄에 두 개의 아이템
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4, // 네모 비율 설정
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                final String? imagePath = item['image'];
                final String? name = item['name'];

                // Null 값 처리
                if (imagePath == null || name == null || imagePath.isEmpty) {
                  return Center(child: Text('잘못된 데이터가 있습니다.'));
                }

                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey, width: 1),
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
                              name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeClothingItem(index),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              item['favorite'] == 1
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: item['favorite'] == 1 ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              // 오늘 입기 버튼 클릭 시
                              // 현재 날짜와 마지막 입은 날짜 비교
                              final lastWornDate = item['lastWornDate'];
                              final today = DateTime.now().toIso8601String().split('T')[0];

                              if (lastWornDate != today) {
                                _wearToday(index);
                                setState(() {
                                  item['lastWornDate'] = today; // 오늘 날짜 저장
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('오늘 입기로 설정되었습니다!')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('오늘은 이미 입었습니다!')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
