import 'dart:ui';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:flutter/material.dart';

class CustomBackgroundWithAppBar extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onBackTap;
  final List<Widget>? actions;

  const CustomBackgroundWithAppBar({
    super.key,
    required this.title,
    required this.child,
    this.onBackTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppTheme.primaryColor.withValues(alpha: 0.05),
              AppTheme.primaryColor.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            bottom: 15,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            border: Border(
              bottom: BorderSide(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              if (onBackTap != null)
                GestureDetector(
                  onTap: onBackTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              if (onBackTap != null) const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: Fonts.boldTextStyle(
                    fontSize: 22,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}
