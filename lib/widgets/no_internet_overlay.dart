import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/connectivity_provider.dart';

class NoInternetOverlay extends ConsumerWidget {
  const NoInternetOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectivityProvider);

    if (isConnected) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black.withAlpha(150),
      child: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, size: 60, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'No Internet Connection',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Please check your network and try again.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
