import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/menu_popup.dart';

class NewcomerAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearchIcon;
  final bool showNotificationIcon;
  final bool showMenuIcon;

  const NewcomerAppBar({
    Key? key,
    this.title = 'Newcomer',
    this.showSearchIcon = true,
    this.showNotificationIcon = true,
    this.showMenuIcon = true,
  }) : super(key: key);

  @override
  State<NewcomerAppBar> createState() => _NewcomerAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _NewcomerAppBarState extends State<NewcomerAppBar> {
  bool _showMenu = false;

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
    
    if (_showMenu) {
      // Show the menu as an overlay
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MenuPopup(
            onClose: () {
              Navigator.of(context).pop();
              setState(() {
                _showMenu = false;
              });
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (widget.showSearchIcon)
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        if (widget.showNotificationIcon)
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'developers',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'investors',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.showMenuIcon)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: _toggleMenu,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
