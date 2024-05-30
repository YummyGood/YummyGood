import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yummygood/db/dbservice.dart';

class AddMenuItemPage extends StatefulWidget {
  final int restaurantId;
  AddMenuItemPage(this.restaurantId);

  @override
  State<AddMenuItemPage> createState() => AddMenuItemState();
}

class AddMenuItemState extends State<AddMenuItemPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  void addMenuItem(BuildContext context) async {
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();

    double priceValue = 0.00;

    try {
      priceValue = double.parse(priceController.text);
    } on FormatException {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Price value must be a valid number!"),
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

    await db.insert(
      'MenuItem',
      {
        'name': nameController.text,
        'description': descriptionController.text,
        'price': priceValue,
        'restaurant_id': widget.restaurantId,
        'picture_url': urlController.text,
      },
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Menu item added successfully!"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Menu Item"),
        backgroundColor: const Color(0xFFFF4500),
      ),
      backgroundColor: const Color(0xFFFFEABF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                const Text("Description: "),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: descriptionController,
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
                const Text("Price: "),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: priceController,
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
                  width: 250,
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
            SizedBox(
              width: 160,
              child: TextButton(
                onPressed: () async {
                  addMenuItem(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4500),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  splashFactory: NoSplash.splashFactory,
                ),
                child: const Text("Add Item",
                    style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
