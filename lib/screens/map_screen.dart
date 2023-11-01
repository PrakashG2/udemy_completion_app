import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  MapScreen({required this.latitude, required this.longitude});

  _launchMap() async {
    String url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final Uri link = Uri.parse(url); // Corrected line

    if (await canLaunchUrl(link)) {
      // Corrected line
      await launchUrl(link); // Corrected line
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchMap,
          child: Text('Open Map'),
        ),
      ),
    );
  }
}
