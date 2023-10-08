import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Map<String, dynamic>? neoData;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        neoData = null; // Reset NEO data when a new date is selected
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
        neoData = null; // Reset NEO data when a new date is selected
      });
    }
  }

  Future<void> fetchNeoData(DateTime startDate, DateTime endDate) async {
    final apiKey = 'DEMO_KEY'; // Replace with your actual NASA API key
    final formattedStartDate = startDate.toLocal().toString().split(' ')[0];
    final formattedEndDate = endDate.toLocal().toString().split(' ')[0];

    final url =
        'https://api.nasa.gov/neo/rest/v1/feed?start_date=$formattedStartDate&end_date=$formattedEndDate&api_key=$apiKey';

    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          neoData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load NEO data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred while fetching data';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NASA NEO API'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Start Date: ${startDate.toLocal()}'.split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectStartDate(context),
            ),
            ListTile(
              title: Text('End Date: ${endDate.toLocal()}'.split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectEndDate(context),
            ),
            ElevatedButton(
              onPressed: () {
                // Call the API with selected start and end dates
                fetchNeoData(startDate, endDate);
              },
              child: Text('Fetch NEO Data'),
            ),
            if (isLoading)
              CircularProgressIndicator() // Show a loading indicator
            else if (errorMessage.isNotEmpty)
              Text(errorMessage) // Show error message
            else if (neoData != null)
                NeoDataWidget(neoData: neoData), // Display the custom widget with NEO data
          ],
        ),
      ),
    );
  }
}

class NeoDataWidget extends StatelessWidget {
  final Map<String, dynamic>? neoData;

  NeoDataWidget({required this.neoData});

  @override
  Widget build(BuildContext context) {
    // Extract and display relevant information from the NEO data here
    return Column(
      children: [
        Text('NEO Data: ${jsonEncode(neoData)}', style: TextStyle(fontSize: 16)),
        // Add more widgets to display specific information about NEOs
        Text('Additional Information 1: ...', style: TextStyle(fontSize: 16)),
        Text('Additional Information 2: ...', style: TextStyle(fontSize: 16)),
        // Add as many paragraphs as needed for the 8 topics
      ],
    );
  }
}