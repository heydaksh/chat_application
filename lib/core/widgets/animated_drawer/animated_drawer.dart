import 'dart:math';

import 'package:chat_application/app/modules/home/home_controller.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedDrawer extends GetView<HomeController> {
  final Widget child;
  const AnimatedDrawer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // ─── 1. DRAWER BACKGROUND ───
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.8),
                  AppTheme.primaryColor,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // ─── 2. DRAWER CONTENT ───
          SafeArea(
            child: SizedBox(
              width: size.width / 1.7,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                              "https://images.pexels.com/photos/15393590/pexels-photo-15393590/free-photo-of-photo-of-a-shirtless-handsome-man-against-the-sky.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                            ),
                            radius: 50,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "User",
                            style: Fonts.boldTextStyle(
                              color: AppTheme.textOnBackground,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          _DrawerItem(
                            icon: Icons.person,
                            title: "Profile",
                            onTap: () => controller.goToProfile(),
                          ),
                          _DrawerItem(
                            icon: Icons.chat,
                            title: "Chat",
                            onTap: () => controller.goToChat(),
                          ),
                          _DrawerItem(
                            icon: Icons.settings,
                            title: "Settings",
                            onTap: () {
                              // Settings transition can be added here
                            },
                          ),
                          _DrawerItem(
                            icon: Icons.logout,
                            title: "Logout",
                            onTap: () => _showLogoutDialog(context),
                          ),
                          _DrawerItem(
                            icon: Icons.delete_forever,
                            title: "Delete Account",

                            onTap: () => _showDeleteDialog(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── 3. ANIMATED HOME SCREEN ───
          Obx(
            () => TweenAnimationBuilder(
              curve: Curves.easeOutQuad,
              tween: Tween<double>(begin: 0, end: controller.drawerValue.value),
              duration: const Duration(milliseconds: 500),
              builder: (_, val, _) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..setEntry(0, 3, 200 * val)
                    ..rotateY((pi / 6) * val),
                  child: AbsorbPointer(
                    absorbing: val > 0.1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(val * 20),
                      child: child,
                    ),
                  ),
                );
              },
            ),
          ),

          // ─── 4. GESTURE DETECTOR ───
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 50) {
                controller.drawerValue.value = 1;
              } else if (details.delta.dx < -40) {
                controller.drawerValue.value = 0;
              }
            },
          ),
        ],
      ),
    );
  }

  // log out dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Logging Out", style: Fonts.boldTextStyle()),
        content: Text(
          "Are you sure you want to log out?",
          style: Fonts.regularTextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No", style: Fonts.semiBoldTextStyle()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Yes",
              style: Fonts.semiBoldTextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // delete dialoge
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Deleting Account", style: Fonts.boldTextStyle()),
        content: Text(
          "Are you sure you want to delete your account?",
          style: Fonts.regularTextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No", style: Fonts.semiBoldTextStyle()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Yes",
              style: Fonts.semiBoldTextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppTheme.textOnBackground),
      title: Text(
        title,
        style: Fonts.regularTextStyle(color: AppTheme.textOnBackground),
      ),
    );
  }
}
