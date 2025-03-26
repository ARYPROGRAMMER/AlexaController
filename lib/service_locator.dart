// TODO: Implement GetIt instance and override intialiseDependencies - registerSingleton all usecases

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initialiseDependencies() async {
  //TODO: Sample Service Loading
  // sl.registerLazySingleton<AuthAwsService>(AuthAwsServiceImpl());
  // sl.registerLazySingleton<SignInUseCase>(SignInUseCase());
  // sl.registerLazySingleton<SignupUseCase>(SignupUseCase());
  // sl.registerLazySingleton<AuthRepository>(AuthAwsServiceImpl());
}
