import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/drawer_state_provider.dart';

class DrawerItem extends StatelessWidget {
  final String tooltipMessage;
  final DrawerElement itemType;
  final IconData icon;
  final String title;
  final String routeName;

  DrawerItem({
    this.tooltipMessage,
    this.itemType,
    this.icon,
    this.title,
    this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    final currentDrawer =
        Provider.of<DrawerStateInfo>(context, listen: false).getCurrentDrawer;
    return Tooltip(
      message: this.tooltipMessage,
      child: ListTile(
        enabled: true,
        selected: currentDrawer == this.itemType,
        leading: Icon(
          icon,
          //color: Theme.of(context).accentColor,
        ),
        title: Text(this.title),
        onTap: () {
          Navigator.of(context).pop();
          if (currentDrawer == this.itemType) return;

          Provider.of<DrawerStateInfo>(context, listen: false)
              .setCurrentDrawer(this.itemType);

          Navigator.of(context).pushReplacementNamed(routeName);
        },
      ),
    );
  }
}
