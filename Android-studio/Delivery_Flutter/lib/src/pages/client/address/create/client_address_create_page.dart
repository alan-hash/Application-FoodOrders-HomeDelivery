import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'client_address_create_controller.dart';

class ClientAddressCreatePage extends StatelessWidget{

  ClientAddressCreateController con = Get.put(ClientAddressCreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(//POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _textNewAddress(context),
          _iconBack()
        ],
      ),
    );
  }

  Widget _iconBack(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 15),
        child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios, size: 30,)
        ),
      ),
    );
  }

  Widget _backgroundCover(BuildContext context){
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height *0.35,
      color:Colors.deepOrangeAccent,

    );
  }


  Widget _boxForm(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height * 0.30,left: 50, right: 50),
      decoration: BoxDecoration(
          color:Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(0,0.75)
            )
          ]
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _textFieldAddress(),
            _textFieldneighborhood(),
            _textFieldRefPoint(context),
            SizedBox(height: 20),
            _buttonCreate(context)
          ],
        ),
      ),
    );
  }


  Widget _textFieldAddress(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.addressController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Dirección',
            prefixIcon: Icon(Icons.location_on)
        ),
      ),
    );
  }

  Widget _textFieldneighborhood(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.neighborhoodController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Colonia',
            prefixIcon: Icon(Icons.location_city)
        ),
      ),
    );
  }

  Widget _textFieldRefPoint(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        onTap: () => con.openGoogleMaps(context),
        controller: con.refPointController,
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Punto de referencia',
            prefixIcon: Icon(Icons.map)
        ),
      ),
    );
  }



  Widget _buttonCreate (BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 10),
      child: ElevatedButton(
          onPressed: () {
            con.createAddress();
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'Crear Direccion',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }


  Widget _textNewAddress(BuildContext context){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        alignment:Alignment.topCenter ,
        child: Column(
          children: [
            Icon(Icons.location_on,size: 100),
            Text('Nueva Direccion',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textYourInfo(){
    return Container(
      margin: EdgeInsets.only(top: 40,bottom: 25),
      child: Text(
        'INGRESA TU INFORMACION',
        style: TextStyle(
            color: Colors.black
        ),
      ),
    );
  }
  
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}