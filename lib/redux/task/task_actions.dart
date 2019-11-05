import 'package:todoreminder/data/model/models.dart';
import 'package:todoreminder/redux/persistor/persistor_actions.dart';

class CreateTaskAction extends Persist {
  final TaskModel task;

  CreateTaskAction({
    this.task
  });
}

class UpdateTaskAction extends Persist {
  final TaskModel task;
  final TaskModel updates;

  UpdateTaskAction({
    this.task,
    this.updates
  });
}

class RemoveTaskAction extends Persist {
  final TaskModel task;

  RemoveTaskAction({
    this.task
  });
}
