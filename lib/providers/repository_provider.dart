// lib/providers/repository_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rashtraveer/feature/auth/data/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
