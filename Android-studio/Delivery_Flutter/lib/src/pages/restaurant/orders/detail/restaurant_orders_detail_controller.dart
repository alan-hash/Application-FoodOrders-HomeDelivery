import 'package:delivery_flutter/src/models/response_api.dart';
import 'package:delivery_flutter/src/providers/orders_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../../models/order.dart';
import '../../../../models/user.dart';
import '../../../../providers/users_provider.dart';

class RestaurantOrdersDetailController extends GetxController{

  Order order = Order.fromJson(Get.arguments['order']);

  var total = 0.0.obs;
  var idDelivery = ''.obs;

  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;


  RestaurantOrdersDetailController(){
    print('Order: ${order.toJson()}');
    getDeliveryMen();
    getTotal();
  }

  void updateOrder() async {
    if(idDelivery.value != ''){ // Si selecciono el repartidor
      order.idDelivery = idDelivery.value;
      ResponseApi responseApi = await ordersProvider.updateToDispatched(order);
      Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
      if(responseApi.success == true){
        Get.offNamedUntil('/restaurant/home', (route) => false);
      }
    }
    else{
      Get.snackbar('Petición Denegada', 'Debes asignar el repartidor');
    }
  }

  void getDeliveryMen() async{
    var result = await usersProvider.findDeliveryMen();
    users.clear();
    users.addAll(result);
  }

  void getTotal(){
    total.value = 0.0;
    order.products!.forEach((product) {
      total.value = total.value + (product.quantity! * product.price!);
    });
  }

}