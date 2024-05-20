import 'package:flutter/material.dart';
import 'package:yummygood/db/dbservice.dart';
import 'package:crypto/crypto.dart';
import 'package:yummygood/db/userservice.dart';
import 'dart:convert';

import 'package:yummygood/displays/mainpage.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginState();
}

class LoginState extends State<LoginPage>{

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = "";
  Color errorColor = Colors.red;

  final databaseService = DatabaseService();
  

  void loginUser() async{
    // check all fields are complete
    if (emailController.text.isEmpty || passwordController.text.isEmpty){
      errorMessage = "Please ensure all fields are completed!";
      errorColor = Colors.red;

      setState((){});
      return;
    }

    // check if user exists in db
    final db = await databaseService.getDatabase();
    final users = await db.rawQuery("SELECT * FROM Users WHERE email = '${emailController.text}' LIMIT 1");

    if (users.isEmpty){
      errorMessage = "User not found";
      errorColor = Colors.red;

      setState((){});
      return;
    }

    errorMessage = "";
    String hash = md5.convert(utf8.encode("${users[0]["salt"]}${passwordController.text}")).toString();
    
    if (hash == users[0]["hash"]){
      // login successful

      UserService userService = UserService();
      userService.setUser(users[0]);

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
    }else{
      errorMessage = "Incorrect password or email";
      errorColor = Colors.red;
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF4500),
        toolbarHeight:50,
        leading: IconTheme(data: const IconThemeData(color:Colors.white), child:IconButton(onPressed: (){Navigator.pop(context);}, icon:const Icon(Icons.arrow_back))),
      ),
      backgroundColor: const Color(0xFFFF853A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            const Text("Welcome back"),
            const Text("to"),
            Container(decoration:BoxDecoration(border: Border.all(color: Colors.black, width:1)), child: const Image(image: AssetImage("images/logo.png"), height:150)),
            const SizedBox(height: 20),

            const Row(
              children: <Widget>[
                SizedBox(width:32),
                Align(alignment: Alignment.centerLeft, child: Text("Email:")),
              ],
            ),
            SizedBox(width:350,child:TextField(controller: emailController, decoration:const InputDecoration(filled:true, fillColor: Color(0xFFEBA174), border:InputBorder.none, hintText:"Enter your email"))),
            const SizedBox(height:10),

            const Row(
              children: <Widget>[
                SizedBox(width:32),
                Align(alignment: Alignment.centerLeft, child: Text("Password:")),
              ],
            ),
            SizedBox(width:350,child:TextField(controller: passwordController, decoration:const InputDecoration(filled:true, fillColor: Color(0xFFEBA174), border:InputBorder.none, hintText:"Enter your password"), obscureText: true, enableSuggestions: false,autocorrect: true,)),
            const SizedBox(height:10),

            SizedBox(
              width:160,
              child: TextButton(
                onPressed: () async{
                  loginUser();
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4500),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  splashFactory: NoSplash.splashFactory,
                ),
                child:const Text("Sign In", style:TextStyle(color:Colors.black))),
            ),
            Text(errorMessage, style:TextStyle(color:errorColor)),
          ]
        )
      )
    );
  }
}