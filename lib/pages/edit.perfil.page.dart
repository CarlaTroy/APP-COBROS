import 'dart:async';
import 'dart:io';

import 'package:cobros/config/preferenciasUsuario.dart';
import 'package:cobros/models/student.model.dart';
import 'package:cobros/models/update.user.model.dart';
import 'package:cobros/providers/payment.provider.dart';
import 'package:cobros/providers/user.provider.dart';
import 'package:flutter/material.dart';


class EditPerfilPage extends StatefulWidget {
  const EditPerfilPage({Key? key}) : super(key: key);

  @override
  _EditPerfilPageState createState() => _EditPerfilPageState();
}

class _EditPerfilPageState extends State<EditPerfilPage> {
  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool circularProgress = false;
  final userProvider = UserProvider();
  final paymentEnrollementProvider = PaymentProvider();
  final preferencias = UserPreferences();
   String responseMessageServer = '';
   late bool responseSuccessServer = false;

  bool visible = true;
  bool visibleConfirmarPassword = true;
    final TextEditingController _passNuevaController = TextEditingController();
    final TextEditingController _confirmarPassNuevaController = TextEditingController();


  getUserById(){
  paymentEnrollementProvider.getStudentsEnrrollement().then((usuario){
  setState(() {
    print('jajaj ${usuario}');
    student.username = usuario['user']['username'];
    student.email = usuario['user']['email'];
    student.is_staff = usuario['user']['is_staff'];
    student.is_active = usuario['user']['is_active'];
    student.group = usuario['user']['groups'][0]['name'].toString();
    print(student.username);
    print(student.email);
    print(student.is_staff);
    print(student.is_active);
    print(student.group);
    
  });

  });
  }


  @override
  void initState() {
    super.initState();
   
     Future.delayed(
      Duration.zero,
      () {
        setState(
          () {
             getUserById();
          },
        );
      },
    );
  
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _identificationController.dispose();
    _celhPhoneController.dispose();
    _adddressController.dispose();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _identificationController = TextEditingController();
  final TextEditingController _celhPhoneController = TextEditingController();
  final TextEditingController _adddressController = TextEditingController();


  UserModel student = UserModel();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      body: Card(
        child: Form(
          key: _globalKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            children: [
              FutureBuilder(
                future: paymentEnrollementProvider.getStudentsEnrrollement(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasError) {
                    print("eroro: " + snapshot.hasError.toString());
                  }
                  if (snapshot.hasData && snapshot.data! != null) {
                    _nameController.text =
                        snapshot.data!['name'];
                    _lastNameController.text =
                        snapshot.data!['last_name'];
                    _identificationController.text =
                        snapshot.data!['identification'];
                    _celhPhoneController.text =
                        snapshot.data!['cell_phone'];
                    _adddressController.text =
                        snapshot.data!['address'];
      
                    return Column(
                      children: [
      
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person),
                                Text('${_nameController.text.toString()} ${_lastNameController.text.toString()}'),
                              ],
                            ),
                          ),
                          subtitle:
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.credit_card_sharp),
                                            Text(_identificationController.text),
                                          ],
                                        ),
      
                                        Row(
                                          children: [
                                            Icon(Icons.phone_android),
                                            Text(_celhPhoneController.text),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.home),
                                            Text(_adddressController.text),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          isThreeLine: true,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Text('Actualizar Contraseña', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),),
                        Divider(),
                        _crearPassword(),
                        const SizedBox(
                          height: 30.0,
                        ),
                        _crearConfirmarPassword(),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            responseSuccessServer==false?_createButtonEditStudent():CircularProgressIndicator(),
                          ],
                        ),
                      ],
                    );
                  } else {
                    print("no hay datos ");
                    return Center(
                  child: Container(
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15.0,
                            ),
                           CircularProgressIndicator(),
                            SizedBox(
                              height: 30.0,
                            ),
                            Image(image: AssetImage('assets/img/notfound.png',), ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Text('No hay información')
                          ],
                        ),
                      )),
                );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

    _crearPassword() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        onSaved: (value) => _passNuevaController.text = value!,
        validator: (value) {
          print('_crearPassword field: $value');
          if (value == null || value.isEmpty || _passNuevaController.text.isEmpty) {
            return 'Ingrese la contraseña';
          }else{
            return null;
          }
        },
        controller: _passNuevaController,
        obscureText: visible,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
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
          labelText: 'Nueva Contraseña',
          //counterText: snapshot.data,
          
        ),
        onChanged: (text) {
          //print('_crearPassword field: $text');
          setState(() => text);
          
        },
      ),
    );
  }


  _crearConfirmarPassword() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        onSaved: (value) => _confirmarPassNuevaController.text = value!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Repita la contraseña';
          }else{
            return null;
          }
        },
        controller: _confirmarPassNuevaController,
        obscureText: visibleConfirmarPassword,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(visibleConfirmarPassword
                ? Icons.visibility_off
                : Icons.visibility),
            onPressed: () {
              if (mounted) {
                setState(() {
                  visibleConfirmarPassword = !visibleConfirmarPassword;
                });
              }
            },
          ),
          labelText: 'Repita la Contraseña',
          //counterText: snapshot.data,
        ),
        onChanged: (text) {
          
          setState(() => text);
          //print('First text field: $text');
          
        },
      ),
    );
  }

  _editDataOfStudent(BuildContext context, ) async {
    if (!_globalKey.currentState!.validate()) return;

    if (_passNuevaController.text.toString() !=
        _confirmarPassNuevaController.text.toString()) {
          mostrarSnackBar('Las contraseñas no coinciden');
        }

    setState(() {
      responseSuccessServer = true;
    });
    print('response: $responseMessageServer');
    student.password = _passNuevaController.text.toString();
    student.password2 = _confirmarPassNuevaController.text.toString();


    final respuesta = await userProvider.editPerfil(student);
    if (respuesta['success'] == true) {
        mostrarSnackBar(respuesta['message']);
        _passNuevaController.text = '';
        _confirmarPassNuevaController.text = '';
        setState(() {
          responseSuccessServer = false;
        });
    }else{
      responseMessageServer = respuesta['message'];
      mostrarSnackBar(respuesta['message']);
      setState(() {
          responseSuccessServer = false;
        });
    }
    }
  
  _createButtonEditStudent() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            elevation: const MaterialStatePropertyAll(5.0),
            backgroundColor: const MaterialStatePropertyAll(
              Color.fromRGBO(53, 80, 112, 1.0),
            ),
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
          ),
          child: Text('Guardar'.toUpperCase()),
         onPressed: () => _editDataOfStudent(context),
        );
      },
    );
  }
  
  

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje, style: TextStyle(fontWeight: FontWeight.bold),),
      duration: const Duration(milliseconds: 1800),
      backgroundColor: const Color.fromRGBO(29, 53, 87, 1.0),
      
      
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
