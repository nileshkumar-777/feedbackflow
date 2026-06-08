import 'package:get_it/get_it.dart';
import 'database_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Registers DatabaseService as a lazy singleton (created once, only when needed)
  locator.registerLazySingleton<DatabaseService>(() => DatabaseService());
}
