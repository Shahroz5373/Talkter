import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkter/Services/auth/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

enum AppAuthState { unauthenticated, requiresProfile, authenticated }

final authStatusProvider = StreamProvider<AppAuthState>((ref) {
  final authService = ref.watch(authServiceProvider);

  return authService.user.asyncExpand((appUser) {
    if (appUser == null) {
      return Stream.value(AppAuthState.unauthenticated);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(appUser.phoneNumber)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            return AppAuthState.authenticated;
          }

          return AppAuthState.requiresProfile;
        });
  });
});
