import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:BSProOMS/model/DrawerItem.dart';

class DrawerItems{
  static const home = DrawerItem(title: 'Dashboard', icon: Icons.dashboard);
  static const browser = DrawerItem(title: 'BS Pro web', icon: FontAwesomeIcons.safari);
  static const customer = DrawerItem(title: 'Customer', icon: FontAwesomeIcons.userAlt);
  static const explore = DrawerItem(title: 'Explore', icon: Icons.explore);
  static const favourites = DrawerItem(title: 'Favourites', icon: Icons.favorite);
  static const messages = DrawerItem(title: 'Messages', icon: Icons.mail);
  static const profile = DrawerItem(title: 'Profile', icon: FontAwesomeIcons.userAlt);
  static const settings = DrawerItem(title: 'Settings', icon: Icons.settings);
  static const logout = DrawerItem(title: 'Logout', icon: Icons.logout);
  static const order = DrawerItem(title: 'Sale Order', icon: FontAwesomeIcons.cartPlus);
  static const product = DrawerItem(title: 'Product List', icon: FontAwesomeIcons.list);
  static const sync = DrawerItem(title: 'Sync', icon: FontAwesomeIcons.syncAlt);
  static const ledger = DrawerItem(title: 'Ledger Detail', icon: FontAwesomeIcons.balanceScale);
  static final List<DrawerItem> all = [
    home,
    ledger,
    product,
    // customer,
    order,
    // browser,
    // favourites,
    // messages,
    // profile,
    // sync,
    settings,
    logout
  ];
}