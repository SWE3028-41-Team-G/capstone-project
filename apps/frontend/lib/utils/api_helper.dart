import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiHelper {
  static const String baseUrl = "https://skku-dm.site/";

  static Uri buildRequest(String endpoint,
      [Map<String, String>? queryParameters]) {
    return Uri.parse(baseUrl).replace(
      path: endpoint,
      queryParameters: queryParameters,
    );
  }
}

class AuthProvider with ChangeNotifier {
  static const String baseUrl = "https://skku-dm.site/"; // API 서버 URL
  static late CookieJar cookieJar; // 쿠키 관리 객체
  static final FlutterSecureStorage secureStorage =
      FlutterSecureStorage(); // secure storage 객체

  bool _isLoggedIn = false;
  String? _accessToken;

  bool get isLoggedIn => _isLoggedIn;
  String? get accessToken => _accessToken;

  UserReturnType? _user; // 프로필 데이터를 저장할 변수
  UserReturnType? get user => _user;

  // CookieJar 초기화
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage('${dir.path}/cookies'), // 쿠키를 파일에 저장
    );
  }

  // 로그인 요청
  Future<void> login(String username, String password, context) async {
    try {
      await init();
      final loginUri = ApiHelper.buildRequest("auth/login");
      final response = await http.post(
        loginUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      debugPrint(" 아이디 -- $username, 비번 -- $password");
      debugPrint("로그인 statusCode 확인 중 : ${response.statusCode}");
      debugPrint("로그인 response.headers 확인 중 : ${response.headers}");
      debugPrint("로그인 response.body 확인 중 : ${response.body}");

      if (response.statusCode == 201) {
        // 로그인 성공 시, 응답 헤더에서 Authorization 추출
        var token = response.headers['authorization']; // 'Bearer ${token}'

        debugPrint("로그인 성공!!^__^");
        debugPrint("토큰 정보 확인 중 : $token");

        if (token != null) {
          // Access Token을 secure storage에 저장
          await _saveAccessToken(token);
        }

        // 서버는 'Set-Cookie' 헤더를 통해 Refresh Token을 제공
        // cookie_jar가 자동으로 쿠키에 저장
        _isLoggedIn = true; // 로그인 성공 시 로그인 상태로 설정
        notifyListeners(); // 상태 변경 알림
        // fetchProfileData();
      } else {
        var msg = jsonDecode(response.body)['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Access Token을 secure storage에 저장
  Future<void> _saveAccessToken(String token) async {
    await secureStorage.write(
        key: 'access_token', value: token); // Bearer 포함하여 그대로 저장
    _accessToken = token; // 인스턴스 변수에 토큰 저장
  }

  // Access Token을 secure storage에서 불러오기
  Future<void> _getAccessToken() async {
    _accessToken = await secureStorage.read(key: 'access_token');
  }

  // GET 요청에 Authorization 헤더 포함
  Future<http.Response> get(String endpoint) async {
    try {
      await init();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getAuthHeaders(),
      );

      debugPrint("토큰 포함 GET statusCode : ${response.statusCode}");
      debugPrint("토큰 포함 GET response.body : ${response.body}");

      // 만약 401 Unauthorized 에러가 발생하면, 토큰 갱신을 시도
      if (response.statusCode == 401) {
        await refreshAccessToken(); // 토큰 갱신
        return await http.get(
          Uri.parse('$baseUrl/$endpoint'),
          headers: await _getAuthHeaders(),
        ); // 갱신된 토큰으로 재시도
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT 요청에 Authorization 헤더 포함
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    try {
      await init();
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getAuthHeaders(isJson: true),
        body: jsonEncode(body),
      );

      debugPrint("토큰 포함 PUT statusCode : ${response.statusCode}");
      debugPrint("토큰 포함 PUT response.body : ${response.body}");

      if (response.statusCode == 401) {
        debugPrint("여기까지는 가고 있나요?");
        await refreshAccessToken();
        return await http.put(
          Uri.parse('$baseUrl$endpoint'),
          headers: await _getAuthHeaders(isJson: true),
          body: jsonEncode(body),
        );
      }
      return response;
    } catch (e) {
      debugPrint("PUT 요청 중 오류 발생: $e");
      rethrow;
    }
  }

  // 로그아웃 처리
  Future<void> logout() async {
    try {
      await init();
      final logoutUri = ApiHelper.buildRequest("auth/logout");
      final response =
          await http.post(logoutUri, headers: {"authorization": accessToken!});

      debugPrint("logout POST 잘 되었는지 확인 중 : ${response.statusCode}");
      debugPrint("logout POST response.body 확인 중 : ${response.body}");

      // secureStorage에서 Access Token 삭제
      await secureStorage.delete(key: 'access_token');
      _isLoggedIn = false; // 로그아웃 처리
      // secureStorage에서 Access Token을 다시 읽어 값이 삭제되었는지 확인
      String? deletedAccessToken =
          await secureStorage.read(key: 'access_token');
      debugPrint(
          'Access Token 삭제되었는지 확인 중 null이어야됨: $deletedAccessToken'); // 값이 null이면 삭제됨

      // 쿠키에서 Refresh Token 삭제 (cookie_jar에서 쿠키 삭제)
      await cookieJar.delete(Uri.parse(baseUrl));
      // 쿠키에서 삭제된 값 확인
      var cookies = await cookieJar.loadForRequest(Uri.parse(baseUrl));
      debugPrint('Cookies 삭제되었는지 확인 중 : $cookies'); // 쿠키가 비어있으면 삭제됨

      _accessToken = null;
      notifyListeners(); // 상태 변경 알림
    } catch (e) {
      rethrow;
    }
  }

  // 토큰 갱신 요청 (만약 Access Token이 만료되었으면 호출됨) 수정해야됨 ===================================================
  Future<void> refreshAccessToken() async {
    try {
      final reissueUri = ApiHelper.buildRequest('auth/reissue');
      final response = await http.get(
        reissueUri, // 토큰 갱신 엔드포인트
        headers: await _getAuthHeaders(),
      );

      debugPrint("토큰 갱신 요청 확인 중 : ${response.statusCode}");
      debugPrint("토큰 갱신 요청 response.body 확인 중 : ${response.body}");

      if (response.statusCode == 201) {
        // 새로운 Access Token을 서버에서 반환
        var newAccessToken = jsonDecode(response.body)['access_token'];
        if (newAccessToken != null) {
          // 새로운 Access Token을 secure storage에 저장
          await _saveAccessToken(newAccessToken);
        }
      } else {
        throw Exception('토큰 갱신 실패');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Authorization 헤더를 가져오기 위한 메서드
  Future<Map<String, String>> _getAuthHeaders({bool isJson = false}) async {
    if (_accessToken == null) {
      throw Exception('Access Token이 없습니다.');
    }

    final headers = {
      'authorization': _accessToken!,
    };

    if (isJson) {
      headers['Content-Type'] = 'application/json';
    }

    return headers;
  }

  // 프로필 데이터 가져오기
  Future<void> fetchProfileData() async {
    try {
      // API 요청 경로 생성
      final profileUri = ApiHelper.buildRequest("users/current/profile");

      // GET 요청 전송
      final response = await http.get(
        profileUri,
        headers: await _getAuthHeaders(), // 인증 헤더 포함
      );

      debugPrint("프로필 데이터 GET statusCode: ${response.statusCode}");
      debugPrint("프로필 데이터 response.body: ${response.body}");

      if (response.statusCode == 200) {
        // JSON 데이터 파싱 및 UserReturnType 객체 생성
        final data = jsonDecode(response.body);
        _user = UserReturnType.fromJson(data);

        notifyListeners(); // 상태 변경 알림
      } else {
        throw Exception('프로필 데이터를 가져오지 못했습니다.');
      }
    } catch (e) {
      debugPrint('프로필 데이터를 가져오는 중 오류 발생: $e');
      rethrow;
    }
  }
}

// User정보
class UserMajor {
  final bool origin; // 원전공 여부
  final MajorDetails major; // 전공 정보

  UserMajor({required this.origin, required this.major});

  factory UserMajor.fromJson(Map<String, dynamic> json) {
    return UserMajor(
      origin: json['origin'],
      major: MajorDetails.fromJson(json['Major']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'origin': origin,
      'Major': major.toJson(),
    };
  }
}

class MajorDetails {
  final int id; // 전공 ID
  final String name; // 전공 이름

  MajorDetails({required this.id, required this.name});

  factory MajorDetails.fromJson(Map<String, dynamic> json) {
    return MajorDetails(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class UserReturnType {
  final List<UserMajor> majors; // 전공 목록
  final int userId; // 사용자 ID
  final String imageUrl; // 프로필 이미지 주소
  final String intro; // 한줄소개 (무시)
  final List<String> interests; // 관심사 목록
  final bool public; // 프로필 공개 여부
  final String username; // 아이디
  final String nickname; // 닉네임
  final int admitYear; // 입학년도(yyyy)
  final bool real; // 실제 복수전공 여부

  UserReturnType({
    required this.majors,
    required this.userId,
    required this.imageUrl,
    required this.intro,
    required this.interests,
    required this.public,
    required this.username,
    required this.nickname,
    required this.admitYear,
    required this.real,
  });

  factory UserReturnType.fromJson(Map<String, dynamic> json) {
    var majorsList = (json['majors'] as List)
        .map((major) => UserMajor.fromJson(major))
        .toList();

    return UserReturnType(
      majors: majorsList,
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      intro: json['intro'],
      interests: List<String>.from(json['interests']),
      public: json['public'],
      username: json['username'],
      nickname: json['nickname'],
      admitYear: json['admitYear'],
      real: json['real'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'majors': majors.map((major) => major.toJson()).toList(),
      'userId': userId,
      'imageUrl': imageUrl,
      'intro': intro,
      'interests': interests,
      'public': public,
      'username': username,
      'nickname': nickname,
      'admitYear': admitYear,
      'real': real,
    };
  }
}
