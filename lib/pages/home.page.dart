import 'dart:async';

import 'package:cobros/config/preferenciasUsuario.dart';
import 'package:cobros/pages/edit.perfil.page.dart';
import 'package:cobros/pages/list.enrollements.page.dart';
import 'package:cobros/pages/login.page.dart';
import 'package:cobros/pages/logo.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String textTitleAppBar = 'Inicio';

  int _selectedIndexBottomNavigationBar = 0;
  final preferencias = UserPreferences();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    LogoPage(),
    ListadoEnrollementPage(),
    EditPerfilPage(),
  ];

  void _onItemTappedOnBottomNavigationBar(int index) {
    setState(() {
      _selectedIndexBottomNavigationBar = index;
      switch (_selectedIndexBottomNavigationBar) {
        case 0:
          setState(() {
            textTitleAppBar = 'Inicio';
          });
          break;

        case 1:
          setState(() {
            textTitleAppBar = 'Mis Cursos';
          });
          break;

        case 2:
          setState(() {
            textTitleAppBar = 'Perfil';
          });
          break;
      }
    });
  }

    Future<void> verifyTokenPreference() async {
    if (preferencias.token.isEmpty) {
      print(preferencias.token);
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
    verifyTokenPreference();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(textTitleAppBar),
          actions: [
            TextButton(
              onPressed: () {
                Alert(
                  context: context,
                  type: AlertType.warning,
                  title: preferencias.nombres,
                  desc: "¿Está seguro de cerrar sesión?",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "ACEPTAR",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onPressed: () {
                        preferencias.clear();
                        Navigator.pop(context);
                        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
                      },
                      color: Color.fromRGBO(0, 179, 134, 1.0),
                    ),
                    DialogButton(
                      child: Text(
                        "CANCELAR",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onPressed: () => Navigator.pop(context),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(116, 116, 191, 1.0),
                        Color.fromRGBO(52, 138, 199, 1.0)
                      ]),
                    )
                  ],
                ).show();

                //Navigator.pushNamed(context, 'productor');
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            )
          ],
        ),
        body: _widgetOptions.elementAt(_selectedIndexBottomNavigationBar),
              bottomNavigationBar: _bottonNavigatoBar()
        );
  }

  _bottonNavigatoBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          label: 'Inicio',
          icon: Icon(
            Icons.home,
            size: 30.0,
          ),
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.auto_stories_sharp,
              size: 30.0,
            ),
            label: 'Mis Cursos'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.badge,
              size: 30.0,
            ),
            label: 'Perfil'),
      ],
      currentIndex: _selectedIndexBottomNavigationBar,
      selectedItemColor: const Color.fromRGBO(53, 80, 112, 1.0),
      onTap: _onItemTappedOnBottomNavigationBar,
    );
  }
}
