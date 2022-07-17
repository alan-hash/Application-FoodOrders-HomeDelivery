import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:delivery_flutter/src/environment/environment.dart';
import 'package:delivery_flutter/src/models/response_api.dart';
import 'package:delivery_flutter/src/models/user.dart';
import 'package:get/get.dart';

class UsersProvider extends GetConnect{
  String url= Environment.API_URL + 'api/users';


  Future<Response>create(User user) async{
    Response response=await post(
        '$url/create',
        user.toJson(),
        headers: {
          'Content-Type':'application/json'
        }
    );
    return response;
  }

//Actualizar sin  Imagen
  Future<ResponseApi>update(User user) async{
    Response response=await put(
        '$url/updateWithoutImage',
        user.toJson(),
        headers: {
          'Content-Type':'application/json'
        }
    );

    if(response.body==null){
      Get.snackbar('Error', 'No se pudo actualizar la informacion');
      return ResponseApi();
    }

    ResponseApi responseApi=ResponseApi.fromJson(response.body);

    return responseApi;
  }


  Future<Stream> createWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/createWithImage');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(),
        filename: basename(image.path)
    ));
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }



  Future<Stream> updateWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/update');
    final request = http.MultipartRequest('PUT', uri);
    request.files.add(http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(),
        filename: basename(image.path)
    ));
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }



  Future<ResponseApi>login(String email,String password) async{
    Response response=await post(
        '$url/login',
        {
          'email':email,
          'password':password
        },
        headers: {
          'Content-Type':'application/json'
        }
    );
    if(response.body==null){
      Get.snackbar('Error', 'No se pudo ejecutar la petición');
      return ResponseApi();
    }
    ResponseApi responseApi =ResponseApi.fromJson(response.body);
    return responseApi;
  }





}