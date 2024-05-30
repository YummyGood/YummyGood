import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yummygood/db/dbservice.dart';
import 'package:yummygood/db/userservice.dart';
import 'dart:developer' as developer;

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final double deliveryFee; // Add deliveryFee
  final String restaurantId; // Add restaurantId

  PaymentPage({required this.totalAmount, required this.deliveryFee, required this.restaurantId});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  String? cardNumber;
  String? expiryDate;
  String? cvv;
  String? cardHolderName;
  bool isSubscribed = false;
  bool isMember = false;

  @override
  void initState() {
    super.initState();
    _checkSubscription();
  }

  Future<void> _checkSubscription() async {
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();
    UserService userService = UserService();
    await db.execute("UPDATE Users SET subscription = 0 WHERE subscription IS NULL"); // Ensure no null values
    final user = await db.query('Users', where: 'email = ?', whereArgs: [userService.getUser()!.email]);

    if (user.isNotEmpty) {
      int subscriptionStatus = (user[0]['subscription'] ?? 0) as int;
      setState(() {
        isMember = subscriptionStatus == 1;
        isSubscribed = isMember;
      });
      developer.log('User subscription status: $subscriptionStatus', name: 'PaymentPage');
    } else {
      developer.log('User not found in database', name: 'PaymentPage');
    }
  }

  double get finalAmount {
    if (isMember) {
      return (widget.totalAmount) * 0.8;
    } else if (isSubscribed) {
      return widget.totalAmount * 0.8 + 20;
    } else {
      return widget.totalAmount;
    }
  }

  Future<void> _clearCart() async {
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();
    UserService userService = UserService();
    await db.delete('CartItem', where: 'email = ?', whereArgs: [userService.getUser()!.email]);
  }

  Future<void> _placeOrder() async {
    DatabaseService dbService = DatabaseService();
    Database db = await dbService.getDatabase();
    UserService userService = UserService();

    final cart = await db.rawQuery(
        "SELECT * FROM CartItem WHERE restaurant_id = ${widget.restaurantId} AND email = '${userService.getUser()!.email}'");
    final lastOrder = await db.rawQuery("SELECT * FROM Orders ORDER BY order_id");
    int orderId = 0;
    if (lastOrder.isNotEmpty) {
      orderId = int.parse(lastOrder[lastOrder.length - 1]["order_id"].toString()) + 1;
    }

    await db.execute("INSERT INTO Orders VALUES($orderId, '${widget.restaurantId}', '${userService.getUser()!.email}', '${DateTime.now().toString()}')");

    for (dynamic item in cart) {
      await db.execute("INSERT INTO OrderItem VALUES($orderId, ${item["item_id"].toString()}, ${item["quantity"].toString()})");
    }

    await _clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: const Color(0xFFFF4500),
      ),
      backgroundColor: const Color(0xFFFFEABF), // Same background color as the cart page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                onSaved: (value) => cardNumber = value,
                validator: (value) => value!.isEmpty ? 'Please enter your card number' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                keyboardType: TextInputType.datetime,
                onSaved: (value) => expiryDate = value,
                validator: (value) => value!.isEmpty ? 'Please enter the expiry date' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                obscureText: true,
                onSaved: (value) => cvv = value,
                validator: (value) => value!.isEmpty ? 'Please enter the CVV' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Card Holder Name'),
                onSaved: (value) => cardHolderName = value,
                validator: (value) => value!.isEmpty ? 'Please enter the card holder name' : null,
              ),
              SizedBox(height: 20),
              if (!isMember) ...[
                Row(
                  children: [
                    Checkbox(
                      value: isSubscribed,
                      onChanged: (value) {
                        setState(() {
                          isSubscribed = value!;
                        });
                      },
                    ),
                    Flexible(
                      child: Text(
                        '\$20 each month and get 20% off for all orders!',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  'You are a member and get 20% off!',
                  style: TextStyle(fontSize: 14),
                ),
              ],
              SizedBox(height: 20),
              Text('Total Amount: \$${finalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Pay Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4500), // Same button color as the cart page
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!isMember && isSubscribed) {
        try {
          DatabaseService dbService = DatabaseService();
          Database db = await dbService.getDatabase();
          UserService userService = UserService();
          await db.update(
            'Users',
            {'subscription': 1},
            where: 'email = ?',
            whereArgs: [userService.getUser()!.email],
          );
          print('Subscription updated successfully');
        } catch (e) {
          print('Error updating subscription: $e');
        }
      }

      await Future.delayed(Duration(seconds: 2));

      await _placeOrder();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Payment Successful'),
          content: Text('Your payment of \$${finalAmount.toStringAsFixed(2)} has been processed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Navigate back to the previous screen
                Navigator.pop(context); // Navigate back to the previous screen
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
