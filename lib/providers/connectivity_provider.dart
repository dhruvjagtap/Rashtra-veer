import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = NotifierProvider<ConnectivityNotifier, bool>(
  ConnectivityNotifier.new,
);

class ConnectivityNotifier extends Notifier<bool> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  bool build() {
    _init();

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return true;
  }

  Future<void> _init() async {
    final result = await Connectivity().checkConnectivity();

    state = !result.contains(ConnectivityResult.none);

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      state = !results.contains(ConnectivityResult.none);
    });
  }
}
