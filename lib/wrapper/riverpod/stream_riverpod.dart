import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkter/Services/auth/auth_service.dart';

final authServiceProvider = Provider((Ref ref) => AuthService());

// checks user is registered or not
final userStateProvider = StreamProvider<AppUser?>(
  (Ref ref) => ref.watch(authServiceProvider).user,
);

enum AppAuthState { unauthenticated, requiresProfile, authenticated }

final authStatusProvider = StreamProvider<AppAuthState>((Ref ref) {
  final appUser = ref.watch(userStateProvider).value;
  if (appUser == null) {
    return Stream.value(AppAuthState.unauthenticated);
  }
  return FirebaseFirestore.instance
      .collection('users')
      .doc(appUser.userId)
      .snapshots()
      .map(
        (doc) => doc.exists
            ? AppAuthState.authenticated
            : AppAuthState.requiresProfile,
      );
});
