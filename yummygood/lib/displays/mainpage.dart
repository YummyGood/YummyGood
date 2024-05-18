import 'package:flutter/material.dart';
import 'package:yummygood/db/dbservice.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yummygood/db/userservice.dart';
import 'package:yummygood/model/user.dart';
import 'package:yummygood/displays/menupage.dart';
import 'package:yummygood/displays/searchresult.dart';
import 'dart:developer' as developer;


class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainState();
}

class MainState extends State<MainPage>{

  List<RestaurantItem> restHighlight = [];


  Future<dynamic> getRestaurants() async{
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();

    final data = db.rawQuery("SELECT * FROM Restaurant");
    return data;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
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
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasData){
              
              List<Map<String, Object?>> restaurants = snapshot.data;
              restHighlight.clear();

              for (Map<String, Object?> restaurant in restaurants){
                restHighlight.add(RestaurantItem(restaurant["name"].toString(), restaurant["delivery_fee"].toString(), restaurant["picture_url"].toString(), restaurant["restaurant_id"].toString()));
              }

              UserService userService = UserService();
              User? currentUser = userService.getUser();

              if (currentUser == null){
                // idk do something here
                return const Center(child: Text("There was an error getting the current logged in user!"));
              }


              return ListView(
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Address Box
                        const SizedBox(height:40),
                        Container(
                          color: const Color(0xFFEBA174),
                          child: SizedBox(height:50,width:400,child:
                            Center(child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width:20),
                                Text("Currently delivering to ${currentUser.address}"),
                                const Spacer(),
                                IconButton(icon:const Icon(Icons.arrow_downward), onPressed:(){}),
                              ],
                            ))),
                        ),
                        const SizedBox(height:20),

                        // Search Box
                        SizedBox(
                          height:50,
                          width:400,
                          child: TextField(
                            onSubmitted: (String value){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage("name", value)));
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search), 
                              filled: true, 
                              fillColor: Color(0xFFEBA174),
                              border: InputBorder.none,
                              hintText: "Search"
                            )
                          ),
                        ),
                        const SizedBox(height:30),
                        
                        // Category suggestions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            const SizedBox(width: 10),

                            // Pizza Button
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height:90,
                                  child: IconButton(
                                    icon: Image.asset("images/pizza.png"),
                                    onPressed: (){
                                  
                                    },
                                  ),
                                ),
                                const Text("Pizza"),
                              ]
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height:90,
                                  child: IconButton(
                                    icon: Image.asset("images/fast_food.png"),
                                    onPressed: (){
                                  
                                    },
                                  ),
                                ),
                                const Text("Fast Food"),
                              ]
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height:90,
                                  child: IconButton(
                                    icon: Image.asset("images/kebab.png"),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage("category", "Kebab")));
                                    },
                                  ),
                                ),
                                const Text("Kebab"),
                              ]
                            ),
                            const SizedBox(width: 10),
                          ]
                        ),
                        const SizedBox(height:30),

                        // List view for 3 random restaurants
                        SizedBox(
                            width:350,
                            height:420,
                            child: ListView(
                              children: restHighlight
                            ),
                          ),
                      ],
                    )
                  ),
                ]
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator()
          );
        },
        future: getRestaurants(),
      )
    );
  }
}

class RestaurantItem extends StatelessWidget{
  
  String name;
  String deliveryFee;
  String imageUrl;
  String restaurantId;

  RestaurantItem(this.name, this.deliveryFee, this.imageUrl, this.restaurantId);

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Container(
          decoration:BoxDecoration(
            border: Border.all(
              color: Colors.black, 
              width:1)), 
            width:350, 
            height:100, 
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage(restaurantId)));
              },
              child: Image.network(imageUrl, 
                fit:BoxFit.cover
              ),
            )),
        Align(alignment:Alignment.centerLeft, child:(Text("$name: $deliveryFee delivery fee"))),
        const SizedBox(height:20),
      ],
    );
  }
}