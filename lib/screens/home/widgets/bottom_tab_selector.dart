import 'package:flutter/material.dart';
import 'package:gulmate/bloc/tab/app_tab.dart';

class BottomTabSelector extends StatelessWidget {

  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  BottomTabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: AppTab.values.map((tab) => BottomNavigationBarItem(
          icon: Icon(_buildIconData(tab)),
          title: Text(_getStringByAppTab(tab)),
        ),).toList(),
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFFF6D00),
      unselectedItemColor: Color.fromRGBO(204, 204, 204, 1),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      currentIndex: AppTab.values.indexOf(activeTab),
      type: BottomNavigationBarType.fixed);
  }

  IconData _buildIconData(AppTab tab) {
        switch(tab) {
          case AppTab.home:
            return Icons.home;
          case AppTab.calendar:
            return Icons.calendar_today;
          case AppTab.purchase:
            return Icons.shopping_basket;
          case AppTab.chatting:
            return Icons.message;
          case AppTab.settings:
            return Icons.settings;
          default:
            return Icons.home;
        }
  }

  String _getStringByAppTab(AppTab tab) {
    switch(tab) {
      case AppTab.home:
        return "홈";
      case AppTab.calendar:
        return "일정";
      case AppTab.purchase:
        return "장보기";
      case AppTab.chatting:
        return "채팅";
      case AppTab.settings:
        return "더보기";
      default:
        return "";
    }
  }
}
