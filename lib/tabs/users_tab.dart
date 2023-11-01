import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/model/users_model.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/map_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({super.key});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  List<User> users = [];
  bool isloading = true;

  Future<void> _fetchUsers() async {
    const url = 'https://jsonplaceholder.typicode.com/users';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<User> fetchedUsers =
          jsonList.map((json) => User.fromJson(json)).toList();
      setState(() {
        users = fetchedUsers;
      });
    } else {
      print('Failed to fetch users');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  //--------------------------------------------------------------> PHONE LOGIC
  void _phoneBtn(String phoneNum) async {
    var phoneStatus = await Permission.phone.request();

    if (phoneStatus.isGranted) {
      print("phone permission granted");
      final Uri url = Uri(
        scheme: "tel",
        path: phoneNum,
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print("Issue with URL");
      }
    } else if (phoneStatus.isDenied) {
      print("Phone permission denied");
    } else if (phoneStatus.isPermanentlyDenied) {
      print("Phone permission permanently denied");
      // You can show a dialog here to guide the user to grant the permission manually in device settings.
    } else if (phoneStatus.isRestricted || phoneStatus.isLimited) {
      print("Phone permission restricted or limited");
    }
  }

  //-------------------------------------------------------------------> LOCATE ON MAP LOGIC
  _launchMap(String lat, String long) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    final Uri link = Uri.parse(url); // Corrected line

    if (await canLaunchUrl(link)) {
      // Corrected line
      await launchUrl(link); // Corrected line
    } else {
      throw 'Could not launch $url';
    }
  }

  //----------------------------------------------------------------------> EMAIL LOGIC
  _sendEmail(String emailId) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailId,
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 182, 181, 181),
              borderRadius: BorderRadius.circular(10),
            ),

            //--------------------------------------------------------> BUILDER CONTAINER CONTENT
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 30,
                        child: Text("avatar"),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(users[index].name),
                          Text("@ ${users[index].username}")
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          _phoneBtn(users[index].phone);
                        },
                        icon: const Icon(Icons.phone_android),
                      ),
                      IconButton(
                        onPressed: () {
                          _launchMap(users[index].address.geo.lat,
                              users[index].address.geo.lng);
                        },
                        icon: const Icon(Icons.pin_drop_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          _sendEmail(users[index].email);
                        },
                        icon: const Icon(Icons.email_outlined),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
