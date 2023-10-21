import 'package:get_it/get_it.dart';
import 'package:simp_quiz_app/services/auth_serivces.dart';
import 'package:simp_quiz_app/user_provider.dart';

final getIt = GetIt.instance;
void setupLocators() {
  getIt.registerSingleton<AuthServices>(AuthServices());
  // getIt.registerSingleton<UserData>(UserData());
}
