import 'dart:async';

import 'package:cobros/models/user.model.dart';
import 'package:cobros/pages/home.page.dart';
import 'package:cobros/providers/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserProvider userProvider = UserProvider();
  User userModel = User();

  bool visible = true;
  bool bottomClickLogin = false;

  final formKey = GlobalKey<FormState>();

  late Timer _timer;

  @override
  initState() {
    super.initState();
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
      appBar: AppBar(
        title: const Text('COBROS'),
      ),
      body: Stack(
        children: [
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.95,
              width: double.infinity,
              
              child: Column(
                children: [
                  SafeArea(
                    child: Container(
                      height: 40.0,
                    ),
                  ),
                  Container(
                    width: size.width * 0.85,
                    margin: const EdgeInsets.symmetric(vertical: 30.0),
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Form(
                      key: formKey,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SafeArea(
                                child: Container(
                                  height: 40.0,
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 40.0),
                                      const Text(
                                        'Iniciar Sesión',
                                        style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      _createFieldEmail(),
                                      const SizedBox(height: 30.0),
                                      _createFieldPassword(),
                                      const SizedBox(height: 30.0),
                                      bottomClickLogin==false?_createButtonOfLogin():CircularProgressIndicator(),
                                      const SizedBox(height: 20.0),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Center(
                              child: Container(
                                  child: Image(
                            image: AssetImage(
                              'assets/img/logo.png',
                            ),
                            width: 90,
                            height: 90,
                          ))),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  _createFieldEmail() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          icon: const Icon(
            Icons.person,
            color: Color.fromRGBO(53, 80, 112, 1.0),
          ),
          hintText: 'Ingrese el Username',
          labelText: 'Username'),
      onSaved: (value) => userModel.username = value!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Ingrese el username';
        } else {
          return null;
        }
      },
    );
  }

 

  _createFieldPassword() {
    return TextFormField(
      obscureText: visible,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.lock_outline,
          color: Color.fromRGBO(53, 80, 112, 1.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            if (mounted) {
              setState(() {
                visible = !visible;
              });
            }
          },
        ),
        hintText: 'Ingresar contraseña',
        labelText: 'Contraseña',
      ),
      onSaved: (value) => userModel.password = value!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Ingrese su contraseña';
        } else {
          return null;
        }
      },
    );
  }

  _createButtonOfLogin() {
    return ElevatedButton(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text('Ingresar'.toUpperCase()),
      ),
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        elevation: const MaterialStatePropertyAll(10.0),
        backgroundColor: const MaterialStatePropertyAll(
          Color.fromRGBO(53, 80, 112, 2.0),
        ),
        foregroundColor: const MaterialStatePropertyAll(Colors.white),
      ),
      onPressed: _login,
    );
  }

  _login() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();
    if (mounted) {
      setState(() {
        //guardando = true;
      });
    }

    var username = userModel.username;
    var password = userModel.password;

    var respuesta = await userProvider.login(username!, password!);
    setState(() {
      bottomClickLogin = true;
    });
    if (respuesta['ok']) {
      mostrarSnackBar(respuesta['msg']);
bottomClickLogin = false;
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(),
            ),
            (Route<dynamic> route) => false);
      });
    } else {
      bottomClickLogin = false;
      mostrarSnackBar(respuesta['msg']);
    }
  }

 void mostrarSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 1800),
      backgroundColor: Color.fromARGB(255, 70, 93, 126),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }


}
