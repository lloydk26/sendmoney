import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:send_money/features/dashboard/presentation/cubits/dashboard_cubit.dart';

import '../../../../core/theme/app_button_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubits/send_money_cubit.dart';
import '../models/send_money_state.dart';

class SendMoneyView extends StatefulWidget {
  const SendMoneyView({super.key, required this.availableBalance, required this.onLogout,});

  final double availableBalance;
  final VoidCallback onLogout;

  @override
  State<SendMoneyView> createState() => _SendMoneyViewState();
}

class _SendMoneyViewState extends State<SendMoneyView> {
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  bool _amountExceedsBalance = false;

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged(String value) {
    final amount = double.tryParse(value) ?? 0;
    setState(() => _amountExceedsBalance = amount > widget.availableBalance);
  }

  bool get _isFormValid =>
      _accountController.text.isNotEmpty &&
      _amountController.text.isNotEmpty &&
      !_amountExceedsBalance;

  void _submit(BuildContext context) {
    final accountNumber = int.parse(_accountController.text);
    final amount = double.parse(_amountController.text);
    context.read<SendMoneyCubit>().sendMoney(accountNumber, amount);
  }

  void _showSuccessSheet(BuildContext screenCtx, double amount) {
    showModalBottomSheet<void>(
      context: screenCtx,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _SuccessBottomSheet(
        amount: amount,
        onDone: () {
          Navigator.of(sheetCtx).pop();
          Navigator.of(screenCtx).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendMoneyCubit, SendMoneyState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_, amount) => _showSuccessSheet(context, amount),
          error: (message) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Scaffold(
          backgroundColor: AppColors.neutral,
          appBar: AppBar(
            backgroundColor: AppColors.neutral,
            elevation: 0,
            centerTitle: true,
            title: Text('Send Money', style: AppTextStyles.headline()),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppColors.onSurfacePrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.onSurfacePrimary),
                onPressed: widget.onLogout,
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBalanceSection(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: _buildFormCard(),
                ),
              ),
              _buildSendButton(context, isLoading),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            'AVAILABLE BALANCE',
            style: AppTextStyles.label(AppColors.onSurfaceSecondary)
                .copyWith(letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.availableBalance.toStringAsFixed(0)} PHP',
            style: AppTextStyles.headline(AppColors.onSurfacePrimary).copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.neutralDark1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account Number', style: AppTextStyles.label()),
          const SizedBox(height: 8),
          AppTextField(
            controller: _accountController,
            hintText: 'Enter account number',
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.account_balance,
                color: AppColors.onSurfaceSecondary),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Text('Amount', style: AppTextStyles.label()),
          const SizedBox(height: 8),
          AppTextField(
            controller: _amountController,
            hintText: '0.00',
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '₱',
                style: AppTextStyles.body(AppColors.onSurfaceSecondary),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}')),
            ],
            onChanged: _onAmountChanged,
          ),
          if (_amountExceedsBalance) ...[
            const SizedBox(height: 6),
            Text(
              'Amount exceeds your available balance',
              style: AppTextStyles.label(Colors.redAccent)
                  .copyWith(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSendButton(BuildContext context, bool isLoading) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SizedBox(
          height: 52,
          child: FilledButton(
            style: AppButtonStyles.primary(),
            onPressed:
                _isFormValid && !isLoading ? () => _submit(context) : null,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onAccentFill,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Send Money',
                        style: AppTextStyles.label(AppColors.onAccentFill)
                            .copyWith(
                          fontSize: AppTextStyles.bodySize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward,
                          size: 18, color: AppColors.onAccentFill),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _SuccessBottomSheet extends StatelessWidget {
  const _SuccessBottomSheet({
    required this.amount,
    required this.onDone,
  });

  final double amount;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('MMM dd, HH:mm').format(DateTime.now());

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        32,
        24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: AppColors.neutralDark1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(Icons.check,
                color: AppColors.onAccentFill, size: 36),
          ),
          const SizedBox(height: 20),
          Text('Transfer Successful', style: AppTextStyles.headline()),
          const SizedBox(height: 8),
          Text(
            'Funds are now available to the recipient.',
            style: AppTextStyles.label(AppColors.onSurfaceSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '${amount.toStringAsFixed(2)} PHP',
            style: AppTextStyles.headline(AppColors.primary).copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: AppColors.neutral, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Date & Time',
                  style: AppTextStyles.label(AppColors.onSurfaceSecondary)),
              const Spacer(),
              Text(formatted, style: AppTextStyles.label()),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              style: AppButtonStyles.primary(),
              onPressed: onDone,
              child: Text(
                'Done',
                style: AppTextStyles.label(AppColors.onAccentFill).copyWith(
                  fontSize: AppTextStyles.bodySize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
