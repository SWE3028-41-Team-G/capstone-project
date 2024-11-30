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

class MajorProvider with ChangeNotifier {
  // 전공 목록
  List<Major> _majors = [];
  // 로딩 상태
  bool _isLoading = true;
  // 에러 메시지
  String _errorMessage = '';
  // 선택된 전공을 관리하는 Map
  Map<String, Major?> _selectedMajors = {};

  List<Major> get majors => _majors;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  get selectedMajors => _selectedMajors;

  // 각 MajorDropdown의 key에 해당하는 선택된 전공을 가져오는 함수
  Major? getSelectedMajor(String key) {
    return _selectedMajors[key];
  }

  // 선택된 Major를 설정하는 함수
  void setSelectedMajor(String key, Major? major) {
    _selectedMajors[key] = major;
    debugPrint("setSelectedMajor 호출: $_selectedMajors");
    notifyListeners(); // 상태 업데이트 후 리빌드
  }

  // 특정 키에 해당하는 선택된 Major를 삭제하는 함수
  void removeSelectedMajor(String key) {
    if (_selectedMajors.containsKey(key)) {
      debugPrint("removeSelectedMajor 호출: $_selectedMajors");
      _selectedMajors.remove(key); // 키 삭제
      notifyListeners(); // 상태 갱신
    }
  }

  // API 호출 함수
  Future<void> loadMajors() async {
    try {
      _isLoading = true;
      notifyListeners(); // 로딩 상태 알리기
      final majors = await fetchMajor(); // 데이터 로드
      debugPrint("전공들 잘 들어오고 있나요 : $majors");
      _majors = majors;
      _isLoading = false;
      notifyListeners(); // 데이터 로드 후 상태 갱신
    } catch (e) {
      _errorMessage = 'Error loading majors: $e';
      _isLoading = false;
      notifyListeners(); // 에러 발생 시 상태 갱신
    }
  }
}

class MajorDropdown extends StatefulWidget {
  final String labelText;
  final bool isStyled;
  final String majorKey;
  Major? value;
  MajorDropdown(
      {super.key,
      this.value,
      required this.labelText,
      required this.isStyled,
      required this.majorKey});

  @override
  _MajorDropdownState createState() => _MajorDropdownState();
}

class _MajorDropdownState extends State<MajorDropdown> {
  // FocusNode를 클래스 내에서 선언
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // 데이터를 로드를 위해 Provider를 통해 loadMajors 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MajorProvider>(context, listen: false).loadMajors();
    });
    // FocusNode에 리스너 추가하여 포커스 상태 추적
    _focusNode.addListener(() {
      setState(() {}); // 포커스 상태가 변경되면 UI 업데이트
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // FocusNode 해제
    super.dispose();
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

    // 선택된 전공을 가져오기 (Provider에서 관리)
    Major? selectedMajor = majorProvider.getSelectedMajor(widget.majorKey);
    if (widget.value != null) {
      selectedMajor = widget.value;
    }

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
          value: selectedMajor?.id,
          isExpanded: true,
          hint: Text(
            widget.labelText,
            style: TextStyle(color: Colors.grey[500]),
          ),
          onChanged: (value) {
            setState(() {
              // 전공이 선택되면 해당 전공을 Provider에 업데이트
              final major =
                  majorProvider.majors.firstWhere((major) => major.id == value);
              majorProvider.setSelectedMajor(
                  widget.majorKey, major); // 선택된 전공 업데이트
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
          value: selectedMajor?.id,
          focusNode: _focusNode,
          onChanged: (value) {
            setState(() {
              // 전공이 선택되면 해당 전공을 Provider에 업데이트
              final major =
                  majorProvider.majors.firstWhere((major) => major.id == value);
              majorProvider.setSelectedMajor(widget.majorKey, major);
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
            labelStyle: TextStyle(
              color: _focusNode.hasFocus ? Colors.green[700] : Colors.grey[600],
            ),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[700]!, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 23, horizontal: 13),
          ),
        ),
      );
    }
  }
}
