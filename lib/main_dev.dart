import 'helper/environment.dart';
import 'main_common.dart';


//void main() {
//
//  BlocSupervisor.delegate = SimpleBlocDelegate();
//  Dio baseDio = Dio(BaseOptions(baseUrl: "http://192.168.0.111:8080"));
//  baseDio.interceptors.add(InterceptorsWrapper(
//    onRequest: (RequestOptions options) {
//      final userRepository = GetIt.instance.get<UserRepository>();
//      if(userRepository.token != null) {
//        options.headers['Authorization'] = 'Bearer ${userRepository.token}';
//      }
//      return options;
//    },
//  ));
//  GetIt.instance.registerSingleton(UserRepository(baseDio));
//  GetIt.instance.registerSingleton(FamilyRepository(baseDio));
//  GetIt.instance.registerSingleton(PurchaseRepository(baseDio));
//  GetIt.instance.registerSingleton(CalendarRepository(baseDio));
//  GetIt.instance.registerSingleton(ChatRepository(baseDio));
//  runApp(AuthWrapper(child: App()));
//}

Future<void> main() async {
  await mainCommon(Environment.dev);
}