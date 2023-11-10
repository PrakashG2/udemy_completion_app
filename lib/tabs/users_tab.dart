import 'package:api_prov_try/provider/users_provider.dart';
import 'package:api_prov_try/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({super.key});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  //-----------------------------------------------------------------> INIT

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    userProvider.fetchUsers();
  }

  //--------------------------------------------------------------> PHONE LOGIC
  void _phoneBtn(String phoneNum) async {
    var phoneStatus = await Permission.phone.request();

    if (phoneStatus.isGranted) {
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
    } else if (phoneStatus.isRestricted || phoneStatus.isLimited) {
      print("Phone permission restricted or limited");
    }
  }

  //-------------------------------------------------------------------> LOCATE ON MAP LOGIC
  _launchMap(String lat, String long) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    final Uri link = Uri.parse(url);

    if (await canLaunchUrl(link)) {
      await launchUrl(link);
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

//------------------------------------------------------------------------------> UI
  @override
  Widget build(BuildContext context) {
    final usersProviderData = Provider.of<UsersProvider>(context);

    //--------------------------------------------------------------------------> API DATA LOADING INDICATOR

    if (usersProviderData.fetchUsersLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    //---------------------------------------------------------------------------> API DATA EMPTY

    if (usersProviderData.usersList!.isEmpty) {
      return const Center(child: Text("Oops ! ... No Users yet"));
    }

    return ListView.builder(
      itemCount: usersProviderData.usersList!.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 233, 231, 231),
              borderRadius: BorderRadius.circular(10),
            ),

            //--------------------------------------------------------> LIST VIEW BUILDER CONTENT

            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 178, 180, 182),
                        radius: 20,
                        child: Text(
                          usersProviderData.usersList![index].name[0]
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(usersProviderData.usersList![index].name),
                          Text(
                            "@ ${usersProviderData.usersList![index].username}",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 121, 121, 121)),
                          )
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        radius: 30,
                        splashColor:
                            Colors.green, 
                        onTap: () {
                          _phoneBtn(usersProviderData.usersList![index].phone);
                        },
                        child: const IconButton(
                          onPressed:
                              null, 
                          icon: Icon(
                            Icons.phone_rounded,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _launchMap(
                              usersProviderData
                                  .usersList![index].address.geo.lat,
                              usersProviderData
                                  .usersList![index].address.geo.lng);
                        },
                        icon: const Icon(
                          Icons.my_location_rounded,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _sendEmail(usersProviderData.usersList![index].email);
                        },
                        icon: const Icon(
                          Icons.forward_to_inbox_rounded,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "ADDRESS LINE 1 : ${usersProviderData.usersList![index].address.street}, ${usersProviderData.usersList![index].address.suite}"),
                        Text(
                            "ADDRESS LINE 2 : ${usersProviderData.usersList![index].address.city}"),
                        Text(
                            "ZIPCODE : ${usersProviderData.usersList![index].address.zipcode}"),
                        Text(
                            "EMAIL : ${usersProviderData.usersList![index].email}"),
                        Text(
                            "PHONE : ${usersProviderData.usersList![index].phone}"),
                        Text(
                            "COMPANY :${usersProviderData.usersList![index].company.name}"),
                        Row(
                          children: [
                            const Text("WEBSITE : "),
                            Text(usersProviderData
                                .usersList![index].company.name),
                            IconButton(
                                onPressed: () async {
                                  await FlutterWebBrowser.openWebPage(
                                      url: "http://${usersProviderData.usersList![index].website}/");
                                },
                                icon: const Icon(
                                  Icons.link,
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                      ],
                    ),
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
