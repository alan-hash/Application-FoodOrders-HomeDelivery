import 'dart:convert';
import 'dart:io';
import 'package:delivery_flutter/src/models/response_api.dart';
import 'package:delivery_flutter/src/models/user.dart';
import 'package:delivery_flutter/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:delivery_flutter/src/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientProfileUpdateController extends GetxController{

  User user=User.fromJson(GetStorage().read('user'));


  TextEditingController nameController= TextEditingController();
  TextEditingController lastnameController= TextEditingController();
  TextEditingController phoneController= TextEditingController();

  ImagePicker picker =ImagePicker();
  File? imageFile;

  UsersProvider usersProvider=UsersProvider();
  ClientProfileInfoController clientProfileInfoController=Get.find();



  ClientProfileUpdateController(){
    nameController.text=user.name ?? '';
    lastnameController.text=user.lastname ?? '';
    phoneController.text=user.phone ??'' ;

  }

  void updateInfo(BuildContext context) async {
    String name=nameController.text;
    String lastname=lastnameController.text;
    String phone=phoneController.text;


    if(isValidForm(name, lastname, phone)){
      ProgressDialog progressDialog= ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Actualizando datos....');


      User myUser=User(
          id:user.id ,
          name:name,
          lastname:lastname,
          phone:phone,
          sessionToken:user.sessionToken

      );

      if(imageFile==null){
        ResponseApi  responseApi=await usersProvider.update(myUser);
        print('Response Api Update: ${responseApi.data}');
        Get.snackbar('Proceso terminado', responseApi.message??'');

        progressDialog.close();
        if(responseApi.success==true){
          GetStorage().write('user', responseApi.data);
          clientProfileInfoController.user.value=User.fromJson(responseApi.data);
        }
      }
      else{
        Stream stream = await usersProvider.updateWithImage(myUser, imageFile!);
        stream.listen((res) {

          progressDialog.close();
          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
          Get.snackbar('Proceso terminado', responseApi.message??'');


          print('Response Api Update: ${responseApi.data}');

          if (responseApi.success == true) {
            GetStorage().write('user', responseApi.data);
            clientProfileInfoController.user.value=User.fromJson(responseApi.data);
          }
          else {
            Get.snackbar('Registro fallido', responseApi.message ?? '');
          }

        });
      }


      // Stream stream = await usersProvider.createWithImage(user, imageFile!);
      // stream.listen((res) {
      //
      //   progressDialog.close();
      //   ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      //
      //   if (responseApi.success == true) {
      //     GetStorage().write('user', responseApi.data);//datos de usuario
      //     goToHomePage();
      //
      //   }
      //   else {
      //     Get.snackbar('Registro fallido', responseApi.message ?? '');
      //   }
      //
      // });

    }
  }


  bool isValidForm(
      String name,
      String lastname,
      String phone

      ){

    if (name.isEmpty){
      Get.snackbar('Formulario no valido', 'Debes de ingresar tu nombre');
      return false;
    }

    if (lastname.isEmpty){
      Get.snackbar('Formulario no valido', 'Debes de ingresar tu apellido');
      return false;
    }

    if (phone.isEmpty){
      Get.snackbar('Formulario no valido', 'Debes de ingresar tu numero telefonico');
      return false;
    }


    return true;
  }


  Future selectImage(ImageSource imageSource ) async{
    XFile? image =await picker.pickImage(source: imageSource);
    if(image != null){
      imageFile =File(image.path);
      update();
    }

  }



  void showAlertDialog(BuildContext context){
    Widget gallaryButton=ElevatedButton(
        onPressed:(){
          Get.back();
          selectImage(ImageSource.gallery);
        },
        child: Text('Galeria',
          style: TextStyle(
              color: Colors.black
          ),
        )
    );

    Widget cameraButton =ElevatedButton(
        onPressed:(){
          Get.back();
          selectImage(ImageSource.camera);
        },
        child: Text(
          'Camara',
          style: TextStyle(
              color: Colors.black
          ),
        )
    );

    AlertDialog alertDialog= AlertDialog(
      title:Text('Seleciona una opcion'),
      actions: [
        gallaryButton,
        cameraButton
      ],
    );
    showDialog(context: context, builder: (BuildContext context){
      return alertDialog;

    });

  }

}