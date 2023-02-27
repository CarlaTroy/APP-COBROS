import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instanciaUserPreferences = UserPreferences._internal();

  factory UserPreferences() {
    return _instanciaUserPreferences;
  }
  UserPreferences._internal();
  SharedPreferences? _userPreferences;

  initPreferencias() async {
    _userPreferences = await SharedPreferences.getInstance();
  }
  String get token {
    return _userPreferences?.getString('token') ?? '';
  }
  set token(String value) {
    _userPreferences?.setString('token', value);
  }
  String get idEstudiante {
    return _userPreferences?.getString('idEstudiante') ?? '';
  }
  set idEstudiante(String value) {
    _userPreferences?.setString('idEstudiante', value);
  }

String get idUsuario {
    return _userPreferences?.getString('idUsuario') ?? '';
  }
  set idUsuario(String value) {
    _userPreferences?.setString('idUsuario', value);
  }

  String get nombres {
  return _userPreferences?.getString('nombres') ?? '';
  }

  set nombres(String value) {
    _userPreferences?.setString('nombres', value);
  }
  Future clear() async {
    await _userPreferences?.clear();
  }
}
