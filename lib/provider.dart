import 'package:gulmate/services/auth_service.dart';
import 'package:gulmate/services/family_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


List<SingleChildStatelessWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildStatelessWidget> independentServices = [
  ChangeNotifierProvider<AuthService>(
      create: (context) =>
          AuthService(apiBaseUrl: "http://localhost:8080")),
];

List<SingleChildStatelessWidget> dependentServices = [
  ChangeNotifierProxyProvider<AuthService, FamilyService>(
      create: (context) =>
          FamilyService(apiBaseUrl: "http://localhost:8080"),
      update: (context, authService, familyService) => familyService..setToken(authService.currentToken)),
];

List<SingleChildStatelessWidget> uiConsumableProviders = [];
