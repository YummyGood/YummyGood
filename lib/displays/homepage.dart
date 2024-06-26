import 'package:flutter/material.dart';
import 'package:yummygood/displays/signup.dart';
import 'package:yummygood/displays/login.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFFF853A),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(decoration:BoxDecoration(border: Border.all(color: Colors.black, width:1)), child: const Image(image: AssetImage("images/logo.png"), height:150)),
            const SizedBox(height:30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: TextButton(
                    key:const Key("signup_btn"),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4500),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      splashFactory: NoSplash.splashFactory
                    ),
                    onPressed: (){
                      // Sign Up Page
                      Navigator.push(context, MaterialPageRoute(builder:(context)=> SignUpPage()));
                    },
                    child:const Text("Sign Up", style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width:30),
                SizedBox(
                  width: 100,
                  child: TextButton(
                    key:const Key("login_btn"),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4500),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      splashFactory: NoSplash.splashFactory
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context)=>LoginPage()));
                    },
                    child:const Text("Sign In", style: TextStyle(color: Colors.black)),
                  ),
                ),
              ]
            )
          ]
        )
      )
    );
  }
}