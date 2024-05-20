import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'package:yummygood/db/userservice.dart';
import 'categories.dart';
import 'package:yummygood/db/userservice.dart';
import 'package:yummygood/model/user.dart';
import 'homepage.dart';
import 'dart:developer' as developer;

class PersonPage extends StatefulWidget{
  @override
  State<PersonPage> createState() => PersonState();
}

class PersonState extends State<PersonPage>{

  Future<User?> getUserInfo() async{
    UserService userService = UserService();
    return userService.getUser();
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
            IconButton(icon:const Icon(Icons.person), onPressed: (){},),
          ],
        )
      ),
      body: FutureBuilder(
        builder:(context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasData){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 300),
                    Text("Hello ${snapshot.data!.firstName} ${snapshot.data!.lastName}", style: const TextStyle(fontSize: 20),),
                    Text("Email: ${snapshot.data!.email}"),
                    Text("Phone: ${snapshot.data!.phone}"),
                    Text("Delivery Address: ${snapshot.data!.address}"),
                    const Spacer(),
                    TextButton(child: Text("Log Out"), onPressed: (){Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);},)

                  ],
                ),
              );
            }
          }

          return const Center(child:CircularProgressIndicator());
        },
        future: getUserInfo(),
      )
    );
  }
}