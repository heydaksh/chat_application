import 'package:chat_application/app/modules/chat/chat_module.dart';
import 'package:chat_application/app/modules/friends/friends_screen.dart';
import 'package:chat_application/app/modules/home/home_controller.dart';
import 'package:chat_application/app/modules/profile/profile_screen.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:chat_application/core/widgets/animated_drawer/animated_drawer.dart';
import 'package:chat_application/core/widgets/bottom_navigation/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => controller.toggleDrawer(),
          ),
          title: Obx(() {
            switch (controller.currentTab.value) {
              case 0:
                return const Text('Home');
              case 1:
                return const Text("Chat(s)");
              case 2:
                return Text('Friends');
              case 3:
                return const Text('Profile');
              default:
                return const Text('Home');
            }
          }),
        ),
        body: Obx(
          () => IndexedStack(
            index: controller.currentTab.value,
            children: [
              const _HomeView(),
              const ChatScreen(),
              const FriendsScreen(),
              ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => CustomBottomNavBar(
            currentIndex: controller.currentTab.value,
            onTap: controller.changeTab,
          ),
        ),
      ),
    );
  }
}

class _HomeView extends GetView<HomeController> {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height / 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Good Morning, User',
                  style: Fonts.boldTextStyle(
                    fontSize: 28,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height / 100),
            Text(
              'Search for Chats',
              style: Fonts.semiBoldTextStyle(
                fontSize: 20,
                color: AppTheme.primaryColor.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: size.height / 40),

            const SearchBar(hintText: 'Search'),
            SizedBox(height: size.height / 20),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Recent Chats',
                    style: Fonts.semiBoldTextStyle(
                      fontSize: 20,
                      color: AppTheme.primaryColor.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: size.height / 30),
                  Container(
                    padding: const EdgeInsets.all(8),
                    height: size.height / 2.2,
                    width: size.width / 1.1,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primaryColor),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            radius: size.width / 15,
                            backgroundImage: const NetworkImage(
                              'https://images.pexels.com/photos/15393590/pexels-photo-15393590/free-photo-of-photo-of-a-shirtless-handsome-man-against-the-sky.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                            ),
                          ),
                          title: Text(
                            'User',
                            style: Fonts.boldTextStyle(
                              fontSize: 20,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          subtitle: Text(
                            'Hello',
                            style: Fonts.regularTextStyle(
                              fontSize: 16,
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
