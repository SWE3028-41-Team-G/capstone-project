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

  // CookieJar 초기화
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage('${dir.path}/cookies'), // 쿠키를 파일에 저장
    );
  }

  // 로그인 요청
  Future<void> login(String username, String password) async {
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
      } else {
        throw Exception('로그인 실패');
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

  // 요청에 Authorization 헤더 포함
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

  // 로그아웃 처리
  Future<void> logout() async {
    try {
      await init();
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

  // 토큰 갱신 요청 (만약 Access Token이 만료되었으면 호출됨)
  Future<void> refreshAccessToken() async {
    try {
      final reissueUri = ApiHelper.buildRequest('auth/reissue');
      final response = await http.get(
        reissueUri, // 토큰 갱신 엔드포인트
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 201) {
        // 새로운 Access Token을 서버에서 반환
        var newAccessToken = jsonDecode(response.body)['access_token'];
        if (newAccessToken != null) {
          // 새로운 Access Token을 secure storage에 저장
          await _saveAccessToken(newAccessToken); // Bearer 접두사 포함하여 저장
        }
      } else {
        throw Exception('토큰 갱신 실패');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Authorization 헤더를 가져오기 위한 메서드
  Future<Map<String, String>> _getAuthHeaders() async {
    if (_accessToken == null) {
      throw Exception('Access Token이 없습니다.');
    }

    return {
      'Authorization': _accessToken!,
    };
  }
}
