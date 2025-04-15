import '../code/Recipe.dart';
import '../code/RecipeManager.dart';
import '../code/SaveAndLoad.dart';

void main() async {

  RecipeManager manager = await boilerplate_load();

  manager.signup('john', '1234');
  manager.signup('mary', '5678');

  manager.addRecipe(Recipe('chocchip', {'tags','heyoh'}, 'url'));

  await boilerplate_save(manager);

  manager.signup('joey', '9898');

  manager.addRecipe(Recipe('bookie', {'tags','heyoh'}, 'url'));

  await boilerplate_save(manager);

}