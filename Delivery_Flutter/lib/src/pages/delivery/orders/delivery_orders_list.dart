import 'package:delivery_flutter/src/pages/delivery/orders/delivery_orders_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOrdersListPage extends StatelessWidget {
  DeliveryOrdersListController con = Get.put(DeliveryOrdersListController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Delivery order list'),
      ),

    );
  }
}
