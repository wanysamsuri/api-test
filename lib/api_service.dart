import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl =
      'https://careers.netizenexperience.com/api/assessment/se';

  //get
  Future<dynamic> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  //post
  Future<String> sendData(String email) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'Success: ${response.body}';
      } else {
        return 'Failed: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  //hash
  Future<String> getHash(String email) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['hash'];
      } else {
        return 'Failed to retrieve hash: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  //put
  Future<String> sendPutData(String email, String hash, int x, int y) async {
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'hash': hash,
          'x': x,
          'y': y,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'Success: ${response.body}';
      } else {
        return 'Failed: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
