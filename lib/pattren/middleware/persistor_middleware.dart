import 'package:redux/redux.dart';

import 'package:todoreminder/data/persistor.dart';
import 'package:todoreminder/redux/app/app_state.dart';
import 'package:todoreminder/redux/persistor/persistor_actions.dart';

class PersistorMiddleware extends MiddlewareClass<AppState>{
  var middleware = persistor.createMiddleware();

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if(action is Persist){
      middleware(store, action, next);
    } else {
      next(action);
    }
  }
}
