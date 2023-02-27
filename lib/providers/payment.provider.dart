import 'dart:convert';
import 'dart:io';

import 'package:cobros/config/preferenciasUsuario.dart';
import 'package:cobros/config/utils.dart';
import 'package:cobros/models/paymentEnrollement.model.dart';
import 'package:http/http.dart' as http;

class PaymentProvider {
  final String _url = URLBASE;
  final preferenciaToken = UserPreferences();


  Future<List<PaymentEnrollementModel>> getPayments(String idEnrollement) async{
    
       final url = '$_url/api/payments/enrollement/$idEnrollement';
    final resp = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json",
      //'Authorization': 'Token ${preferenciaToken.token}'
      },
    );
   
    if(resp.statusCode == 200){
      
      List<PaymentEnrollementModel> listPayments = parsePayment(resp.body);
      return listPayments;
    }

    return [];
  }

  List<PaymentEnrollementModel> parsePayment(String responsePayment){
    final parsed = jsonDecode(responsePayment)['data'];
    return parsed.map<PaymentEnrollementModel>((json) => PaymentEnrollementModel.fromJson(json)).toList();
  }


 

}