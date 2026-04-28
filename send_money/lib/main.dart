import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/cache/wallet_cache_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_colors.dart';
import 'features/auth/domain/services/auth_service.dart';
import 'features/auth/presentation/cubits/login_cubit.dart';
import 'features/auth/presentation/views/login_view.dart';
import 'features/dashboard/domain/services/dashboard_service.dart';
import 'features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'features/dashboard/presentation/views/dashboard_view.dart';
import 'injection/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _token;
  bool _isCheckingToken = true;

  @override
  void initState() {
    super.initState();
    _bootstrapToken();
  }

  Future<void> _bootstrapToken() async {
    final token = await getIt<SecureStorageService>().getToken();
    if (!mounted) {
      return;
    }
    setState(() {
      _token = token;
      _isCheckingToken = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final home = _isCheckingToken
        ? const Scaffold(
            backgroundColor: AppColors.neutral,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        : _token != null
        ? BlocProvider(
            create: (_) => DashboardCubit(
              getIt<DashboardService>(),
              getIt<SecureStorageService>(),
              getIt<WalletCacheService>(),
            ),
            child: const DashboardView(),
          )
        : BlocProvider(
            create: (_) =>
                LoginCubit(getIt<AuthService>(), getIt<SecureStorageService>()),
            child: const LoginView(),
          );

    return MaterialApp(title: 'Send Money', home: home);
  }
}
