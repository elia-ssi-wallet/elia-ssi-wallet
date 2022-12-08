import 'package:get_it/get_it.dart';

import 'navigation_service.dart';

final locator = GetIt.I;

registerSingletons() {
  locator.registerLazySingleton(() => NavigationService());
}
