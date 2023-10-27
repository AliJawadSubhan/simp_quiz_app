import 'package:get_it/get_it.dart';
import 'package:simp_quiz_app/internet_cubit.dart';
import 'package:simp_quiz_app/services/auth_serivces.dart';
 GetIt getIt = GetIt.I;
void setupLocators() {
  getIt.registerSingleton<AuthServices>(AuthServices());
    getIt.registerFactory(() => InternetCubit());
  // getIt.registerSingleton<UserData>(UserData());
}
