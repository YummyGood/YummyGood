import 'package:flutter/material.dart';
import 'package:yummygood/db/dbservice.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yummygood/displays/menupage.dart';
import 'dart:developer' as developer;
import 'mainpage.dart';
import 'categories.dart';
import 'person.dart';

class SearchPage extends StatefulWidget{
  String searchType;
  String query;

  SearchPage(this.searchType, this.query);

  @override
  State<SearchPage> createState() => SearchState();
}

class SearchState extends State<SearchPage>{
  
  List<Widget> searchItemsList = [];

  Future<dynamic> getSearchResults() async{
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();
    
    if (widget.searchType == "category"){
      developer.log(widget.query);
      final data = await db.rawQuery("SELECT * FROM Restaurant WHERE category = '${widget.query}'");
      return data;
    }else{
      final data = await db.rawQuery("SELECT * FROM Restaurant WHERE name LIKE '%${widget.query}%' UNION SELECT * FROM Restaurant WHERE category = '${widget.query}'");
      return data;
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
              searchItemsList.clear();
              if (widget.searchType == "category"){
                searchItemsList.add(Text("Search results for category: ${widget.query}", style:const TextStyle(fontSize:20)));
              }else{
                searchItemsList.add(Text("Search results for search query: ${widget.query}", style:const TextStyle(fontSize:20)));
              }

              for (dynamic searchItem in snapshot.data){
                searchItemsList.add(GestureDetector(onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage(searchItem["restaurant_id"].toString())));}, child: SearchItem(searchItem)));
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 700,
                      width:380,
                      child: ListView(
                        children: searchItemsList,
                      ),
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
        future: getSearchResults(),
      )
    );
  }
}


class SearchItem extends StatelessWidget{

  dynamic searchItem;
  SearchItem(this.searchItem);

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
                    children: [
                      Align(alignment:Alignment.centerLeft, child: Text(searchItem["name"])),
                      Align(alignment:Alignment.centerLeft, child: Text("\$${searchItem["delivery_fee"]} delivery fee")),
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
                      child: Image.network(searchItem["picture_url"].toString(), 
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