import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talkter/models/user_info.dart';

part 'user_notifier.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  UserInfo? build() {
    return null; // initial state
  }

  void setUser(UserInfo user) {
    state = user;
  }

  void updateUser({String? name, String? email}) {
    if (state == null) return;

    state = state!.copyWith(name: name, email: email);
  }

  void clearUser() {
    state = null;
  }
}
