import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/bloc/calendar/calendar.dart';
import 'package:gulmate/bloc/purchase/purchase.dart';
import 'package:gulmate/bloc/tab/app_tab.dart';
import 'package:gulmate/screens/home/calendar/calendar_screen.dart';
import 'package:gulmate/screens/home/chat/chat_screen.dart';
import 'package:gulmate/screens/home/purchase/purchase_screen.dart';
import 'package:gulmate/screens/home/settings_new/settings_screen.dart';
import 'package:gulmate/screens/home/widgets/bottom_tab_selector.dart';

import 'dashboard/dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>(
          create: (BuildContext context) =>
              DashboardBloc(BlocProvider.of<AppTabBloc>(context)),
        ),
        BlocProvider<PurchaseBloc>(
            create: (context) => PurchaseBloc(
                  appTabBloc: BlocProvider.of<AppTabBloc>(context),
                  authBloc: BlocProvider.of<AuthenticationBloc>(context),
                )),
        BlocProvider<FilteredPurchaseBloc>(
          create: (context) =>
              FilteredPurchaseBloc(BlocProvider.of<PurchaseBloc>(context)),
        ),
        BlocProvider<CalendarBloc>(
            create: (context) => CalendarBloc(
                  appTabBloc: BlocProvider.of<AppTabBloc>(context),
                  authBloc: BlocProvider.of<AuthenticationBloc>(context),
                )),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(
            appTabBloc: BlocProvider.of<AppTabBloc>(context),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          ),
        ),
      ],
      child: BlocBuilder<AppTabBloc, AppTab>(
        builder: (context, activeTab) => Scaffold(
          backgroundColor: Color.fromRGBO(245, 245, 245, 1),
          bottomNavigationBar: BottomTabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<AppTabBloc>(context).add(UpdateTab(tab))),
          body: _buildBody(activeTab),
        ),
      ),
    );
  }

  Widget _buildBody(AppTab activeTab) {
    switch (activeTab) {
      case AppTab.home:
        return DashboardScreen();
      case AppTab.calendar:
        return CalendarScreen();
      case AppTab.purchase:
        return PurchaseScreen();
      case AppTab.chatting:
        return ChatScreen();
      case AppTab.settings:
        return SettingsScreen();
      default:
        return DashboardScreen();
    }
  }
}
