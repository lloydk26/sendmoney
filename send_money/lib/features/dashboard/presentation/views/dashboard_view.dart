import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/theme/app_button_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../injection/injection.dart';
import '../../../auth/domain/services/auth_service.dart';
import '../../../auth/presentation/cubits/login_cubit.dart';
import '../../../auth/presentation/views/login_view.dart';
import '../../../send_money/domain/services/send_money_service.dart';
import '../../../send_money/presentation/cubits/send_money_cubit.dart';
import '../../../send_money/presentation/views/send_money_view.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/wallet_entity.dart';
import '../cubits/dashboard_cubit.dart';
import '../models/dashboard_state.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _balanceVisible = true;
  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadWalletData();
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        state.whenOrNull(
          loggedOut: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => BlocProvider(
                create: (_) => LoginCubit(
                  getIt<AuthService>(),
                  getIt<SecureStorageService>(),
                ),
                child: const LoginView(),
              ),
            ),
            (route) => false,
          ),
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.neutral,
          appBar: _buildAppBar(context),
          body: state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            success: (wallet) => _buildBody(wallet),
            error: (message) => _buildError(context, message),
            loggedOut: () => const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.neutral,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.account_balance, color: AppColors.primary, size: 22),
          const SizedBox(width: 8),
          Text('PadalaQ', style: AppTextStyles.headline(AppColors.primary)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.onSurfacePrimary),
          onPressed: () => context.read<DashboardCubit>().logout(),
        ),
      ],
    );
  }

  Widget _buildBody(WalletEntity wallet) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBalanceCard(wallet),
          const SizedBox(height: 16),
          _buildSendMoneyRow(wallet),
          const SizedBox(height: 24),
          _buildTransactionsSection(wallet),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(WalletEntity wallet) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131D35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'TOTAL WALLET BALANCE',
                          style: AppTextStyles.label(AppColors.onSurfaceSecondary)
                              .copyWith(letterSpacing: 1.2),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _balanceVisible = !_balanceVisible),
                        child: Icon(
                          _balanceVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.onSurfaceSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _balanceVisible
                      ? RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: wallet.balance.toStringAsFixed(0),
                                style: AppTextStyles.headline().copyWith(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' PHP',
                                style: AppTextStyles.body(
                                    AppColors.onSurfaceSecondary),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          '****** PHP',
                          style: AppTextStyles.headline().copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            SizedBox(
              height: 36,
              width: double.infinity,
              child: CustomPaint(painter: _WavePainter()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendMoneyRow(WalletEntity wallet) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) => SendMoneyCubit(getIt<SendMoneyService>()),
            child: SendMoneyView(availableBalance: wallet.balance),
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.neutralDark1,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send,
                  color: AppColors.onAccentFill, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Send Money',
                    style: AppTextStyles.body()
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.onSurfaceSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsSection(WalletEntity wallet) {
    final shown = wallet.transactions.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent Transactions',
                style:
                    AppTextStyles.body().copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(
              onTap: _showComingSoon,
              child: Text('View All',
                  style: AppTextStyles.label(AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.neutralDark1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: shown.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No transactions yet.',
                    style:
                        AppTextStyles.body(AppColors.onSurfaceSecondary),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    for (int i = 0; i < shown.length; i++) ...[
                      _buildTransactionRow(shown[i]),
                      if (i < shown.length - 1)
                        Divider(
                          height: 1,
                          color: AppColors.neutral,
                          indent: 16,
                          endIndent: 16,
                        ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildTransactionRow(TransactionEntity tx) {
    final isCredit = tx.type == 'credit';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.accountName, style: AppTextStyles.body()),
                const SizedBox(height: 2),
                Text(
                  '${tx.date}, ${tx.time}',
                  style: AppTextStyles.label(AppColors.onSurfaceSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'} ${tx.amount.toStringAsFixed(2)}',
                style: AppTextStyles.body(
                  isCredit ? Colors.greenAccent : Colors.redAccent,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Completed',
                  style: AppTextStyles.label(Colors.greenAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message,
                style: AppTextStyles.body(), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: FilledButton(
                style: AppButtonStyles.primary(),
                onPressed: () =>
                    context.read<DashboardCubit>().loadWalletData(),
                child: Text('Retry',
                    style: AppTextStyles.body(AppColors.onAccentFill)),
              ),
            ),
          ],
        ),
      ),
    );
  }


}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.onSurfacePrimary.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.6)
      ..cubicTo(
        size.width * 0.2, size.height * 0.1,
        size.width * 0.35, size.height,
        size.width * 0.5, size.height * 0.5,
      )
      ..cubicTo(
        size.width * 0.65, 0,
        size.width * 0.8, size.height,
        size.width, size.height * 0.4,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => false;
}
