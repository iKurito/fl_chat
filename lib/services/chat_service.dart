import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fl_chat/global/environment.dart';
import 'package:fl_chat/models/models.dart';
import 'package:fl_chat/services/services.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final uri = Uri.parse('${ Environment.apiUrl }/mensajes/$usuarioID');
    final resp = await http.get(uri, 
      headers: { 
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() ?? ""
      }
    );

    final mensajesResp = mensajesResponseFromJson(resp.body);
    return mensajesResp.mensajes;
  }
}