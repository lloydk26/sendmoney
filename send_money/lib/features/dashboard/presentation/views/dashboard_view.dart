import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: AppTextStyles.headline().copyWith(fontSize: 20),
        ),
      ),
      body: Center(
        child: Text(
          'Welcome',
          style: AppTextStyles.body(),
        ),
      ),
    );
  }
}
