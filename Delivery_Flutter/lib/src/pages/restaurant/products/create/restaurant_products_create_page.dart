import 'dart:io';

import 'package:delivery_flutter/src/models/category.dart';
import 'package:delivery_flutter/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:delivery_flutter/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantProductsCreatePage extends StatelessWidget {
  RestaurantProductsCreateController con=Get.put(RestaurantProductsCreateController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(()=> Stack(//POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _textNewCategory(context),

        ],
      )),
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
      height: MediaQuery.of(context).size.height * 0.70,
      margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height * 0.18,left: 50, right: 50),
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
            _textFieldPrice(),
            _dropDownCategories(con.categories),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<RestaurantProductsCreateController>(
                      builder: (value)=>_cardImage(context,con.imageFile1,1)
                  ),
                  SizedBox(width: 5),
                  GetBuilder<RestaurantProductsCreateController>(
                      builder: (value)=>_cardImage(context,con.imageFile2,2)
                  ),
                  SizedBox(width: 5),
                  GetBuilder<RestaurantProductsCreateController>(
                      builder: (value)=>_cardImage(context,con.imageFile3,3)
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),

            _buttonCreate(context)
          ],
        ),
      )
      ,
    );
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.amber,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          'Seleccionar categoria',
          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownItems(categories),
        value: con.idCategory.value == '' ? null : con.idCategory.value,
        onChanged: (option) {
          print('Opcion seleccionada ${option}');
          con.idCategory.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
      list.add(DropdownMenuItem(
        child: Text(category.name ?? ''),
        value: category.id,
      ));
    });

    return list;
  }



  Widget _cardImage(BuildContext context, File? imageFile,int numberFile){
    return GestureDetector(
        onTap: ()=> con.showAlertDialog(context, numberFile),
        child: Card(
          elevation: 3,
          child:Container(
            padding: EdgeInsets.all(10),
            height: 75,
            width: MediaQuery.of(context).size.width * 0.18,
            child: imageFile != null
            ? Image.file(
              imageFile,
              fit: BoxFit.cover,
            )
                :Image(
                image:AssetImage('assets/img/cover_image.png')
            )
          ),
        )
    );
  }


  Widget _textFieldName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Name',
            prefixIcon: Icon(Icons.category)
        ),
      ),
    );
  }

  Widget _textFieldPrice(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Precio',
            prefixIcon: Icon(Icons.attach_money)
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
            hintText: 'Descripcion',
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
          onPressed: () => con.createProduct(context),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)

          ) ,
          child: Text(
            'CREAR PRODUCTO',
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
        margin: EdgeInsets.only(top: 40),
        alignment:Alignment.topCenter ,
        child: Text('Nuevo Producto',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25
          ),

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
