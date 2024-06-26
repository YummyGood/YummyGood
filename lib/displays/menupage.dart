import 'package:flutter/material.dart';
import 'package:yummygood/db/userservice.dart';
import 'package:yummygood/displays/itempage.dart';
import 'package:yummygood/displays/viewcart.dart';
import 'package:yummygood/db/dbservice.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yummygood/displays/vieworders.dart';
import 'mainpage.dart';
import 'categories.dart';
import 'person.dart';
import 'edit.dart';

class MenuPage extends StatefulWidget{
  MenuPage(this.restaurantId);
  String restaurantId;

  @override
  State<MenuPage> createState() => MenuState();
}

class MenuState extends State<MenuPage>{

  List<Widget> menuItemsList = [];
  bool isEnabled = false;

  Future<dynamic> getMenuItems() async{
    UserService userService = UserService();
    isEnabled = userService.getUser()!.restId == widget.restaurantId;

    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();

    final data = await db.rawQuery("SELECT * FROM Restaurant WHERE restaurant_id = ${widget.restaurantId}");
    Map<String, Object?> restaurantData = data[0];
    final data2 = await db.rawQuery("SELECT * FROM MenuItem WHERE restaurant_id = ${widget.restaurantId}");

    Map<dynamic, dynamic> menuData = {restaurantData:data2};
    return menuData;
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
      body: FutureBuilder(
        builder:(context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasData){
              final restaurantInfo = snapshot.data.keys.toList()[0];
              final menuItems = snapshot.data.values.toList()[0];

              menuItemsList.clear();
              menuItemsList.add(const Text("Menu Items", style:TextStyle(fontSize:20)));
              menuItemsList.add(const SizedBox(height:20));
              for (Map<String, Object?> menuItem in menuItems){
                menuItemsList.add(GestureDetector(onTap:(){Navigator.push(context, MaterialPageRoute(builder: (builder) => ItemPage(menuItem["item_id"].toString())));},child: MenuItem(menuItem)));
              }

              menuItemsList.add(TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCartPage(restaurantInfo["restaurant_id"].toString())));
              },
                child: Text("View Cart", style:TextStyle(color:Colors.black)), 
                style:TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4500),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  splashFactory: NoSplash.splashFactory,
                )));
                
              menuItemsList.add(TextButton(onPressed: isEnabled ? (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage(restaurantInfo["restaurant_id"].toString())));
              } : null,
                child: Text("Orders", style:TextStyle(color:Colors.black)), 
                style:TextButton.styleFrom(
                  backgroundColor: isEnabled ? const Color(0xFFFF4500) : Colors.grey,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  splashFactory: NoSplash.splashFactory,
                )));


              return Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration:BoxDecoration(
                        border: Border.all(
                          color: Colors.black, 
                          width:1)), 
                        width:350, 
                        height:100, 
                        child: Image.network(restaurantInfo["picture_url"], 
                          fit:BoxFit.cover
                        )),
                        const SizedBox(height:20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${restaurantInfo["name"]} Menu", style:const TextStyle(fontSize: 20)),
                            IconButton(icon: Icon(Icons.edit), onPressed:isEnabled ? (){Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(restaurantInfo)));} : null),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBA174),
                                border: Border.all(color: const Color(0xFFE17533), width:1)
                              ),
                              child:SizedBox(
                                height: 50,
                                width:175,
                                child: Center(child: Text("\$${restaurantInfo["delivery_fee"]} delivery fee", style:const TextStyle(fontSize: 12)))
                              )
                            ),

                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBA174),
                                border: Border.all(color: const Color(0xFFE17533), width:1)
                              ),
                              child:SizedBox(
                                height: 50,
                                width:175,
                                child: Center(child: Text("${restaurantInfo["delivery_time"]} delivery time", style:const TextStyle(fontSize: 12)))
                              )
                            )
                          ],
                        ),

                        const SizedBox(height:20),
                        const Divider(color:Colors.black, indent: 15, endIndent: 15),

                        SizedBox(
                            height: 400,
                            width:380,
                            child: ListView(
                              children: menuItemsList,
                            ),
                          ),
                  ]
                ),
              );
            }
          }
          
          return const Center(
            child: CircularProgressIndicator()
          );
        },
        future: getMenuItems()
      )
    );
  }
}

class MenuItem extends StatelessWidget{

  Map<String, Object?> menuItem;
  MenuItem(this.menuItem);

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(child: Text(menuItem["name"].toString(), style:const TextStyle(fontSize:15))),
                      Text("\$${menuItem["price"].toString()}"),
                      Text(menuItem["description"].toString())
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
                      child: Image.network(menuItem["picture_url"].toString(), 
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