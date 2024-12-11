import 'package:flutter/material.dart';

class ClothingListPage extends StatefulWidget {
  @override
  _ClothingListPageState createState() => _ClothingListPageState();
}

class _ClothingListPageState extends State<ClothingListPage> {
  // 옷 리스트를 관리하는 동적 리스트 (이미지 경로 포함)
  List<Map<String, String>> clothingItems = [
    {'name': '검정 맨투맨', 'image': 'assets/images/sweatshirt.png'},
    {'name': '청바지', 'image': 'assets/images/jeans.png'},
    {'name': '회색 스웨터', 'image': 'assets/images/sweater.png'},
  ];

  // 옷 추가 함수
  void _addClothingItem(String newItem, String imagePath) {
    if (newItem.isNotEmpty && imagePath.isNotEmpty) {
      setState(() {
        clothingItems.add({'name': newItem, 'image': imagePath});
      });
    }
  }

  // 옷 삭제 함수
  void _removeClothingItem(int index) {
    setState(() {
      clothingItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 보유중인 옷'),
      ),
      body: Column(
        children: [
          // 옷 추가 UI
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '추가할 옷 이름 입력',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // 옷 추가 다이얼로그
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController nameController =
                        TextEditingController();
                        TextEditingController imageController =
                        TextEditingController();
                        return AlertDialog(
                          title: Text('옷 추가'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: '추가할 옷 이름 입력',
                                ),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: imageController,
                                decoration: InputDecoration(
                                  hintText: '이미지 경로 입력',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _addClothingItem(
                                  nameController.text,
                                  imageController.text,
                                );
                                Navigator.of(context).pop();
                              },
                              child: Text('추가'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('취소'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('추가'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 줄에 두 개의 아이템
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4, // 네모 비율 설정
              ),
              itemCount: clothingItems.length,
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
                            child: Image.asset(
                              clothingItems[index]['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              clothingItems[index]['name']!,
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
        ],
      ),
    );
  }
}
