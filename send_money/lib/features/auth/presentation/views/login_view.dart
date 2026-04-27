import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_button_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../dashboard/presentation/views/dashboard_view.dart';
import '../cubits/login_cubit.dart';
import '../models/login_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const DashboardView(),
              ),
            );
          },
          error: (message) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.secondaryDark3,
                ),
              );
          },
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.neutral,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Icon(
                    Icons.account_balance,
                    size: 56,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'AETHER',
                    style: AppTextStyles.headline(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.neutralDark1,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'IDENTIFIER',
                          style: AppTextStyles.label().copyWith(
                            letterSpacing: 1.2,
                            color: AppColors.onSurfaceSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _userController,
                          hintText: 'Username or Email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: AppColors.onSurfaceSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'PASSCODE',
                                style: AppTextStyles.label().copyWith(
                                  letterSpacing: 1.2,
                                  color: AppColors.onSurfaceSecondary,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Recover',
                                style: AppTextStyles.label(AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.onSurfaceSecondary,
                          ),
                          onSubmitted: (_) => _submitIfIdle(context),
                        ),
                        const SizedBox(height: 28),
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            final loading = state.maybeWhen(
                              loading: () => true,
                              orElse: () => false,
                            );
                            return SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton(
                                style: AppButtonStyles.primary(),
                                onPressed: loading
                                    ? null
                                    : () => _submitIfIdle(context),
                                child: loading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.onAccentFill,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'SIGN IN',
                                            style:
                                                AppTextStyles.label(AppColors.onAccentFill)
                                                    .copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: AppTextStyles.bodySize,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 20,
                                            color: AppColors.onAccentFill,
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitIfIdle(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final current = cubit.state;
    if (current.maybeWhen(loading: () => true, orElse: () => false)) {
      return;
    }
    cubit.login(
      _userController.text.trim(),
      _passwordController.text,
    );
  }
}
