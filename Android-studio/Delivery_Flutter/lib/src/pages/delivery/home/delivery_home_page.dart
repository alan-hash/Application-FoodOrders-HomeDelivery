import 'package:delivery_flutter/src/pages/client/home/client_home_controller.dart';
import 'package:delivery_flutter/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:delivery_flutter/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:delivery_flutter/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:delivery_flutter/src/pages/restaurant/home/restaurant_home_controller.dart';
import 'package:delivery_flutter/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:delivery_flutter/src/utils/custom_animated_bottom_bar.dart';
import 'package:delivery_flutter/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:delivery_flutter/src/pages/delivery/orders/list/delivery_orders_list_page.dart';

import 'delivery_home_controller.dart';



class DeliveryHomePage extends StatelessWidget {

  DeliveryHomeController con = Get.put(DeliveryHomeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        bottomNavigationBar: _bottomBar(),
        body: Obx(() => IndexedStack(
          index: con.indexTab.value,
          children: [
            DeliveryOrdersListPage(),
            ClientProfileInfoPage()
          ],
        ))
    );
  }

  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Colors.deepOrange,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      selectedIndex: con.indexTab.value,
      onItemSelected: (index) => con.changeTab(index),
      items: [
        BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text('Pedidos'),
            activeColor: Colors.white,
            inactiveColor: Colors.black
        ),

        BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Perfil'),
            activeColor: Colors.white,
            inactiveColor: Colors.black
        ),
      ],
    ));
  }

}