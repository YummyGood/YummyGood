import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yummygood/db/dbservice.dart';
import 'mainpage.dart';
import 'categories.dart';
import 'menupage.dart';
import 'editmenuitempage.dart'; // Import the edit menu item page
import 'addmenuitempage.dart'; // Import the add menu item page

class EditPage extends StatefulWidget {
  final dynamic restaurantInfo;
  EditPage(this.restaurantInfo);

  @override
  State<EditPage> createState() => EditState();
}

class EditState extends State<EditPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  List<Map<String, dynamic>> menuItems = [];

  @override
  void initState() {
    super.initState();
    nameController.text = widget.restaurantInfo["name"];
    categoryController.text = widget.restaurantInfo["category"];
    feeController.text = widget.restaurantInfo["delivery_fee"].toString();
    timeController.text = widget.restaurantInfo["delivery_time"];
    urlController.text = widget.restaurantInfo["picture_url"];
    fetchMenuItems();
  }

  void fetchMenuItems() async {
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();
    final data = await db.rawQuery("SELECT * FROM MenuItem WHERE restaurant_id = ${widget.restaurantInfo["restaurant_id"]}");
    setState(() {
      menuItems = data;
    });
  }

  void writeData(BuildContext context) async {
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();

    double feeValue = 0.00;

    try {
      feeValue = double.parse(feeController.text);
    } on FormatException {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Fee value must be a valid number!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    await db.execute(
      "UPDATE Restaurant SET name = '${nameController.text}', category = '${categoryController.text}', delivery_fee = $feeValue, delivery_time = '${timeController.text}', picture_url = '${urlController.text}' WHERE restaurant_id = ${widget.restaurantInfo["restaurant_id"].toString()}",
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Update Successful!"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MenuPage(
                    widget.restaurantInfo["restaurant_id"].toString(),
                  ),
                ),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshMenuItems() async {
    fetchMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF4500),
        toolbarHeight: 50,
        leading: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFFEABF),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFFF4500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainPage()),
                      (route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Edit ${widget.restaurantInfo["name"]} info",
                style: const TextStyle(fontSize: 19),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Name: "),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFEBA174),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Category: "),
                  SizedBox(
                    width: 230,
                    child: TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFEBA174),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Delivery Fee: "),
                  SizedBox(
                    width: 210,
                    child: TextField(
                      controller: feeController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFEBA174),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Delivery Time: "),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFEBA174),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Image URL: "),
                  SizedBox(
                    width: 220,
                    child: TextField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFEBA174),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: menuItems.map((menuItem) {
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditMenuItemPage(menuItem),
                        ),
                      );
                      if (result == true) {
                        // Refresh menu items after deletion
                        _refreshMenuItems();
                      }
                    },
                    child: MenuItemWidget(menuItem),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMenuItemPage(widget.restaurantInfo["restaurant_id"]),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4500),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: const Text("Add Menu Item",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 160,
                    child: TextButton(
                      onPressed: () async {
                        writeData(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4500),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: const Text("Save Data",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final Map<String, dynamic> menuItem;
  MenuItemWidget(this.menuItem);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
          ),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(menuItem["name"].toString(),
                          style: const TextStyle(fontSize: 15)),
                      Text("\$${menuItem["price"].toString()}"),
                      Text(menuItem["description"].toString())
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 1)),
                    width: 100,
                    height: 100,
                    child: Image.network(
                      menuItem["picture_url"].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
