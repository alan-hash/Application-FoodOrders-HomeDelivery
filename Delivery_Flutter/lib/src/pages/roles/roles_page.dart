import 'package:delivery_flutter/src/environment/environment.dart';
import 'package:delivery_flutter/src/models/Rol.dart';
import 'package:delivery_flutter/src/pages/roles/roles_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RolesPage extends StatelessWidget {
  RolesController con =Get.put(RolesController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Selecionar el rol',
        style: TextStyle(
          color: Colors.black

        ),


        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.12),
        child: ListView(
          children:con.user.roles !=null? con.user.roles!.map((Rol rol){
            return _carRol(rol);
          }).toList():[],
        ),
      ),
    );
  }

  Widget _carRol(Rol rol){
    return  GestureDetector(
      onTap:()=> con.goToPageRol(rol),

      child: Column(
        children: [
          Container(//imagen
            margin:EdgeInsets.only(bottom: 20) ,


            height:120,
            child: FadeInImage(
              image: NetworkImage(rol.image!),
              fit: BoxFit.contain,
              fadeInDuration:Duration(milliseconds :50) ,
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ),
          Text(
            rol.name??'',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
          )
        ],
      ),
    );
  }

}
