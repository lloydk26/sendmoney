import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/services/auth_service.dart';
import 'features/auth/presentation/cubits/login_cubit.dart';
import 'features/auth/presentation/views/login_view.dart';
import 'injection/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send Money',
      home: BlocProvider(
        create: (_) => LoginCubit(
          getIt<AuthService>(),
          getIt<SecureStorageService>(),
        ),
        child: const LoginView(),
      ),
    );
  }
}