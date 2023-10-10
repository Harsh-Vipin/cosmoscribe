import 'dart:convert';

import 'package:cosmoscribe/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:cosmoscribe/screens/home_screen.dart';

class APODViewer extends StatefulWidget {
  const APODViewer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _APODViewerState createState() => _APODViewerState();
}

class _APODViewerState extends State<APODViewer> {
  late Future<void> apodData;
  String imageUrl = "";
  String title = "";
  String explanation = "";

  @override
  void initState() {
    super.initState();
    apodData = fetchAPODData();
  }

  Future<void> fetchAPODData() async {
    const apiUrl =
        "https://api.nasa.gov/planetary/apod?api_key=AXepP1gWs5NhdUp7bvuZ4TW1EP37S1i2nFga3kTH";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        imageUrl = jsonData["url"];
        title = jsonData["title"];
        explanation = jsonData["explanation"];
      });

      // Wait until the image is loaded before navigating to the next screen.
      // ignore: use_build_context_synchronously
      await precacheImage(NetworkImage(imageUrl), context);

      // Wait for 3 seconds before navigating to the next screen.
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>  HomeScreen(),
          ),
        );
      });
    } else {
      throw Exception('Failed to load APOD data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NASA APOD Viewer"),
      ),
      body: FutureBuilder<void>(
        future: apodData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: GalaxyLoadingIcon(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load data'),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.7),
                          blurRadius: 5.0,
                          offset: const Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      // height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      style: GoogleFonts.aboreto(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Text(
                        
                        explanation,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.aBeeZee(
                        
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
