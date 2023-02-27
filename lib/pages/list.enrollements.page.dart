import 'dart:async';
import 'dart:convert';

import 'package:cobros/config/preferenciasUsuario.dart';
import 'package:cobros/config/utils.dart';
import 'package:cobros/pages/login.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListadoEnrollementPage extends StatefulWidget {
  const ListadoEnrollementPage({super.key});

  @override
  State<ListadoEnrollementPage> createState() => _ListadoEnrollementPageState();
}

class _ListadoEnrollementPageState extends State<ListadoEnrollementPage> {
  final styleTitle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);
  late ScrollController _scrollController;
  final preferences = UserPreferences();
  List<dynamic> listOfEnrollement = [];
  int _lengthOfEnrollement = 0;
  final String _url = URLBASE;

  String responseServer = '';
  bool responseServerForCircularProgress = true;

  int count = 0;


  Future<void> verifyTokenPreference() async {
    if (preferences.token.isEmpty) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      print('bien');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    verifyTokenPreference();

    _scrollController = ScrollController();
    getNewEnrollements();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          (_scrollController.position.maxScrollExtent)) {
        getNewEnrollements();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    print('Dispose...');
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        //drawer: MenuWidget(),
        body: (listOfEnrollement.length > 0)
            ? Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: RefreshIndicator(
                        onRefresh: getInitialRegistersOfEnrollements,
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: listOfEnrollement.length,
                            itemBuilder: (context, index) {
                              return _createItemEnrollement(
                                  context, listOfEnrollement, index);
                              //print(inn.servicio);
                            }),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Curso',
                              style: styleTitle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(
                              'Cohorte',
                              style: styleTitle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Text('Cuotas \n pendientes',style: styleTitle, textAlign: TextAlign.center,)
                        ],
                      ),
                    ),
                  ),
                ],
                
              )
            : Center(
                child: Container(
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                         
                         responseServerForCircularProgress?CircularProgressIndicator():Container(),
                          SizedBox(
                            height: 30.0,
                          ),
                          Image(image: AssetImage('assets/img/notfound.png',), ),
                           SizedBox(
                            height: 20.0,
                          ),
                          Text(responseServer, style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 70, 93, 126), fontWeight: FontWeight.bold),)
                        ],
                      ),
                    )),
              ));
  }


  _createItemEnrollement(BuildContext context, List<dynamic> listOfEnrollement, int index) {
    
    return SafeArea(
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, 'itempayment', arguments: listOfEnrollement[index][index]['id']);
                    },
                    child: ListTile(
                      leading: Text(
                      listOfEnrollement[index][index]['cohorte']['course']['name'].toString(),
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                      title: Text(
                      listOfEnrollement[index][index]['cohorte']['name'].toString(),
                      style: TextStyle(fontSize: 12,),
                      textAlign: TextAlign.center,
                    ),
                      trailing: Text(
                        listOfEnrollement[index][index]['cuotas']
                            .toString(),
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  

  void mostrarSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 2500),
      backgroundColor: Color.fromARGB(255, 70, 93, 126),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  _fetchDataOfEnrollements() async {
    final url = '$_url/api/students-enrrollement-id/${preferences.idEstudiante}';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        //'Authorization': 'Token ${preferences.token}'
      },
    );
  if(json.decode(response.body)['data'].length==0){
     setState(() {
      responseServerForCircularProgress = false;
       responseServer = json.decode(response.body)['message'].toString();
     });
    return;
  }

    if (response.statusCode == 200) {
      _lengthOfEnrollement = json.decode(response.body)['data'].length;
      if (mounted)
      
        setState(() {
          if (listOfEnrollement.length < _lengthOfEnrollement) {
            listOfEnrollement.add(json.decode(response.body)['data']);
          } else {
            return;
          }
        });
    } else {
      responseServer = json.decode(response.body)['message'];
      return false;
    }
  }

  getNewEnrollements() {
    
    for (var i = 0; i < 20; i++) {
      
      if (listOfEnrollement.length <= _lengthOfEnrollement) {
        _fetchDataOfEnrollements();
      } else {
        return;
      }
      print(_lengthOfEnrollement);
      if(!responseServerForCircularProgress){
      return;
    }
    }
    
  }

  Future<Null> getInitialRegistersOfEnrollements() async {
    final duration = new Duration(seconds: 2);
    new Timer(duration, () {
      listOfEnrollement.clear();
      _lengthOfEnrollement = 0;
      getNewEnrollements();
    });

    return Future.delayed(duration);
  }
}
