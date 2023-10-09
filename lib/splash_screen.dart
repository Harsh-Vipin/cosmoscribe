import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APODViewer extends StatefulWidget {
  const APODViewer({super.key});

  @override
  _APODViewerState createState() => _APODViewerState();
}

class _APODViewerState extends State<APODViewer> {
  String imageUrl = "";
  String title = "";
  String explanation = "";

  @override
  void initState() {
    super.initState();
    fetchAPODData();
  }

  Future<void> fetchAPODData() async {
    const apiUrl = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        imageUrl = jsonData["url"];
        title = jsonData["title"];
        explanation = jsonData["explanation"];
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  explanation,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
