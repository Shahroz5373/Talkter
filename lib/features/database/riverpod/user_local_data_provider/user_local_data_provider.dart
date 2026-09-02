import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talkter/features/database/local_storage/local_storage.dart';
import 'package:talkter/features/auth/models/user_info_model/user_info_model.dart';

part 'user_data_provider.g.dart';

@Riverpod(keepAlive: true)
Future<UserInfo?> userLocalData(Ref ref) async {
  final localStorage = UserLocalStorage();

  return await localStorage.getUser();
}
