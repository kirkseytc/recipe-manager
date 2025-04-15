import 'SaveAndLoad.dart';
import 'RecipeManager.dart';

void main() async {
  
  // load the manager
  RecipeManager manager = await loadDatabase();

  // do things
  

  // save the manager
  await saveDatabase(manager);
  
  // exit program

}