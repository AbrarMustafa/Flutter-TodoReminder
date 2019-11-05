import 'package:redux_persist/redux_persist.dart';

import 'package:todoreminder/redux/task/task_reducers.dart';
import 'package:todoreminder/redux/category/category_reducers.dart';
import 'package:todoreminder/redux/calendar/calendar_reducers.dart';

import 'app_state.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is PersistLoadedAction) {
    return action.state ?? state;
  }

  return state.rebuild((builder) => builder
    ..task.replace(taskReducers(state.task, action))
    ..category.replace(categoryReducers(state.category, action))
    ..calendar.replace(calendarReducers(state.calendar, action))
  );
}
