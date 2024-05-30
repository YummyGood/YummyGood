import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yummygood/db/dbservice.dart';

class EditMenuItemPage extends StatefulWidget {
  final Map<String, dynamic> menuItem;
  EditMenuItemPage(this.menuItem);

  @override
  State<EditMenuItemPage> createState() => EditMenuItemState();
}

class EditMenuItemState extends State<EditMenuItemPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  void updateMenuItem(BuildContext context) async {
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

    await db.execute(
      "UPDATE MenuItem SET name = '${nameController.text}', description = '${descriptionController.text}', price = $priceValue, picture_url = '${urlController.text}' WHERE item_id = ${widget.menuItem["item_id"].toString()}",
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
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void deleteMenuItem(BuildContext context) async {
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();

    await db.delete(
      'MenuItem',
      where: 'item_id = ?',
      whereArgs: [widget.menuItem["item_id"]],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Menu item deleted successfully!"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);  // Pass true to indicate deletion
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.menuItem["name"];
    descriptionController.text = widget.menuItem["description"];
    priceController.text = widget.menuItem["price"].toString();
    urlController.text = widget.menuItem["picture_url"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.menuItem["name"]}"),
        backgroundColor: const Color(0xFFFF4500),
      ),
      backgroundColor: const Color(0xFFFFEABF),
      body: Center(
        child: SingleChildScrollView(
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
              Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Image.network(
                  widget.menuItem["picture_url"],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    child: TextButton(
                      onPressed: () async {
                        updateMenuItem(context);
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
                  SizedBox(width: 20),
                  SizedBox(
                    width: 160,
                    child: TextButton(
                      onPressed: () async {
                        deleteMenuItem(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: const Text("Delete Item",
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
