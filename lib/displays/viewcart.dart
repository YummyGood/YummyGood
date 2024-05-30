import 'package:flutter/material.dart';
import 'package:yummygood/db/dbservice.dart';
import 'package:yummygood/db/userservice.dart';
import 'package:sqflite/sqflite.dart';
import 'mainpage.dart';
import 'categories.dart';
import 'person.dart';
import 'payment_page.dart';

class ViewCartPage extends StatefulWidget {
  final String restaurantId;
  ViewCartPage(this.restaurantId);

  @override
  State<ViewCartPage> createState() => ViewCartState();
}

class ViewCartState extends State<ViewCartPage> {
  List<Widget> cartItemsList = [];
  double deliveryFee = 0.0;

  Future<dynamic> getCart() async {
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();
    UserService userService = UserService();

    final cart = await db.rawQuery(
        "SELECT * FROM CartItem WHERE restaurant_id = ${widget.restaurantId} AND email = '${userService.getUser()!.email}'");
    final restaurantData = await db.rawQuery(
        "SELECT * FROM Restaurant WHERE restaurant_id = ${widget.restaurantId}");
    dynamic itemInfoList = [];

    if (restaurantData.isNotEmpty) {
      deliveryFee = restaurantData[0]["delivery_fee"] as double;
    }

    for (Map<String, Object?> cartItem in cart) {
      final itemInfo = await db.rawQuery(
          "SELECT * FROM MenuItem WHERE item_id = ${cartItem["item_id"]}");
      itemInfoList.add({"cart_info": cartItem, "item_info": itemInfo[0]});
    }
    return {restaurantData[0]["name"].toString(): itemInfoList};
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
          )),
      body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                cartItemsList.clear();
                cartItemsList.add(Align(
                    alignment: Alignment.center,
                    child: Text(
                        "${snapshot.data.keys.toList()[0].toString()} Cart",
                        style: const TextStyle(fontSize: 25))));

                final items = snapshot.data.values.toList()[0];
                double totalCost = 0;

                for (dynamic item in items) {
                  cartItemsList.add(CartItem([
                    item["item_info"]["name"].toString(),
                    item["item_info"]["price"].toString(),
                    item["cart_info"]["quantity"].toString(),
                    item["item_info"]["picture_url"],
                    item["item_info"]["item_id"].toString(),
                    widget.restaurantId
                  ]));
                  double price = item["item_info"]["price"] as double;
                  int quantity = item["cart_info"]["quantity"] as int;

                  totalCost = totalCost + price * quantity;
                }

                if (items.isNotEmpty) {
                  totalCost += deliveryFee; // Add delivery fee to total cost

                  cartItemsList.add(Align(
                      alignment: Alignment.center,
                      child: Text(
                          "Total Cost (incl. delivery): \$${totalCost.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 25))));

                  cartItemsList.add(Align(
                      alignment: Alignment.center,
                      child: TextButton(
                          child: const Text("Order"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PaymentPage(totalAmount: totalCost, deliveryFee: deliveryFee, restaurantId: widget.restaurantId), // Pass deliveryFee and restaurantId
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4500),
                            foregroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            splashFactory: NoSplash.splashFactory,
                          ))));
                } else {
                  cartItemsList.add(
                    const Align(
                      alignment: Alignment.center,
                      child: Text("Your cart is empty!"),
                    ),
                  );
                }

                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 700,
                            width: 380,
                            child: ListView(
                              children: cartItemsList,
                            ),
                          ),
                        ]));
              } else {
                return const Center(child: Text("Your cart is empty!"));
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
          future: getCart()),
    );
  }
}

class CartItem extends StatelessWidget {
  final List<String> cartItem;
  CartItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cartItem[0].toString(),
                            style: const TextStyle(fontSize: 15)),
                        Text("\$${cartItem[1].toString()}"),
                        Text("Quantity: ${cartItem[2]}")
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          final quantity = int.parse(cartItem[2]);
                          DatabaseService dbService = DatabaseService();
                          Database db = await dbService.getDatabase();
                          if (quantity == 1) {
                            await db.execute(
                                "DELETE FROM CartItem WHERE item_id = ${cartItem[4]}");
                          } else {
                            await db.execute(
                                "UPDATE CartItem SET quantity = ${quantity - 1} WHERE item_id = ${cartItem[4]}");
                          }
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewCartPage(cartItem[5])));
                        }),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1)),
                        width: 100,
                        height: 100,
                        child: Image.network(
                          cartItem[3].toString(),
                          fit: BoxFit.cover,
                        )),
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
