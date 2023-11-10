import 'package:api_prov_try/screens/homeScreen.dart';
import 'package:flutter/material.dart';
//
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late final LocalAuthentication auth;
  bool biometricHardwareSupport = false;
  bool isAuthenticated = false;

  //-----------------------------------------------------------------> INIT

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      setState(() {
        biometricHardwareSupport = isSupported;
        if (isSupported) {
          _autheticate();
        }
      });
    });
  }

  //-----------------------------------------------------------------> AUTHENTICATION LOGIC
  void _autheticate() async {
    try {
      isAuthenticated = await auth.authenticate(
          localizedReason: "UDEMY COURSE COMPLETION APP",
          options: const AuthenticationOptions(stickyAuth: true));
      if (isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } on Exception catch (e) {
      print("AUTHENTICATION ERROR ********* $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 230,
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  Text(
                    "api",
                    style: GoogleFonts.kenia(
                        textStyle: const TextStyle(fontSize: 150)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "UDEMY COURSE COMPLETION APP",
                    style: GoogleFonts.kenia(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.normal)),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  splashColor: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                  onTap: _autheticate,
                  child: const Icon(
                    Icons.fingerprint,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Please Verify",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.normal)),
                )
              ],
            ),
          ],
        ));
  }
}
