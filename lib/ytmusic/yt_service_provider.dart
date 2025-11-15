import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

import '../config/api_config.dart';
import 'helpers.dart';

abstract class YTMusicServices {
  YTMusicServices() : super() {
    init();
  }
  Future<void> init() async {
    headers = initializeHeaders();
    context = initializeContext();

    if (!headers.containsKey('X-Goog-Visitor-Id')) {
      headers['X-Goog-Visitor-Id'] = await getVisitorId(headers) ?? '';
    }
  }

  void refreshContext() {
    context = initializeContext();
  }

  Future<void> refreshHeaders() async {
    headers = initializeHeaders();
  }

  Future<void> resetVisitorId() async {
    Map<String, String> newHeaders = Map.from(headers);
    newHeaders.remove('X-Goog-Visitor-Id');
    final response = await sendGetRequest(httpsYtmDomain, newHeaders);
    final reg = RegExp(r'ytcfg\.set\s*\(\s*({.+?})\s*\)\s*;');
    RegExpMatch? matches = reg.firstMatch(response.body);
    String? visitorId;
    if (matches != null) {
      final ytcfg = json.decode(matches.group(1).toString());
      visitorId = ytcfg['VISITOR_DATA']?.toString();
      await Hive.box('SETTINGS').put('VISITOR_ID', visitorId);
    }
    refreshHeaders();
  }

  // API configuration - moved to ApiConfig for better security
  static const ytmDomain = ApiConfig.ytmDomain;
  static const httpsYtmDomain = ApiConfig.httpsYtmDomain;
  static const baseApiEndpoint = ApiConfig.baseApiEndpoint;
  static String get ytmParams => ApiConfig.ytmParams;
  static const userAgent = ApiConfig.userAgent;

  // HTTP timeout to prevent indefinite hanging
  static const httpTimeout = Duration(seconds: 30);

  Map<String, String> headers = {};
  int? signatureTimestamp;
  Map<String, dynamic> context = {};

  Future<Response> sendGetRequest(
    String url,
    Map<String, String>? headers,
  ) async {
    final Uri uri = Uri.parse(url);
    final Response response =
        await get(uri, headers: headers).timeout(httpTimeout);
    return response;
  }

  Future<Response> addPlayingStats(String videoId, Duration time) async {
    final Uri uri = Uri.parse(
        'https://music.youtube.com/api/stats/watchtime?ns=yt&ver=2&c=WEB_REMIX&cmt=${(time.inMilliseconds / 1000)}&docid=$videoId');
    final Response response =
        await get(uri, headers: headers).timeout(httpTimeout);
    return response;
  }

  Future<String?> getVisitorId(Map<String, String>? headers) async {
    final response = await sendGetRequest(httpsYtmDomain, headers);
    final reg = RegExp(r'ytcfg\.set\s*\(\s*({.+?})\s*\)\s*;');
    final matches = reg.firstMatch(response.body);
    String? visitorId;
    if (matches != null) {
      final ytcfg = json.decode(matches.group(1).toString());
      visitorId = ytcfg['VISITOR_DATA']?.toString();
      await Hive.box('SETTINGS').put('VISITOR_ID', visitorId);
    }
    return await Hive.box('SETTINGS').get('VISITOR_ID');
  }

  Future<Map> sendRequest(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers, String additionalParams = ''}) async {
    //
    body = {...body, ...context};

    this.headers.addAll(headers ?? {});
    final Uri uri = Uri.parse(httpsYtmDomain +
        baseApiEndpoint +
        endpoint +
        ytmParams +
        additionalParams);
    final response = await post(uri, headers: this.headers, body: jsonEncode(body))
        .timeout(httpTimeout);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map;
    } else {
      return {};
    }
  }
}
