import 'package:flutter/material.dart';

class CurrentLocationMarker extends StatelessWidget {
  const CurrentLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
    );
  }
}
