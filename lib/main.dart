import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wonder_pod/presentation/choose_theme/bloc/theme_cubit.dart';
import 'package:wonder_pod/routes/app_router_config.dart';
import 'package:wonder_pod/service_locator.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  await initialiseDependencies();
  runApp(BlocProvider(
    create: (context) => ThemeCubit(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ThemeCubit())],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp.router(
          title: 'My Wonder',
          // theme: AppTheme.lightTheme,
          // darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          routerConfig: MyAppRouter.returnRouter(true), // Updated for GoRouter
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
