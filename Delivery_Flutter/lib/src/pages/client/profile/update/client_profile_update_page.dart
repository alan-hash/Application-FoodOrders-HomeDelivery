import 'package:delivery_flutter/src/pages/client/profile/update/client_profile_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientProfileUpdatePage extends StatelessWidget {
  ClientProfileUpdateController con =Get.put(ClientProfileUpdateController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(//POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _imageUser(context),
          _buttomBack()
        ],
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


  Widget _buttomBack(){
    return SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: IconButton(
              onPressed: ()=>Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              )


          ),

        )
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
            _textFieldName(),
            _textFieldLastName(),
            _textFieldPhone(),
            _buttonUpdate(context)
          ],
        ),
      )
      ,
    );
  }


  Widget _textFieldName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Nombre',
            prefixIcon: Icon(Icons.person)
        ),

      ),
    );
  }

  Widget _textFieldLastName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller:con.lastnameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Apellido',
            prefixIcon: Icon(Icons.person_outline)
        ),

      ),
    );
  }

  Widget _textFieldPhone(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Telefono',
            prefixIcon: Icon(Icons.phone)
        ),

      ),
    );
  }



  Widget _buttonUpdate (BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 40),
      child: ElevatedButton(
          onPressed: () =>con.updateInfo(context),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)

          ) ,
          child: Text(
            'Actualizar',

            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }


  Widget _imageUser(BuildContext context){

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        alignment:Alignment.topCenter ,
        child: GestureDetector(
            onTap: ()=>con.showAlertDialog(context) ,
            child: GetBuilder<ClientProfileUpdateController>(
              builder: (value)=> CircleAvatar(
                backgroundImage:con.imageFile !=null
                    ? FileImage(con.imageFile!)
                    : con.user.image != null
                      ?NetworkImage(con.user.image!)
                      :AssetImage('assets/img/User_profile.png') as ImageProvider,
                radius: 70,
                backgroundColor: Colors.white,
              ),
            )
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
