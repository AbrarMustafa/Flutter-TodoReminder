import 'package:todoreminder/data/model/models.dart';
import 'package:todoreminder/redux/persistor/persistor_actions.dart';

class CategoryInitialStateAction extends Persist {}

class CreateCategoryAction extends Persist {
  final CategoryModel category;

  CreateCategoryAction({
    this.category
  });
}

class UpdateCategoryAction extends Persist {
  final CategoryModel category;
  final CategoryModel updates;

  UpdateCategoryAction({
    this.category,
    this.updates
  });
}

class RemoveCategoryAction extends Persist {
  final CategoryModel category;

  RemoveCategoryAction({
    this.category
  });
}
