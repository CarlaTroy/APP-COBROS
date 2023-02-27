import 'package:cobros/models/paymentEnrollement.model.dart';
import 'package:cobros/providers/payment.provider.dart';
import 'package:flutter/material.dart';

class ItemPayment extends StatefulWidget {
  
  @override
  State<ItemPayment> createState() => _ItemPaymentState();
} 

class _ItemPaymentState extends State<ItemPayment> {

  List<PaymentEnrollementModel> _listOfPayments = [];
    int idEnrollement = 0;
    String titleHead = '';
    String subtitleHeadHead = 'Pensiones';

  getPayment(String idEnrollement){
  paymentProvider.getPayments(idEnrollement).then((payments){
  setState(() {
    _listOfPayments = payments;
    titleHead = payments[0].enrollement!.cohorte!.name.toString();
    
  });

  });
  }

PaymentProvider paymentProvider = PaymentProvider();



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        setState(
          () {
            final contratoObtenido = ModalRoute.of(context)!.settings.arguments;
            final primero = contratoObtenido.toString().replaceFirst('{', '');
            print('res: $primero');
            getPayment(primero.toString());
          },
        );
      },
    );
    
  }


  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagos del estudiante'),
      ),
      body: Card(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                //searchField(),
                Text(titleHead, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Text(subtitleHeadHead, style: TextStyle(fontSize: 15),textAlign: TextAlign.left,),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Cuota', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text('Fecha de pago', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 40),
                      child: Text('Monto', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 50),
                      child: Text('Estado', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Expanded(
                  child: _listOfPayments.length>0? 
                  ListView.builder(
                  itemCount: _listOfPayments.length,
                  itemBuilder: (context, index) {
                    return _cardInformation(_listOfPayments, index);
                  })
                  :
                   Container())
              ],
            ),
          ),
        ),
      )
          
          
    );
  }

  _cardInformation(List<PaymentEnrollementModel> listOfPayments, int index){
    return Center(
      child: Center(
        child: Container(
          height: 80,
          child: Card(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                        Text((index+1).toString()),
                        Text(listOfPayments[index].datePay!.year.toString()+'-'+listOfPayments[index].datePay!.month.toString()+'-'+listOfPayments[index].datePay!.day.toString()),
                        Text('\$${listOfPayments[index].amount.toString()}'),
                        _listOfPayments[index].statusPay!.name =='NO PAGADO'?
                        SizedBox(
                          width: 100,
                          child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () { },
                          child: Text(_listOfPayments[index].statusPay!.name.toString(), style: TextStyle(color: Colors.white),),
                        ),
                        )
                        :
                        SizedBox(
                          width: 100,
                          child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () { },
                          child: Text(_listOfPayments[index].statusPay!.name.toString(), style: TextStyle(color: Colors.white),),
                        ),
                        )
                        
                       ],
                     )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}