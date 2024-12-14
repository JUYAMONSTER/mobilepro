import 'dart:convert';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClothPlus extends StatefulWidget {
  @override
  _ClothPlusState createState() => _ClothPlusState();
}

class _ClothPlusState extends State<ClothPlus> {
  Uint8List? selectedImageBytes; // 웹 환경에서 이미지 바이트 저장
  File? selectedImageFile; // 모바일(Android/iOS)에서 파일 경로 저장
  String selectedSeason = '봄'; // 기본 계절 선택
  String selectedBodyPart = '선택'; // 기본 부위 선택
  String clothingName = ''; // 사용자 입력 옷 이름

  @override
  void initState() {
    super.initState();
    _loadFromLocal(); // 앱 시작 시 데이터 로드
  }

  // 플랫폼 감지 함수
  bool isMobile() => !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool isWeb() => kIsWeb;

  // 이미지 선택 함수
  Future<void> _pickImage() async {
    if (isMobile()) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          selectedImageFile = File(pickedFile.path);
          selectedImageBytes = null; // 웹과 중복 방지
        });
      }
    } else if (isWeb()) {
      final Uint8List? imageData = await ImagePickerWeb.getImageAsBytes();
      if (imageData != null) {
        setState(() {
          selectedImageBytes = imageData;
          selectedImageFile = null; // 모바일과 중복 방지
        });
      }
    }
  }

  // 데이터 저장 함수
  Future<void> _saveToLocal() async {
    if ((selectedImageFile == null && selectedImageBytes == null) || selectedBodyPart == '선택' || clothingName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지, 부위, 옷 이름을 선택해주세요!')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    // 기존 데이터 불러오기
    final String? existingData = prefs.getString('clothingData');
    List<Map<String, dynamic>> clothingList = []; // dynamic으로 변경
    if (existingData != null) {
      try {
        clothingList = List<Map<String, dynamic>>.from(jsonDecode(existingData));
      } catch (e) {
        print("Error decoding SharedPreferences data: $e");
        clothingList = []; // 데이터 초기화
      }
    }

    // 새 데이터 추가
    String imageEncoded;
    if (isMobile()) {
      imageEncoded = selectedImageFile!.path; // 모바일은 파일 경로 저장
    } else if (isWeb()) {
      imageEncoded = base64Encode(selectedImageBytes!); // 웹은 Base64로 저장
    } else {
      return; // 지원되지 않는 플랫폼
    }

    // 현재 날짜 저장
    String dateAdded = DateTime.now().toIso8601String(); // ISO 8601 형식으로 날짜 저장

    clothingList.add({
      'image': imageEncoded,
      'season': selectedSeason,
      'bodyPart': selectedBodyPart,
      'name': clothingName, // 옷 이름 추가
      'favorite': null, // favorite 값 추가
      'dateAdded': dateAdded, // 추가된 날짜 저장
      'wearCount': 0, // 입은 횟수 초기화
    });

    // 로컬에 저장
    try {
      await prefs.setString('clothingData', jsonEncode(clothingList));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장되었습니다!')),
      );

      // 상위 화면으로 데이터 반환
      Navigator.of(context).pop({
        'image': imageEncoded,
        'season': selectedSeason,
        'bodyPart': selectedBodyPart,
        'name': clothingName, // 옷 이름 반환
        'favorite': null, // favorite 값 반환
        'dateAdded': dateAdded, // 날짜 반환
        'wearCount': 0, // 입은 횟수 반환
      });
    } catch (e) {
      print("Error saving data to SharedPreferences: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류가 발생했습니다.')),
      );
    }
  }

  // SharedPreferences에서 데이터 로드
  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString('clothingData');

    if (existingData != null) {
      List<dynamic> clothingList = jsonDecode(existingData); // dynamic으로 변경

      setState(() {
        // 변환 과정 추가
        clothingList = clothingList.map((item) {
          return {
            'image': item['image'] as String,
            'season': item['season'] as String,
            'bodyPart': item['bodyPart'] as String,
            'name': item['name'] as String,
            'favorite': item['favorite'], // favorite 값 추가
            'dateAdded': item['dateAdded'], // 날짜 추가
            'wearCount': item['wearCount'] ?? 0, // 입은 횟수 추가
          };
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloth Plus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 선택
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: (isMobile() && selectedImageFile != null)
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      selectedImageFile!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : (isWeb() && selectedImageBytes != null)
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      selectedImageBytes!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Center(
                    child: Text(
                      '사진 추가하기\n(클릭하여 이미지 선택)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // 옷 이름 입력
              TextField(
                decoration: InputDecoration(
                  labelText: '옷 이름',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    clothingName = value; // 사용자 입력 저장
                  });
                },
              ),

              SizedBox(height: 16),

              // 계절 선택
              Text(
                '계절:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: ['봄', '여름', '가을', '겨울'].map((season) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: season,
                        groupValue: selectedSeason,
                        onChanged: (value) {
                          setState(() {
                            selectedSeason = value!;
                          });
                        },
                      ),
                      Text(season),
                    ],
                  );
                }).toList(),
              ),

              SizedBox(height: 16),

              // 부위 선택
              Text(
                '부위:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedBodyPart,
                onChanged: (value) {
                  setState(() {
                    selectedBodyPart = value!;
                  });
                },
                items: ['선택', '상체', '하체', '전체']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              SizedBox(height: 24),

              // 저장 버튼
              Center(
                child: ElevatedButton(
                  onPressed: _saveToLocal,
                  child: Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
