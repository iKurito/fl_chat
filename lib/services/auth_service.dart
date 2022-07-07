import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:fl_chat/global/environment.dart';
import 'package:fl_chat/models/models.dart';

import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  Usuario? usuario;
  bool _autenticando = false;

  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;

  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  // Getters del token de forma estatica
  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    final data = {
      'email': email,
      'password': password
    };
    
    final url = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'      
      }
    );
    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);    
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };
    
    final url = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'      
      }
    );
    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);    
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token') ?? '';

    final uri = Uri.parse('${ Environment.apiUrl }/login/renew');
    final resp = await http.get(uri, 
      headers: { 
        'Content-Type': 'application/json',
        'x-token': token
      }
    );

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(
      key: 'token',
      value: token
    );
  }

  Future logout() async{
    await _storage.delete(key: 'token');
  }
}