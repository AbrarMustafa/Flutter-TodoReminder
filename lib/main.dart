import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:todoreminder/redux/app/app_state.dart';
import 'package:todoreminder/pattren/middleware.dart';
import 'package:todoreminder/redux/app/app_reducers.dart';

import 'data/persistor.dart';
import 'redux/startup/startup_actions.dart';

import 'thingstodo.dart';

void main() async {
  final store = Store<AppState>(
    appReducers,
    initialState: AppState(),
    middleware: middleware,
  );

  // Load initial state
  persistor.load(store).then((value) {
    store.dispatch(StartupAction());
  });

  runApp(ThingsTodo(store: store));
}
