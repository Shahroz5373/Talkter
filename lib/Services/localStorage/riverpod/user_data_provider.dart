import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talkter/Services/localStorage/local_storage.dart';
import 'package:talkter/screens/user_registeration/registration/riverpod/model/user_notifier_model.dart';

part 'user_data_provider.g.dart';

@Riverpod(keepAlive: true)
Future<UserInfo?> userLocalData(Ref ref) async {
  final localStorage = UserLocalStorage();

  return await localStorage.getUser();
}
