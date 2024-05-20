import 'package:flutter/material.dart';
import 'package:yummygood/db/dbservice.dart';
import 'package:yummygood/db/userservice.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yummygood/displays/mainpage.dart';
import 'dart:developer' as developer;
import 'categories.dart';
import 'person.dart';

class ItemPage extends StatefulWidget{
  
  String itemId;
  ItemPage(this.itemId);

  @override
  State<ItemPage> createState() => ItemState();
}

class ItemState extends State<ItemPage>{

  Future<dynamic> getItemInfo() async{
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();

    final menuItemInfo = await db.rawQuery("SELECT * FROM MenuItem WHERE item_id = ${widget.itemId}");
    return menuItemInfo;
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
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasData){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration:BoxDecoration(
                        color:Colors.white,
                        border: Border.all(
                          color: Colors.black, 
                          width:1)), 
                        width:350, 
                        height:100, 
                        child: Image.network(snapshot.data[0]["picture_url"], 
                          fit:BoxFit.cover
                        )),
                        const SizedBox(height:20),
                        Row(
                          children: [
                            const SizedBox(width:20),
                            Align(alignment:Alignment.centerLeft, child: Text(snapshot.data[0]["name"], style:TextStyle(fontSize:20))),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width:20),
                            Align(alignment:Alignment.centerLeft, child: Text("\$${snapshot.data[0]["price"]}", style:TextStyle(fontSize:20))),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width:20),
                            Align(alignment:Alignment.centerLeft, child: Text("${snapshot.data[0]["description"]}", style:TextStyle(fontSize:15))),
                          ],
                        ),

                        Row(
                          children: [
                            const SizedBox(width:20),
                            TextButton(onPressed:() async{
                              DatabaseService dbService = DatabaseService();
                              UserService userService = UserService();
                              Database db = await dbService.getDatabase();
                              
                              List<Map<String, Object?>> existingData = await db.rawQuery("SELECT * FROM CartItem WHERE email = '${userService.getUser()!.email}' AND item_id = ${widget.itemId}");

                              if (existingData.isEmpty){
                                db.execute("INSERT INTO CartItem VALUES(${widget.itemId}, ${snapshot.data[0]["restaurant_id"]},'${userService.getUser()!.email}', 1)");
                              }else{
                                final quantity = existingData[0]["quantity"] as int;
                                db.execute("UPDATE CartItem SET quantity = ${quantity + 1} WHERE email = '${userService.getUser()!.email}' AND item_id = ${widget.itemId}");
                              }
                              showDialog(context: context, builder: (context) => AlertDialog(
                                title: const Text("Success"),
                                content: const Text("Item successfully added to cart!"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: (){Navigator.of(context).pop();Navigator.of(context).pop();},
                                    child: const Text("OK")
                                  )
                                ]
                              ));

                            }, child: Text("Add to cart", style:TextStyle(color:Colors.black)), style:TextButton.styleFrom(
                              backgroundColor: const Color(0xFFFF4500),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              splashFactory: NoSplash.splashFactory,
                            )),
                          ],
                        ),
                  ]
                )
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator()
          );
        },
        future: getItemInfo()
      )
    );
  }
}