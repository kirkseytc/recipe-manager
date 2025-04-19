import 'dart:io';

import 'Recipe.dart';
import 'RecipeManager.dart';
import 'SaveAndLoad.dart';

late RecipeManager manager;

void main() async {
  manager = await loadDatabase();

  if (manager.recipes.isEmpty) {
    manager.addRecipe('Spaghetti', {'italian', 'dinner'}, 'https://www.inspiredtaste.net/38940/spaghetti-with-meat-sauce-recipe/');
    manager.addRecipe('Avocado Toast', {'breakfast', 'vegetarian'}, 'https://cookieandkate.com/avocado-toast-recipe/');
    manager.addRecipe('Chicken Tikka Masala', {'indian', 'spicy'}, 'https://www.recipetineats.com/chicken-tikka-masala/');
    manager.addRecipe('Tacos al Pastor', {'mexican', 'street food'}, 'https://tastesbetterfromscratch.com/tacos-al-pastor/');
    manager.addRecipe('Sushi Roll', {'japanese', 'seafood'}, 'https://www.fifteenspatulas.com/homemade-sushi/');
    manager.addRecipe('Lasagna', {'italian', 'pasta', 'baked'}, 'https://thecozycook.com/easy-lasagna-recipe/');
    manager.addRecipe('Carbonara', {'italian', 'pasta', 'eggs'}, 'https://www.recipetineats.com/carbonara/');
    manager.addRecipe('Enchiladas Rojas', {'mexican', 'spicy', 'cheesy'}, 'https://www.muydelish.com/enchiladas-rojas/');
    manager.addRecipe('Pulled Pork Sandwich', {'american', 'barbecue', 'slow-cooked'}, 'https://mytastytrials.com/2020/04/28/best-bbq-pulled-pork-sammies/');
    manager.addRecipe('Chicken and Waffles', {'american', 'comfort', 'breakfast'}, 'https://www.sweetteaandthyme.com/fried-chicken-waffles-spicy-honey-sauce/');
    manager.addRecipe('Meatloaf', {'american', 'dinner', 'classic'}, 'https://natashaskitchen.com/meatloaf-recipe/');
    manager.addRecipe('Cornbread', {'american', 'southern', 'bread'}, 'https://www.allrecipes.com/recipe/17891/golden-sweet-cornbread/'); 

    await saveDatabase(manager); // 💾 Save to JSON
    print('Database Empty! Sample recipes added!');
  }

  while (true) {
    //final isLoggedIn = manager.loggedInUser != null;
    final options = manager.loggedInUser != null
      ? ['Search Recipes', 'Browse Recipes', 'View Saved Recipes', 'Add Recipe', 'Logout', 'Quit']
      : ['Login', 'Signup', 'Quit'];

    int selection = showMenu(options, 'Recipe Manager');

    final choice = options[selection];

    if (choice == 'Login') {
      handleLogin();
      print('');
    } else if (choice == 'Signup') {
      handleSignup();
      print('');
    } else if (choice == 'Search Recipes') {
      searchRecipes();
    } else if (choice == 'Browse Recipes') {
      browseRecipes();
    } else if (choice == 'View Saved Recipes') {
      viewSavedRecipes();
    } else if (choice == 'Add Recipe') {
      await addRecipe();
    } else if (choice == 'Logout') {
      manager.logout();
    } else if (choice == 'Quit') {
      await quit();
      return;
    }
  }
}

//~~~~~~~~~~~~~~~Menu UI~~~~~~~~~~~~~~~~~
int showMenu(List<String> options, String title) {
  clearScreen();

  int selected = 0;
  int i = 1;
  
  // no user logged in
  if(options[0] == 'Login'){
    print('Welcome to Recipe Manager!');
  } else {

    print('Welcome ${manager.loggedInUser?.username}!');
  }

  print('');
    
  for(String option in options){
    print('$i. $option');
    i++;
  }
  
  print('');

  String? input = null; 
  while(input == null){
    stdout.write('Enter the number associated with option you\'d like to use: ');
    input = stdin.readLineSync();
  }

  print('');

  selected = int.parse(input) - 1;

  if(selected < 0 || selected >= options.length){
    selected = 0;
  }

  return selected;
}

//~~~~~~~~~~~~Login~~~~~~~~~~~~~~
void handleLogin() {
  
  clearScreen();
  print('[Login]\n');

  stdout.write('Username: ');
  String? username = stdin.readLineSync();
  stdout.write('Password: ');
  String? password = stdin.readLineSync();

  if(username == null){
    print('No username provided. Login Failed.');
    return;
  }

  if(password == null){
    print('No password provided. Login Failed.');
    return;
  }

  int result = manager.login(username, password);

  switch(result){
    case 0:
      break;
    case 1:
      print('Incorrect password. Login Failed.');
      break;
    case 2:
      print('User does not exist. Login Failed.');
      break;
  }

}

//~~~~~~~~~~~~~~SignUp~~~~~~~~~~~~~~
void handleSignup() {

  clearScreen();
  print('[Signup]\n');
  
  stdout.write('Username: ');
  String? username = stdin.readLineSync();
  stdout.write('Password: ');
  String? password = stdin.readLineSync();

  if(username == null){
    print('No username provided. Signup Failed.');
    return;
  }

  if(password == null){
    print('No password provided. Signup Failed.');
    return;
  }

  int result = manager.signupAndLogin(username, password);

  switch(result){
    case 0:
      break;
    case 1:
      print('Username already taken. Signup Failed.');
      break;
  }

}

//~~~~~~~~~~~~~RecipeDetails~~~~~~~~~~~~~~
void showRecipeDetails(Recipe recipe) {
  
  bool isSaved = true;

  if(manager.loggedInUser != null){
    isSaved = manager.loggedInUser!.savedRecipeIds.contains(recipe.id);
  }

  clearScreen();

  print('[${recipe.title}]');
  print('');
  print('Link to recipe: ${recipe.url}');
  print('');

  if(manager.loggedInUser != null){

    if(isSaved){
      stdout.write('Removed from saved recipes? (y/[N]): ');
    } else {
      stdout.write('Add to saved recipes? (y/[N]): ');
    }

    String? input = stdin.readLineSync();

    if(input != null){
      if(input.toLowerCase().contains('y')){
        if(isSaved){
          manager.unsaveRecipe(recipe.id);
        } else {
          manager.saveRecipe(recipe.id);
        }
      }
    }

  } else {

    stdout.write('Press enter to continue...');
    stdin.readByteSync();

  }

}

//~~~~~~~~~~~~~~SearchRecipe~~~~~~~~~~~~~~~~~
void searchRecipes() {

}


//~~~~~~~~~~~~~~BrowseRecipe~~~~~~~~~~~~~~
void browseRecipes([Set<int>? haystack]) {
  
  clearScreen();

  if(haystack != null){

  } else {

    

  }

  

}

//~~~~~~~~~~~~~AddRecipe~~~~~~~~~~~~~
Future<void> addRecipe() async {
  
}

//~~~~~~~~~~~~~ViewSaved~~~~~~~~~~~~~
void viewSavedRecipes() {
  
}

List<String> wrapText(String text, int width) {
  List<String> lines = [];
  while (text.length > width) {
    int breakIndex = width;

    // Try to break at the last space if possible
    for (int i = width; i >= 0; i--) {
      if (text[i] == ' ') {
        breakIndex = i;
        break;
      }
    }

    lines.add(text.substring(0, breakIndex).trim());
    text = text.substring(breakIndex).trim();
  }

  if (text.isNotEmpty) {
    lines.add(text);
  }

  return lines;
}

Future<void> quit() async {
  print('Saving data...');
  await saveDatabase(manager);
  print('Goodbye!');
}

void clearScreen(){
  for(int i = 0; i < 60; i++){
    print('');
  }
}