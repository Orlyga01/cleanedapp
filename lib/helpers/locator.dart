import 'package:authentication/shared/locator.dart';

import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:cleanedapp/helpers/local_storage.dart';
import 'package:cleanedapp/tasks_list/task_list_controller.dart';

import 'package:get_it/get_it.dart';

final locator = GetIt.instance;
Future<void> setupServices() async {
  // if (!_registered) {
  await setupAuthServices();
  setupRepositoriesServices();
  GlobalParametersFM globalParams = GlobalParametersFM();
  locator.registerSingleton<GlobalParametersFM>(globalParams);
}
//}

resetServices() {
  locator.reset();
}

setupRepositoriesServices() {
  TaskListController taskListController = TaskListController();
  locator.registerSingleton<TaskListController>(taskListController);
  // FirebaseFamilyMemberRepository familymemberRepository =
  //     FirebaseFamilyMemberRepository();
  // locator.registerSingleton<FirebaseFamilyMemberRepository>(
  //     familymemberRepository);
}
