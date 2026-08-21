import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talkter/screens/user_registeration/registration/riverpod/model/user_notifier_model.dart';

part 'user_notifier.g.dart';

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  @override
  UserInfo? build() {
    return null;
  }

  void setPhone({required String phoneNo}) {
    state = UserInfo(name: '', email: '', userName: '', phone: phoneNo);
  }

  void updateUser({
    required String name,
    required String email,
    required String userName,
  }) {
    if (state == null) return;

    state = state!.copyWith(name: name, email: email, userName: userName);
  }

  void clearUser() {
    state = null;
  }
}
