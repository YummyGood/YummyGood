import 'package:flutter/material.dart';
import 'package:yummygood/displays/searchresult.dart';
import 'mainpage.dart';
import 'person.dart';

class CategoriesPage extends StatefulWidget{
  @override
  State<CategoriesPage> createState() => CategoriesState();
}

class CategoriesState extends State<CategoriesPage>{
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
            IconButton(icon:const Icon(Icons.search), onPressed: (){}),
            IconButton(icon:const Icon(Icons.person), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => PersonPage()));},),
          ],
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Categories", style: TextStyle(fontSize:20),),
            const SizedBox(height:50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height:90,
                      child: IconButton(
                        icon: Image.asset("images/pizza.png"),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage("category", "Pizza")));
                        },
                      ),
                    ),
                    const Text("Pizza"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height:90,
                      child: IconButton(
                        icon: Image.asset("images/fast_food.png"),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage("category", "Fast Food")));
                        },
                      ),
                    ),
                    const Text("Fast Food"),
                  ],
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
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
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height:90,
                      child: IconButton(
                        icon: Image.asset("images/sushi.png"),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage("category", "Sushi")));
                        },
                      ),
                    ),
                    const Text("Sushi"),
                  ],
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height:90,
                      child: IconButton(
                        icon: Image.asset("images/pasta.png"),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage("category", "Pasta")));
                        },
                      ),
                    ),
                    const Text("Pasta"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height:90,
                      child: IconButton(
                        icon: Image.asset("images/bbq.png"),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage("category", "BBQ")));
                        },
                      ),
                    ),
                    const Text("BBQ"),
                  ],
                )
              ],
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height:90,
                      child: IconButton(
                        icon: Image.asset("images/korean.png"),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage("category", "Korean")));
                        },
                      ),
                    ),
                    const Text("Korean"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height:90,
                      child: IconButton(
                        icon: Image.asset("images/burger.png"),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage("category", "Burgers")));
                        },
                      ),
                    ),
                    const Text("Burgers"),
                  ],
                )
              ],
            ),

          ],
        ),
      )
    );
  }
}