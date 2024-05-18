import 'package:yummygood/model/menu.dart';

class Restaurant{
  int restaurantId;
  String name;
  double deliveryFee;
  String category;
  String deliveryTime;
  Menu menu;

  Restaurant(this.restaurantId, this.name, this.deliveryFee, this.category, this.deliveryTime, this.menu);
}