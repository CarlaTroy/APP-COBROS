import 'dart:async';

import 'package:cobros/config/preferenciasUsuario.dart';
import 'package:cobros/pages/login.page.dart';
import 'package:flutter/material.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
    
    late Timer _timer;
    final preferences = UserPreferences();
    

    Future<void> verificarToken() async {
      print(preferences.token);
    if (preferences.token.isEmpty) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      print('ok');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(const Duration(seconds:5),(Timer t){
    verificarToken();
}
);
  }

     @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    print('Dispose...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(child: 
      Container(
      decoration: BoxDecoration(image: DecorationImage(
        image: AssetImage('assets/img/cenesaurio.jpeg'),
        
        fit: BoxFit.cover
      )))),
    );
  }
}
//355x472