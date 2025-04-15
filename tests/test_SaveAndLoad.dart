import '../code/RecipeManager.dart';
import '../code/SaveAndLoad.dart';

void main() async {

  RecipeManager manager = await loadDatabase();

  manager.signup('john', '1234');
  manager.signup('mary', '5678');

  manager.addRecipe('chocchip', {'tags','heyoh'}, 'url');

  await saveDatabase(manager);

  manager.signup('joey', '9898');

  manager.addRecipe('bookie', {'tags','heyoh'}, 'url');

  await saveDatabase(manager);

}