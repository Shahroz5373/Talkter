import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkter/Services/auth/auth_service.dart';

final authServiceProvider = Provider((Ref ref) => AuthService());

// checks user is registered or not
final userStateProvider = StreamProvider<AppUser?>(
  (Ref ref) => ref.watch(authServiceProvider).user,
);
