import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/bloc/calendar/calendar.dart';
import 'package:gulmate/bloc/purchase/purchase.dart';
import 'package:gulmate/bloc/tab/app_tab.dart';
import 'package:gulmate/repository/calendar_repository.dart';
import 'package:gulmate/repository/purchase_repository.dart';
import 'package:gulmate/screens/home/calendar/calendar_screen.dart';
import 'package:gulmate/screens/home/chat/chat_screen.dart';
import 'package:gulmate/screens/home/purchase/purchase_screen.dart';
import 'package:gulmate/screens/home/widgets/bottom_tab_selector.dart';
import 'package:gulmate/widgets/placeholder_widget.dart';

import 'dashboard/dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purchaseRepository = GetIt.instance.get<PurchaseRepository>();
    final calendarRepository = GetIt.instance.get<CalendarRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider<PurchaseBloc>(
            create: (context) => PurchaseBloc(purchaseRepository,
                appTabBloc: BlocProvider.of<AppTabBloc>(context))),
        BlocProvider<FilteredPurchaseBloc>(
          create: (context) =>
              FilteredPurchaseBloc(BlocProvider.of<PurchaseBloc>(context)),
        ),
        BlocProvider<CalendarBloc>(
          create: (context) => CalendarBloc(calendarRepository,
              appTabBloc: BlocProvider.of<AppTabBloc>(context)),
        ),
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
        return PlaceholderWidget(Colors.cyan);
      default:
        return DashboardScreen();
    }
  }
}
