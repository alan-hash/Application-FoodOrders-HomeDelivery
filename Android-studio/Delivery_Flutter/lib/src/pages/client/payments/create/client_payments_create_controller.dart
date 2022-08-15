import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class ClientPaymentsCreateController extends GetxController {


  void createCardToken() async {
    GetStorage().remove('shopping_bag');
    Get.toNamed('/client/home');
    }




}