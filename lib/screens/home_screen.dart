import 'package:cosmoscribe/blocs/neo_bloc/neo_bloc.dart';
import 'package:cosmoscribe/models/neo_model.dart';
import 'package:cosmoscribe/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  final NeoBloc _neoBloc = NeoBloc();

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
      });
    }
  }

  Future<void> fetchNeoData(DateTime startDate, DateTime endDate) async {
    final formattedStartDate = startDate.toLocal().toString().split(' ')[0];
    final formattedEndDate = endDate.toLocal().toString().split(' ')[0];

    _neoBloc.add(GetNeoData(formattedStartDate, formattedEndDate));

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
            BlocProvider(
              create: (_) => _neoBloc,
              child: BlocBuilder<NeoBloc, NeoState>(
                builder: (context, state) {
                  if (state is NeoInitial) {
                    return Container();
                  } else if (state is NeoLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NeoError) {
                    return Center(
                      child: Text(state.message!),
                    );
                  } else if (state is NeoLoaded) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                      child: NeoDataWidget(
                        neoData: state.neoModel,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NeoDataWidget extends StatelessWidget {
  final NeoModel? neoData;

  const NeoDataWidget({super.key, required this.neoData});

  @override
  Widget build(BuildContext context) {
    if (neoData == null || neoData?.elementCount == 0) {
      return const Text('No NEO data available for the selected date range',
          style: TextStyle(fontSize: 16));
    }

    // Extract the NEO data from the fetched JSON response
    final neoElements = neoData!.nearEarthObjects;
    final dateKeys = neoElements!.keys.toList(); // Get the date keys

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
              for (var neo in neoElements[dateKey]!)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(21.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${neo.name}',
                            style: const TextStyle(fontSize: 16)),
                        Text('Absolute Magnitude: ${neo.absoluteMagnitudeH}',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Estimated Diameter: ${neo.estimatedDiameter.kilometers.estimatedDiameterMax} km',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Potentially Hazardous: ${neo.isPotentiallyHazardousAsteroid ? 'Yes' : 'No'}',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Close Approach Date: ${neo.closeApproachData[0].closeApproachDateFull}',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Miss Distance: ${neo.closeApproachData[0].missDistance.astronomical} astronomical units',
                            style: const TextStyle(fontSize: 16)),
                        Text(
                            'Orbiting Body: ${neo.closeApproachData[0].orbitingBody}',
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
