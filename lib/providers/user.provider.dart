import 'dart:convert';

import 'package:cobros/config/preferenciasUsuario.dart';
import 'package:cobros/config/utils.dart';
import 'package:cobros/models/student.model.dart';
import 'package:cobros/models/update.user.model.dart';
import 'package:http/http.dart' as http;


class UserProvider {
  final String _url = URLBASE;
  final preferences = UserPreferences();




  Future<Map<String, dynamic>> login(String correo, String password) async {
    final authData = {'username': correo, 'password': password};

    final url = Uri.parse('$_url/auth/login-movil/');
        print(url);
    final resp = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          },
        body: json.encode(authData));

    if (resp.statusCode == 503) {
      return {'ok': false, 'msg': 'Servicio No Disponible'};
    }

    print('RESPONSE LOGIN: ${resp.body}');
    
      final decodeData = jsonDecode(Utf8Decoder().convert(resp.body.codeUnits));

    if (resp.statusCode == 200) {
      preferences.token = decodeData['data']['token'].toString();
      preferences.nombres = decodeData['data']['username'];

      preferences.idUsuario = decodeData['data']['id'].toString();
      preferences.idEstudiante = decodeData['data']['grupos'][0]['id'].toString();
      print(preferences.idEstudiante);
      
      return {'ok': true, 'msg': decodeData['message']};
    }
    if (resp.statusCode == 404) {
      final decodeData = jsonDecode(Utf8Decoder().convert(resp.body.codeUnits));
      return {'ok': false, 'msg': decodeData['message']};
    } else {
      final decodeData = jsonDecode(Utf8Decoder().convert(resp.body.codeUnits));
      return {'ok': false, 'msg': decodeData['message']};
    }
  }


    Future<Map<String, dynamic>> editPerfil(UserModel usuario) async {
      print(preferences.token.replaceAll('[', '').replaceAll(']', ''));
       Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ${preferences.token.replaceAll('[', '').replaceAll(']', '')}'
    };

    var data = {};

      data = {
        "username": usuario.username,
        "email": usuario.email,
        "password": usuario.password,
        "password2": usuario.password2,
        "is_staff": usuario.is_staff,
        "is_active": usuario.is_active,
        "group": usuario.group,
        
      };
      print(data);

      final url = Uri.parse('$_url/auth/users/${preferences.idUsuario}');
    final respuesta = await http.put(url,
        headers: requestHeaders,
        body: json.encode(data));

        print(respuesta.body);
    if (respuesta.statusCode == 200) {
      final body = json.decode(respuesta.body);
      data = {};
      return body;
    }else {
      final body = json.decode(respuesta.body);
      data = {};
      return body;
    }
  }
}
