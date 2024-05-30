import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yummygood/db/dbservice.dart';
import 'package:yummygood/displays/categories.dart';
import 'package:yummygood/displays/mainpage.dart';
import 'package:yummygood/displays/orderdetail.dart';
import 'package:yummygood/displays/person.dart';
import 'dart:developer' as developer;

import 'package:yummygood/displays/viewcart.dart';

class OrdersPage extends StatefulWidget{
  final String restaurantId;
  OrdersPage(this.restaurantId);

  @override
  State<OrdersPage> createState() => OrdersState();
}

class OrdersState extends State<OrdersPage>{
  List<Widget> orderItems = [];

  Future<dynamic> getOrderInfo() async {
    final db = await DatabaseService().getDatabase();
    final orders = [];

    final ordersObj = await db.rawQuery("SELECT * FROM Orders WHERE restaurant_id = ${widget.restaurantId}");
    for (dynamic order in ordersObj) {
      int quantity = 0;
      final orderItemObj = await db.rawQuery("SELECT * FROM OrderItem WHERE order_id = ${order["order_id"].toString()}");
      final userObj = await db.rawQuery("SELECT * FROM Users WHERE email = '${order["email"].toString()}'");

      for (dynamic item in orderItemObj) {
        quantity += int.parse(item["quantity"].toString());
      }

      orders.add({quantity: order, "address": userObj[0]["address"].toString()});
    }
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF4500),
        toolbarHeight: 50,
        leading: IconTheme(
            data: const IconThemeData(color: Colors.white),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back))),
      ),
      backgroundColor: const Color(0xFFFFEABF),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFFF4500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MainPage()),
                        (route) => false);
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CategoriesPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PersonPage()));
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              orderItems.clear();
              orderItems.add(SizedBox(height: 10));
              orderItems.add(Align(
                  alignment: Alignment.center,
                  child: Text("Orders", style: const TextStyle(fontSize: 20))));
              orderItems.add(SizedBox(height: 10));

              final orders = snapshot.data;
              for (dynamic order in orders) {
                orderItems.add(GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailPage(order.values.toList()[0]["order_id"])));
                    },
                    child: OrderItem(order)));
              }

              return Center(
                  child: ListView(children: orderItems));
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
        future: getOrderInfo(),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final dynamic order;
  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    DateTime dtObject = DateTime.parse(order.values.toList()[0]["time"].toString());
    return Column(
      children: [
        Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
            ),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer: ${order.values.toList()[0]["email"]}",
                            style: const TextStyle(fontSize: 15)),
                        Text("Items: ${order.keys.toList()[0]}"),
                        Text(
                            "Ordered ${dtObject.day}/${dtObject.month}/${dtObject.year} at ${dtObject.hour}:${dtObject.minute}"),
                        Text("Address: ${order["address"]}") // Display the customer's address
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            )),
        const SizedBox(height: 20)
      ],
    );
  }
}
