import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/tab/app_tab.dart';
import 'package:gulmate/screens/home/calendar/calendar_screen.dart';
import 'package:gulmate/screens/home/purchase/purchase_screen.dart';
import 'package:gulmate/screens/home/widgets/bottom_tab_selector.dart';
import 'package:gulmate/widgets/placeholder_widget.dart';

import 'dashboard/dashboard_screen.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppTabBloc, AppTab>(
      builder: (context, activeTab)
        => Scaffold(
          backgroundColor: Color.fromRGBO(245, 245, 245, 1),
          bottomNavigationBar: BottomTabSelector(activeTab: activeTab, onTabSelected: (tab) => BlocProvider.of<AppTabBloc>(context).add(UpdateTab(tab))),
          body: _buildBody(activeTab),
        ),
    );
  }

  Widget _buildBody(AppTab activeTab) {
    switch(activeTab) {
      case AppTab.home:
        return DashboardScreen();
      case AppTab.calendar:
        return CalendarScreen();
      case AppTab.purchase:
        return PurchaseScreen();
      case AppTab.chatting:
        return PlaceholderWidget(Colors.greenAccent);
      case AppTab.settings:
        return PlaceholderWidget(Colors.cyan);
      default:
        return DashboardScreen();
    }
  }
}
