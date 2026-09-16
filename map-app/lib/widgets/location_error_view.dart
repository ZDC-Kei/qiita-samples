import 'package:flutter/material.dart';

import '../services/location_service.dart';

class LocationErrorView extends StatelessWidget {
  const LocationErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  final LocationFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 56),
            const SizedBox(height: 16),
            Text(failure.message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('再試行'),
            ),
          ],
        ),
      ),
    );
  }
}
