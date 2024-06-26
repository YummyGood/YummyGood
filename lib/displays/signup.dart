import 'package:flutter/material.dart';
import 'package:yummygood/db/dbservice.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:random_string_generator/random_string_generator.dart';

List<String> paymentMethods = ["VISA", "Mastercard", "Paypal", "Stripe"];

class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpState();
}

class SignUpState extends State<SignUpPage>{
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final deliveryAddressController = TextEditingController();
  final restIdController = TextEditingController();

  String errorMessage = "";
  Color errorColor = Colors.red;
  final databaseService = DatabaseService();

  String dropVal = paymentMethods.first;

  void createUser() async{
    final db = await databaseService.getDatabase();
    final checkUserData = await db.rawQuery("SELECT email FROM Users WHERE email = '${emailController.text}'");
    
    // check fields
    if (emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty || firstNameController.text.isEmpty || lastNameController.text.isEmpty || phoneNumberController.text.isEmpty || deliveryAddressController.text.isEmpty){
      
      String restId = "";
      if (restIdController.text.isEmpty){
        restId = restIdController.text;
      }

      errorMessage = "Please ensure all fields are completed!";
      errorColor = Colors.red;
      setState((){});
      return;
    }
  
    if (checkUserData.isNotEmpty){
      errorMessage = "User with that email already exists!";
      errorColor = Colors.red;
      setState((){});
      return;
    }

    if (passwordController.text != confirmPasswordController.text){
      errorMessage = "Confirm password is not the same to password";
      errorColor = Colors.red;
      setState((){});
      return;
    }

    errorMessage = "";
    setState((){});
      
    final gen = RandomStringGenerator(fixedLength: 8, hasSymbols: false);
    String salt = gen.generate();
    String passwordHash = md5.convert(utf8.encode("$salt${passwordController.text}")).toString();
    
    await db.execute("INSERT INTO Users VALUES('${emailController.text}','${firstNameController.text}','${lastNameController.text}','${phoneNumberController.text}','${deliveryAddressController.text}','$passwordHash','$salt', '${restIdController.text}', 0)");
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Success"),
      content: const Text("User successfully created!"),
      actions: <Widget>[
        TextButton(
          onPressed: (){Navigator.of(context).pop();Navigator.of(context).pop();},
          child: const Text("OK")
        )
      ]
    ));
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
      body: ListView(
        children: [Center(
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height:40),
              const Text(key: const Key("title"), "Become apart"),
              const Text("of"),
              Container(decoration:BoxDecoration(border: Border.all(color: Colors.black, width:1)), child: const Image(image: AssetImage("images/logo.png"), height:150)),
              const SizedBox(height:20),
              
              // Email Field
              const Row(
                children: <Widget>[
                  SizedBox(width:32),
                  Align(alignment: Alignment.centerLeft, child: Text("Email:")),
                ],
              ),
              SizedBox(width:350,child:TextField(key:const Key("emailField"), controller: emailController, decoration:const InputDecoration(filled:true, fillColor: Color(0xFFEBA174), border:InputBorder.none, hintText:"Enter your email"))),
              const SizedBox(height:10),
        
              // Password Field
              const Row(
                children: <Widget>[
                  SizedBox(width:32),
                  Align(alignment: Alignment.centerLeft, child: Text("Password:")),
                ],
              ),
              SizedBox(width:350, child:TextField(controller: passwordController, decoration:const InputDecoration(filled:true, fillColor: Color(0xFFEBA174), border:InputBorder.none, hintText:"Enter your password"), obscureText: true, enableSuggestions: false,autocorrect: true,)),
              const SizedBox(height:10),
        
              // Confirm Password Field
              const Row(
                children: <Widget>[
                  SizedBox(width:32),
                  Align(alignment: Alignment.centerLeft, child: Text("Confirm Password:")),
                ],
              ),
              SizedBox(width:350, child:TextField(controller: confirmPasswordController, decoration:const InputDecoration(filled:true, fillColor: Color(0xFFEBA174), border:InputBorder.none, hintText:"Confirm your password"), obscureText: true, enableSuggestions: false,autocorrect: true,)),
              const SizedBox(height:10),
        
              // First and Last Name Fields
              Row(
                children: <Widget>[
                  const SizedBox(width:30),
                  Column(
                    children: <Widget>[
                      const Text("First Name:"),
                      SizedBox(width:150, child:TextField(controller: firstNameController,decoration:const InputDecoration(filled:true, fillColor: Color(0xFFEBA174), border:InputBorder.none, hintText:"First Name"))),
                    ],
                  ),
                  const SizedBox(width:50),
                  Column(
                    children: <Widget>[
                      const Text("Last Name:"),
                      SizedBox(width:150,child:TextField(controller: lastNameController, decoration:const InputDecoration(filled:true, fillColor: Color(0xFFEBA174), border:InputBorder.none, hintText:"Last Name"))),
                    ],
                  )
                ]
              ),
              const SizedBox(height:10),
        
              // Phone Number Field
              const Row(
                children: <Widget>[
                  SizedBox(width:32),
                  Align(alignment: Alignment.centerLeft, child: Text("Phone Number:")),
                ],
              ),
              SizedBox(width:350,child:TextField(controller: phoneNumberController, decoration:const InputDecoration(filled:true, fillColor: Color(0xFFEBA174), border:InputBorder.none, hintText:"Enter your mobile phone number"))),
              const SizedBox(height:10),
        
              // Delivery Address Field
              const Row(
                children: <Widget>[
                  SizedBox(width:32),
                  Align(alignment: Alignment.centerLeft, child: Text("Delivery Address:")),
                ],
              ),
              SizedBox(width:350,child:TextField(controller: deliveryAddressController, decoration:const InputDecoration(filled:true, fillColor: Color(0xFFEBA174), border:InputBorder.none, hintText:"Enter your address"), maxLines: 2)),
              const SizedBox(height:15),

              DropdownMenu<String>(
                initialSelection: paymentMethods.first,
                onSelected: (String? value){
                  setState((){
                    dropVal = value!;
                  });
                },
                dropdownMenuEntries: paymentMethods.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: Color(0xFFEBA174),
                ),
              ),
              const SizedBox(height:15),

              SizedBox(width:200,child:TextField(controller: restIdController, decoration:const InputDecoration(filled:true, fillColor: Color(0xFFEBA174), border:InputBorder.none, hintText:"Restaurant ID"))),
              const SizedBox(height:15),
              
              // Sign up button
              SizedBox(
                width:160,
                child: TextButton(
                  onPressed: () async{
                    createUser();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4500),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child:const Text("Sign Up", style:TextStyle(color:Colors.black))),
              ),
              Text(errorMessage, style:TextStyle(color:errorColor)),
              const SizedBox(height:30),
            ],
          )
        )],
      )
    );
  }
}

