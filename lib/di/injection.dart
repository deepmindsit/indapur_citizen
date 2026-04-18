import 'package:indapur_citizen/config/exported_path.dart';
import 'package:indapur_citizen/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
