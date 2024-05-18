import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:yummygood/db/dbservice.dart';
import 'package:yummygood/db/userservice.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as developer;

class ViewCartPage extends StatefulWidget{
  String restaurantId;
  ViewCartPage(this.restaurantId);

  @override
  State<ViewCartPage> createState() => ViewCartState();
}

class ViewCartState extends State<ViewCartPage>{
  
  List<Widget> cartItemsList = [];

  Future<dynamic> getCart() async{
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();
    UserService userService = UserService();

    final cart = await db.rawQuery("SELECT * FROM CartItem WHERE restaurant_id = ${widget.restaurantId} AND email = '${userService.getUser()!.email}'");
    final restaurantName = await db.rawQuery("SELECT * FROM Restaurant WHERE restaurant_id = ${cart[0]["restaurant_id"]}");
    dynamic itemInfoList = [];

    for (Map<String, Object?> cartItem in cart){
      final itemInfo = await db.rawQuery("SELECT * FROM MenuItem WHERE item_id = ${cartItem["item_id"]}");
      itemInfoList.add({"cart_info": cartItem, "item_info": itemInfo[0]});
    }
    return {restaurantName[0]["name"].toString():itemInfoList};
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
            IconButton(icon:const Icon(Icons.home), onPressed: (){},),
            IconButton(icon:const Icon(Icons.search), onPressed: (){},),
            IconButton(icon:const Icon(Icons.food_bank), onPressed: (){},),
            IconButton(icon:const Icon(Icons.person), onPressed: (){},),
          ],
        )
      ),
      body: FutureBuilder(
        builder:(context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasData){
              cartItemsList.clear();
              cartItemsList.add(Align(alignment:Alignment.center, child: Text("${snapshot.data.keys.toList()[0].toString()} Cart",style: const TextStyle(fontSize:25))));

              
              final items = snapshot.data.values.toList()[0];
              double totalCost = 0;

              for (dynamic item in items){
                cartItemsList.add(CartItem([item["item_info"]["name"].toString(), item["item_info"]["price"].toString(), item["cart_info"]["quantity"].toString(), item["item_info"]["picture_url"]]));
                double price = item["item_info"]["price"] as double;
                int quantity = item["cart_info"]["quantity"] as int;

                totalCost = totalCost + price * quantity;
              }
              
              cartItemsList.add(Align(alignment:Alignment.center, child: Text("Total Cost: \$${totalCost}",style: const TextStyle(fontSize:25))));

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height:10),
                    SizedBox(
                        height: 700,
                        width:380,
                        child: ListView(
                          children: cartItemsList,
                        ),
                    ),
                  ]
                )
              );
            }
          }
          return const Center(child: CircularProgressIndicator());

        },
        future: getCart()
      )
    );
  }
}

class CartItem extends StatelessWidget{

  List<String> cartItem;
  CartItem(this.cartItem);
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
                  Column(
                    children: [
                      Text(cartItem[0].toString(), style:const TextStyle(fontSize:15)),
                      Text("\$${cartItem[1].toString()}"),
                      Text("Quantity: ${cartItem[2]}")
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
                      child: Image.network(cartItem[3].toString(), 
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