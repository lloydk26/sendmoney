import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../dashboard/domain/entities/transaction_entity.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({
    super.key,
    required this.transactions,
    required this.onLogout,
  });

  final List<TransactionEntity> transactions;
  final VoidCallback onLogout;

  /// Groups transactions by "MMMM yyyy" label, most recent first.
  Map<String, List<TransactionEntity>> _groupByMonth() {
    final Map<String, List<TransactionEntity>> grouped = {};

    for (final tx in transactions) {
      final dt = DateTime.parse(tx.date);
      final label = DateFormat('MMMM yyyy').format(dt).toUpperCase();
      grouped.putIfAbsent(label, () => []).add(tx);
    }

    // Sort keys: most recent month first
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final dtA = DateFormat('MMMM yyyy').parse(a);
        final dtB = DateFormat('MMMM yyyy').parse(b);
        return dtB.compareTo(dtA);
      });

    return {for (final key in sortedKeys) key: grouped[key]!};
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByMonth();

    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.neutral,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurfacePrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Transactions',
          style: AppTextStyles.headline(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.onSurfacePrimary),
            onPressed: onLogout,
          ),
        ],
      ),
      body: transactions.isEmpty
          ? Center(
              child: Text(
                'No transactions yet.',
                style: AppTextStyles.body(AppColors.onSurfaceSecondary),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                for (final entry in grouped.entries) ...[
                  // Section header
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 8),
                    child: Text(
                      entry.key,
                      style: AppTextStyles.label(AppColors.onSurfaceSecondary)
                          .copyWith(letterSpacing: 1.2),
                    ),
                  ),
                  // Grouped card
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF131D35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < entry.value.length; i++) ...[
                          _TransactionRow(tx: entry.value[i]),
                          if (i < entry.value.length - 1)
                            const Divider(
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
              ],
            ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx});

  final TransactionEntity tx;

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.type == 'credit';
    final amountColor = isCredit ? Colors.greenAccent : Colors.redAccent;
    final amountPrefix = isCredit ? '+' : '-';

    // Parse combined date + time for display
    DateTime? parsedDateTime;
    try {
      parsedDateTime = DateTime.parse('${tx.date} ${tx.time}');
    } catch (_) {
      parsedDateTime = DateTime.tryParse(tx.date);
    }
    final formattedDate = parsedDateTime != null
        ? DateFormat('MMM dd, HH:mm').format(parsedDateTime)
        : '${tx.date}, ${tx.time}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: account name + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.accountName,
                  style: AppTextStyles.body(),
                ),
                const SizedBox(height: 2),
                Text(
                  formattedDate,
                  style: AppTextStyles.label(AppColors.onSurfaceSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right: amount
          Text(
            '$amountPrefix${tx.amount.toStringAsFixed(2)}',
            style: AppTextStyles.body(amountColor).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}