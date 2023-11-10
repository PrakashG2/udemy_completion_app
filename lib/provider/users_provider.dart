import 'package:api_prov_try/models/users_model.dart';
import 'package:api_prov_try/utilities/api_services.dart';
import 'package:flutter/material.dart';

class UsersProvider extends ChangeNotifier {
  List<UsersModel>? usersList;
  bool fetchUsersLoading = false;

  //----------------------------------------------------> FETCH USERS DATA USING GET METHOD

  Future<void> fetchUsers() async {
    fetchUsersLoading = true;
    usersList = await getUsers();
    fetchUsersLoading = false;
    notifyListeners();
  }
}
