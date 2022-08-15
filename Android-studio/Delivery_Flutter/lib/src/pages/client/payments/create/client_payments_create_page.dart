import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'client_payments_create_controller.dart';

class ClientPaymentsCreatePage extends StatelessWidget {


  ClientPaymentsCreateController con = Get.put(ClientPaymentsCreateController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: _buttonNext(context),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          'No Olvides Pagar En Efectivo',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/gracias_por_su_compra.png',
              height: 350,
              width: 375,
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
    _buttonNext(context);
  }


  Widget _buttonNext(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
          onPressed: () => con.createCardToken(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'CONTINUAR',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }

}
