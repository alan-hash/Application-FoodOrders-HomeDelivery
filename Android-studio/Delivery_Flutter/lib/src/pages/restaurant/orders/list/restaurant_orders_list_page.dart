import 'package:delivery_flutter/src/models/order.dart';
import 'package:delivery_flutter/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:delivery_flutter/src/utils/relative_time_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/no_data_widget.dart';


class RestaurantOrdersListPage extends StatelessWidget {
  RestaurantOrdersListController con = Get.put(RestaurantOrdersListController());


  @override
  Widget build(BuildContext context) {

    return  Obx(()=>DefaultTabController(
      length: con.status.length,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize:Size.fromHeight(110),
            child:AppBar(
              bottom:TabBar(
                isScrollable: true,
                indicatorColor: Colors.deepOrange,
                labelColor:Colors.black ,
                unselectedLabelColor:Colors.white,
                tabs: List<Widget>.generate(con.status.length, (index){
                  return Tab(
                    child: Text(con.status[index]),
                  );
                }),
              ),
            ),
          ) ,
          body:TabBarView(
            children: con.status.map((String status){
              return FutureBuilder(
                  future: con.getOrders(status),
                  builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0) {
                        return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardOrder(snapshot.data![index]);
                            }
                        );
                      }
                      else {
                        return Center(child: NoDataWidget(text: 'No hay ordenes'));
                      }
                    }
                    else {
                      return Center(child: NoDataWidget(text: 'No hay ordenes'));
                    }
                  }
              );
            }).toList(),
          )
      ),
    ));
  }

  Widget _cardOrder(Order order){
    return GestureDetector(
      onTap: ()=> con.goToOrderDetail(order),
      child: Container(
        height: 150,
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            children: [
              Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    'Orden #${order.id}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Text('Pedido: ${RelativeTimeUtil.getRelativeTime(order.timestamp ?? 0)}')
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Text('Cliente: ${order.client?.name ?? ''}')
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Text('Entregar en: ${order.address?.address ?? ''}')
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
