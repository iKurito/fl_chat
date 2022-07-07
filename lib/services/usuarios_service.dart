import 'package:http/http.dart' as http;

import 'package:fl_chat/models/models.dart';
import 'package:fl_chat/services/services.dart';

import 'package:fl_chat/global/environment.dart';


class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final uri = Uri.parse('${ Environment.apiUrl }/usuarios');
      final resp = await http.get(uri, 
        headers: { 
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? ""
        }
      );
      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e){
      return [];
    }
  }
}