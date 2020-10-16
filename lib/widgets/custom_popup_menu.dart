import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/theme_provider.dart';

class CustomPopupMenu extends StatefulWidget {
  @override
  _CustomPopupMenuState createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  @override
  Widget build(BuildContext context) {
    // var _isChecked =
    //     Provider.of<ThemeProvider>(context, listen: false).getCurrentTheme ==
    //         ThemeMode.dark;
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          // case 'Theme':
          //   setState(() {
          //     Provider.of<ThemeProvider>(context, listen: false).switchMode();
          //   });
          //   break;
          case 'About':
            showAboutDialog(
              context: context,
              applicationIcon: Container(
                  height: 40, child: Image.asset('assets/images/meal.png')),
              applicationVersion: '0.1.0',
              applicationName: 'Cookbook',
              applicationLegalese:
                  'This app is intended for demonstration purposes only. Any other uses violate the licenses used.',
            );
            break;
        }
      },
      tooltip: 'More Options',
      itemBuilder: (ctx) => <PopupMenuItem<String>>[
        // CheckedPopupMenuItem<String>(
        //   child: const Text('Toggle dark mode'),
        //   value: 'Theme',
        //   checked: _isChecked,
        // ),
        PopupMenuItem(
          child: const ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About')),
          value: 'About',
        )
      ],
    );
  }
}
