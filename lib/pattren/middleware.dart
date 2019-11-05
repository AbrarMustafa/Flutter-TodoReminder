import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';


import 'package:todoreminder/pattren/middleware/persistor_middleware.dart';
import 'package:todoreminder/pattren/middleware/startup_middleware.dart';
import 'package:todoreminder/redux/app/app_state.dart';


List<Middleware<AppState>> middleware = []
  ..add(LoggingMiddleware.printer())
  ..add(PersistorMiddleware())
  ..add(StartupMiddleware());
