import 'boilerplate.dart';
import 'RecipeManager.dart';

void main() async {
  
  // load the manager
  RecipeManager rcpmgr = await boilerplate_load();

  // do things

  // save the manager
  await boilerplate_save(rcpmgr);
  
  // exit program

}