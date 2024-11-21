import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/api_helper.dart';
import 'package:provider/provider.dart';

class Major {
  final int id;
  final String name;

  Major({required this.id, required this.name});

  // JSON 데이터를 객체로 변환하는 팩토리 메서드
  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      id: json['id'],
      name: json['name'],
    );
  }
}

Future<List<Major>> fetchMajor() async {
  final Uri request = ApiHelper.buildRequest('majors');
  final response = await http.get(request);

  if (response.statusCode == 200) {
    // JSON 데이터를 List로 파싱
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => Major.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load majors');
  }
}

class MajorProvider extends ChangeNotifier {
  List<Major> _majors = [];
  bool _isLoading = true; // 로딩 중 상태
  String _errorMessage = '';

  List<Major> get majors => _majors;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // API 호출 함수
  Future<void> loadMajors() async {
    try {
      _isLoading = true;
      notifyListeners(); // 로딩 시작 시 상태 갱신
      final majors = await fetchMajor(); // 데이터 로드
      _majors = majors;
      _isLoading = false;
      notifyListeners(); // 데이터 로드 후 상태 갱신
    } catch (e) {
      _errorMessage = 'Error loading majors: $e';
      _isLoading = false;
      notifyListeners(); // 에러가 발생한 경우 상태 갱신
    }
  }
}

class MajorDropdown extends StatefulWidget {
  final String labelText;
  final bool isStyled;
  const MajorDropdown(
      {super.key, required this.labelText, required this.isStyled});

  @override
  _MajorDropdownState createState() => _MajorDropdownState();
}

class _MajorDropdownState extends State<MajorDropdown> {
  Major? _selectedMajor; // 선택된 학과 id를 저장하는 변수

  @override
  void initState() {
    super.initState();
    // 데이터를 로드를 위해 Provider를 통해 loadMajors 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MajorProvider>(context, listen: false).loadMajors();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Provider로 상태 접근
    final majorProvider = Provider.of<MajorProvider>(context);

    // 로딩 중이면 로딩 인디케이터 표시
    // if (majorProvider.isLoading) {
    //   return CircularProgressIndicator(); // 로딩 상태 표시
    // }

    // 에러 메시지가 있으면 표시
    if (majorProvider.errorMessage.isNotEmpty) {
      return Text(majorProvider.errorMessage);
    }

    // DropdownMenuItem 리스트 생성
    final List<DropdownMenuItem<int>> items = majorProvider.majors
        .map((major) => DropdownMenuItem<int>(
              value: major.id,
              child: Text(major.name),
            ))
        .toList();

    // true면 내부 전공 dropdown false면 register 전공 dropdown
    if (widget.isStyled) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: DropdownButton<int>(
          value: _selectedMajor?.id,
          isExpanded: true,
          hint: Text(
            widget.labelText,
            style: TextStyle(color: Colors.grey[500]),
          ),
          onChanged: (value) {
            setState(() {
              _selectedMajor =
                  majorProvider.majors.firstWhere((major) => major.id == value);
            });
          },
          items: items,
          underline: Container(), // 밑줄 제거
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 7),
        child: DropdownButtonFormField<int>(
          items: items,
          value: _selectedMajor?.id,
          onChanged: (value) {
            setState(() {
              _selectedMajor =
                  majorProvider.majors.firstWhere((major) => major.id == value);
            });
          },
          validator: (value) {
            if (value == null) {
              return '';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 23, horizontal: 13),
          ),
        ),
      );
    }
  }
}
