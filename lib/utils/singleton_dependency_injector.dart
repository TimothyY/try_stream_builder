import 'package:get_it/get_it.dart';
import 'package:try_stream_builder/localdb/database_helper.dart';

GetIt getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}