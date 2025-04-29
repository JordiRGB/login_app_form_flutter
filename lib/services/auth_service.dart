import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String firebaseToken = 'AIzaSyC180ZVyGifEbMW1Bc88RITeMAk6CxOEO8';
  final storage = FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': firebaseToken,
    });

    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(response.body);
    if (decodeResp.containsKey('idToken')) {
      // TODO: Guardar el token en el local storage
      storage.write(key: 'token', value: decodeResp['idToken']);
      // decodeResp['idToken'];
      return null;
    } else {
      return decodeResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': firebaseToken,
    });

    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(response.body);
    if (decodeResp.containsKey('idToken')) {
      // TODO: Guardar el token en el local storage
      storage.write(key: 'token', value: decodeResp['idToken']);
      // decodeResp['idToken'];
      return null;
    } else {
      return decodeResp['error']['message'];
    }
  }

  Future logout() async {
    storage.delete(key: 'token');
  }

  Future<String> readTRoken() async {
    final token = await storage.read(key: 'token') ?? '';
    return token;
  }
}
