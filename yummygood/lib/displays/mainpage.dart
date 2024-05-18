import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:yummygood/db/userservice.dart';
import 'package:yummygood/model/user.dart';
import 'package:yummygood/model/restaurant.dart';
import 'dart:developer' as developer;


class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainState();
}

class MainState extends State<MainPage>{

  Future<String> getRestaurants(){
    return Future.delayed(Duration(seconds: 2), () {
      return "I am data";
    });
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
                                developer.log(value);
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search), 
                              filled: true, 
                              fillColor: Color(0xFFEBA174),
                              border: InputBorder.none,
                              hintText: "Search"
                            )
                          ),
                        )

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