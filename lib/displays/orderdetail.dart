import 'package:flutter/material.dart';
import 'package:yummygood/db/dbservice.dart';
import 'package:yummygood/displays/categories.dart';
import 'package:yummygood/displays/mainpage.dart';
import 'package:yummygood/displays/person.dart';
import 'dart:developer' as developer;

class OrderDetailPage extends StatefulWidget{

  int orderId;
  OrderDetailPage(this.orderId);

  @override
  State<OrderDetailPage> createState() => OrderDetailState();
}

class OrderDetailState extends State<OrderDetailPage>{

  List<Widget> orderItems = [];

  Future<dynamic> getOrderItems() async{
    final db = await DatabaseService().getDatabase();
    final items = [];
    final orderItems = await db.rawQuery("SELECT * FROM OrderItem WHERE order_id = ${widget.orderId}");

    for (dynamic orderItem in orderItems){
      Map<String, Object?> itemInfo = (await db.rawQuery("SELECT * FROM MenuItem WHERE item_id = ${orderItem["item_id"]}"))[0];
      items.add({orderItem["quantity"]: itemInfo});
    }

    return items;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF4500),
        toolbarHeight:50,
        leading: IconTheme(data: const IconThemeData(color:Colors.white), child:IconButton(onPressed: (){Navigator.pop(context);}, icon:const Icon(Icons.arrow_back))),
      ),
      backgroundColor: const Color(0xFFFFEABF),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFFF4500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(icon:const Icon(Icons.home), onPressed: (){Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainPage()), (route) => false);},),
            IconButton(icon:const Icon(Icons.search), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesPage()));},),
            IconButton(icon:const Icon(Icons.person), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => PersonPage()));},),
          ],
        )
      ),
      body: Center(
        child: FutureBuilder(
          builder:(context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done){
              if (snapshot.hasData){
                final items = snapshot.data;
                orderItems.clear();
                orderItems.add(SizedBox(height:10));
                orderItems.add(Align(alignment:Alignment.center, child: Text("Order Details",style: const TextStyle(fontSize:20))));
                orderItems.add(SizedBox(height:10));


                for (dynamic item in items){
                  orderItems.add(OrderItem(item));
                }
              }

              return Center(
                child: ListView(
                  children: orderItems
                )
              );
            }
            return const Center(child:CircularProgressIndicator());
          },
          future: getOrderItems(),
        )
      )
    );
  }
}

class OrderItem extends StatelessWidget{

  dynamic orderItem;
  OrderItem(this.orderItem);

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width:1, color: Colors.grey)),
          ),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  SizedBox(width:10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orderItem.values.toList()[0]["name"].toString(), style:const TextStyle(fontSize:15)),
                      Text("\$${orderItem.values.toList()[0]["price"].toString()}"),
                      Text("Quantity: ${orderItem.keys.toList()[0].toString()}")
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration:BoxDecoration(
                      color:Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width:1)),
                      width:100,
                      height:100,
                      child: Image.network(orderItem.values.toList()[0]["picture_url"].toString(),
                        fit:BoxFit.cover
                  )),
                ],
              ),
              const SizedBox(height:10),
            ],
          )
        ),
        const SizedBox(height:20)
      ],
    );
  }
}