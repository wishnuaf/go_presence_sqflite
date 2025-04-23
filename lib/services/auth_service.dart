import 'dart:convert';

import 'package:go_presence_sqflite/api/endpoint.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$Endpoint/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
