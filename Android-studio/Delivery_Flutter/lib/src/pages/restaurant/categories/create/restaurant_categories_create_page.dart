import 'package:delivery_flutter/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantCategoriesCreatePage extends StatelessWidget {
  RestaurantCategoriesCreateController con=Get.put(RestaurantCategoriesCreateController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(//POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _textNewCategory(context),

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
            _textFieldDescription(),
            _buttonCreate(context)
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
            prefixIcon: Icon(Icons.category)
        ),
      ),
    );
  }

  Widget _textFieldDescription(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40 ,vertical:30 ),
      child: TextField(
         controller:con.descriptionController,
        keyboardType: TextInputType.text,
        maxLines: 4,
        decoration: InputDecoration(
            hintText: 'Descripción',
            prefixIcon: Container(
                margin: EdgeInsets.only(bottom: 50),
                child: Icon(Icons.description))
        ),

      ),
    );
  }



  Widget _buttonCreate (BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 10),
      child: ElevatedButton(
          onPressed: () => con.createCategory() ,
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)

          ) ,
          child: Text(
            'CREAR CATEGORIA',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }


  Widget _textNewCategory(BuildContext context){

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        alignment:Alignment.topCenter ,
        child: Column(
          children: [
            Icon(Icons.category,size: 100,color:Colors.white ,),
            Text('Nueva Categoria',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
        'INGRESA TU INFORMACIÓN',
        style: TextStyle(
            color: Colors.black
        ),
      ),
    );
  }
}
