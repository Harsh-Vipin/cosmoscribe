import 'package:cosmoscribe/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? startDate;
  DateTime? endDate;
  Map<String, dynamic>? neoData;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      initialDate: DateTime.now(),
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
    // Replace with your actual NASA API key
    final formattedStartDate = startDate.toLocal().toString().split(' ')[0];
    final formattedEndDate = endDate.toLocal().toString().split(' ')[0];

    final url =
        'https://api.nasa.gov/neo/rest/v1/feed?start_date=$formattedStartDate&end_date=$formattedEndDate&api_key=$API_KEY';

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
        title: const Text('NASA NEO API'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Start Date: '),
                  startDate != null
                      ? Text(
                          '${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}')
                      : const Text(''),
                  const SizedBox(width: 20),
                ],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectStartDate(context),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('End Date: '),
                  endDate != null
                      ? Text(
                          '${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}')
                      : const Text(''),
                  const SizedBox(width: 13),
                ],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectEndDate(context),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Call the API with selected start and end dates

                    if ((startDate == null && endDate == null) ||
                        (startDate == null && endDate != null) ||
                        (startDate != null && endDate == null)) {
                      Fluttertoast.showToast(
                        msg: 'Please provide both start and end dates',
                      );
                    }

                    if (startDate != null && endDate != null) {
                      if (startDate!.day - endDate!.day > 7) {
                        Fluttertoast.showToast(
                          msg: 'Date difference should be less than 7',
                        );
                      } else {
                        fetchNeoData(startDate!, endDate!);
                      }
                    }
                  },
                  child: const Text('Fetch NEO Data'),
                ),
              ],
            ),
            if (isLoading)
              const Center(
                  child:
                      CircularProgressIndicator()) // Show a loading indicator
            else if (errorMessage.isNotEmpty)
              Text(errorMessage) // Show error message
            else if (neoData != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                child: NeoDataWidget(
                  neoData: neoData,
                ),
              ), // Display the custom widget with NEO data
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
    if (neoData == null || neoData!['element_count'] == 0) {
      return const Text('No NEO data available for the selected date range',
          style: TextStyle(fontSize: 16));
    }

    // Extract the NEO data from the fetched JSON response
    final neoElements = neoData!['near_earth_objects'];
    final dateKeys = neoElements.keys.toList(); // Get the date keys

    return Column(
      children: [
        for (var dateKey in dateKeys)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Date: $dateKey',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              for (var neo in neoElements[dateKey])
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(21.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${neo['name']}',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Absolute Magnitude: ${neo['absolute_magnitude_h']}',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Estimated Diameter: ${neo['estimated_diameter']['kilometers']['estimated_diameter_max']} km',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Potentially Hazardous: ${neo['is_potentially_hazardous_asteroid'] ? 'Yes' : 'No'}',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Close Approach Date: ${neo['close_approach_data'][0]['close_approach_date_full']}',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Miss Distance: ${neo['close_approach_data'][0]['miss_distance']['astronomical']} astronomical units',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Orbiting Body: ${neo['close_approach_data'][0]['orbiting_body']}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
      ],
    );
  }
}
