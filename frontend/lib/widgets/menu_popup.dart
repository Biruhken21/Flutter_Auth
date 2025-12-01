import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';

class MenuPopup extends StatelessWidget {
  final Function() onClose;

  const MenuPopup({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      'Create your team',
      'Groups',
      'Events',
      'Innovation hubs',
      'Startup news',
      'Top investor',
      'Top startups',
      'Premium',
      'Ads',
      'Logout',
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display 2 buttons per row
            for (int i = 0; i < menuItems.length; i += 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMenuButton(context, menuItems[i]),
                    ),
                    const SizedBox(width: 16.0),
                    if (i + 1 < menuItems.length)
                      Expanded(
                        child: _buildMenuButton(context, menuItems[i + 1]),
                      )
                    else
                      const Expanded(child: SizedBox()),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label) {
    return OutlinedButton(
      onPressed: () {
        // Handle button press
        if (label == 'Logout') {
          // Handle logout
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          authProvider.logout().then((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label selected'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
        onClose();
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0, // Increased vertical padding for larger buttons
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 16, // Increased font size
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
