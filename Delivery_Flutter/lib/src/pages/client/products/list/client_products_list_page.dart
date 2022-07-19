import 'package:delivery_flutter/src/models/category.dart';
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

    return DefaultTabController(
      length: con.categories.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:Size.fromHeight(70),
          child:AppBar(
            bottom:TabBar(
              isScrollable: true,
              indicatorColor: Colors.deepOrange,
              labelColor:Colors.black ,
              unselectedLabelColor:Colors.white,
              tabs: List<Widget>.generate(con.categories.length, (index){
                return Tab(
                  child: Text(con.categories[index].name ?? ''),
                );
              }),

            ),
          ),
        ) ,
          body:TabBarView(
            children: con.categories.map((Category category){
              return Container();
            }).toList(),
          )
      ),
    );
  }

}