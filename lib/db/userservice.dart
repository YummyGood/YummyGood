import 'package:yummygood/model/user.dart';
import 'dart:developer' as developer;

class UserService{
  static final _userService = UserService._internal();
  factory UserService() => _userService;
  UserService._internal();
  static User? currentLoggedIn;

  User? getUser(){
    return currentLoggedIn;
  }

  void setUser(dynamic user){
    currentLoggedIn = User(user["email"], user["first_name"], user["last_name"], user["phone"], user["address"], user["restId"]);
    developer.log("Updated user to ${user["email"]}");
  }

}