import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, double?>> getCoordinatesFromAddress(String address) async {
  String apiKey = dotenv.env['API_KEY']!;
  String url =
      'https://dapi.kakao.com/v2/local/search/address.json?query=$address';

  Map<String, String> headers = {
    'Authorization': 'KakaoAK $apiKey',
  };

  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var documents = jsonResponse['documents'];

    if (documents.isNotEmpty) {
      var location = documents[0]['address'];
      double latitude = double.parse(location['y'] ?? '0.0');
      double longitude = double.parse(location['x'] ?? '0.0');

      return {
        'latitude': latitude,
        'longitude': longitude,
      };
    } else {
      return {'latitude': null, 'longitude': null};
    }
  } else {
    throw Exception('주소 변환에 실패했습니다.');
  }
}