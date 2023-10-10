import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GalaxyLoadingIcon extends StatelessWidget {
  const GalaxyLoadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitSpinningLines(
      color: Colors.black,
      itemCount: 5,
      size: 150,
      );
  }
}
