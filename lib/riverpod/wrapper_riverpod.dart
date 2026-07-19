import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkter/services/auth/auth_service.dart';

final authServiceProvider = Provider((Ref ref)=>AuthService());

final userStateProvider =
  StreamProvider<AppUser?>((Ref ref)=> ref.watch(authServiceProvider).user);