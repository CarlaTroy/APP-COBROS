import 'dart:io';

import 'package:cobros/config/createMaterialColor.dart';
import 'package:cobros/config/preferenciasUsuario.dart';
import 'package:cobros/pages/edit.perfil.page.dart';
import 'package:cobros/pages/home.page.dart';
import 'package:cobros/pages/item.payment.page.dart';
import 'package:cobros/pages/login.page.dart';
import 'package:flutter/material.dart';

void main() async{
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final preferencias = UserPreferences();
  print(preferencias.token);
  await preferencias.initPreferencias();
  runApp(const MyApp());
}

 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final preferencias = UserPreferences();
  final createMaterialColor = CreateMaterialColor();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COBROS',
      initialRoute: preferencias.token.isNotEmpty? 'home': 'login',
        themeMode: ThemeMode.dark,
        routes: {
          'login': (BuildContext) =>  LoginPage(),
          'home': (BuildContext) =>  HomePage(),
          'editperfil': (BuildContext) =>  EditPerfilPage(),
          'itempayment': (BuildContext) =>  ItemPayment(),
        },
       theme: ThemeData(
          primaryColor: const Color.fromRGBO(53, 80, 112, 1.0),
          primarySwatch:
              createMaterialColor.createMaterialColor( Color(0xFF355070)),
        ),
    );
  }
}
