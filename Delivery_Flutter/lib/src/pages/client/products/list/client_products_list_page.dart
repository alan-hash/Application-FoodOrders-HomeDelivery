import 'package:delivery_flutter/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:delivery_flutter/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/custom_animated_bottom_bar.dart';
import '../../../delivery/orders/delivery_orders_list.dart';

import '../../../restaurant/orders/list/restaurant_orders_list_page.dart';

class ClientProductsListPage extends StatelessWidget {
  ClientProductsListController con = Get.put(ClientProductsListController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        bottomNavigationBar: _bottomBar(),
        body: Obx(() => IndexedStack(
          index: con.indexTab.value,
          children: [
            RestaurantOrdersListPage(),
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
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Colors.white,
            inactiveColor: Colors.black
        ),
        BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text('Mis pedidos'),
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