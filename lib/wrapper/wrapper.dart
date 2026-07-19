import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});
  Future<void> _refreshUser () async {
    await FirebaseAuth.instance.currentUser?.reload();
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return FutureBuilder(
        future: _refreshUser(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {

          }
        }

    ) ;
  }
}



