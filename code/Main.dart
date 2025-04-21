import 'dart:io';
import 'Recipe.dart';
import 'RecipeManager.dart';
import 'SaveAndLoad.dart';

late RecipeManager manager;

void clearConsole() => stdout.write('\x1B[2J\x1B[0;0H');

void main() async {
  manager = await loadDatabase();
  manager.recipes.clear();
  await saveDatabase(manager);
  print('All recipes cleared!');

  // Populate recipes if empty
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
    await saveDatabase(manager);
    //print('Sample recipes added!');
    clearConsole();
  }

  while (true) {
    final isLoggedIn = manager.loggedInUser != null;
    print('\n=== Recipe Manager ===');
    if (isLoggedIn) {
      print('Welcome, ${manager.loggedInUser!.username}!');
      print('1) Search Recipes\n2) Browse Recipes\n3) View Saved Recipes\n4) Add Recipe\n5) Logout\n6) Quit');
    } else {
      print('1) Login\n2) Signup\n3) Quit');
    }
    stdout.write('\nChoose an option: ');
    final input = stdin.readLineSync();
    if (!isLoggedIn) {
      switch (input) {
        case '1': handleLogin(); break;
        case '2': handleSignup(); break;
        case '3': await quit(); return;
        default: print('Invalid option.');
      }
    } else {
      switch (input) {
        case '1': searchRecipes(); break;
        case '2': browseRecipes(); break;
        case '3': viewSavedRecipes(); break;
        case '4': await addRecipe(); break;
        case '5': manager.logout(); 
          clearConsole(); 
          print('You have been logged out.'); break;
        case '6': await quit(); return;
        default: print('Invalid option.');
      }
    }
  }
}

void handleLogin() {
  clearConsole();
  stdout.write('Username: ');
  final username = stdin.readLineSync();
  stdout.write('Password: ');
  final password = stdin.readLineSync();
  clearConsole();

  if (username != null && password != null) {
    final result = manager.login(username, password);
    print(result == 0 ? 'Login successful!' : 'Login failed.');
  } else {
    print('Invalid input.');
  }
}

void handleSignup() {
  clearConsole();
  stdout.write('Choose a username: ');
  final username = stdin.readLineSync();
  stdout.write('Choose a password (case-sensitive): ');
  final password = stdin.readLineSync();
  clearConsole();

  if (username != null && password != null) {
    final result = manager.signupAndLogin(username.trim(), password.trim());
    print(result == 0
        ? 'Signup successful and logged in!'
        : 'Username already taken.');
  } else {
    print('Invalid input.');
  }
}

void searchRecipes() {
  clearConsole();
  stdout.write('Enter a keyword to search: ');
  final query = stdin.readLineSync();

  if (query == null || query.isEmpty) {
    print('Search canceled.');
    return;
  }

  final ids = manager.search(query);
  final results = manager.recipes.where((r) => ids.contains(r.id)).toList();

  if (results.isEmpty) {
    print('No recipes found.');
    return;
  }

  for (int i = 0; i < results.length; i++) {
    print('${i + 1}) ${results[i].title}');
  }
  stdout.write('View recipe # (or press Enter to cancel): ');
  final input = stdin.readLineSync();
  if (input != null && input.isNotEmpty) {
    final index = int.tryParse(input);
    if (index != null && index > 0 && index <= results.length) {
      showRecipeDetails(results[index - 1]);
    }
  }
  clearConsole();
}

void browseRecipes() {
  clearConsole();
  if (manager.recipes.isEmpty) {
    print('No recipes available.');
    return;
  }

  for (int i = 0; i < manager.recipes.length; i++) {
    print('${i + 1}) ${manager.recipes[i].title}');
  }

  stdout.write('View recipe # (or press Enter to cancel): ');
  final input = stdin.readLineSync();
  final index = int.tryParse(input ?? '');
  if (index != null && index > 0 && index <= manager.recipes.length) {
    showRecipeDetails(manager.recipes[index - 1]);
  }
  clearConsole();
}

void viewSavedRecipes() {
  clearConsole();
  if (manager.loggedInUser == null) {
    print('Not logged in.');
    return;
  }
  final savedIds = manager.loggedInUser!.savedRecipeIds;
  final saved = manager.recipes.where((r) => savedIds.contains(r.id)).toList();

  if (saved.isEmpty) {
    print('No saved recipes.');
    return;
  }

  for (int i = 0; i < saved.length; i++) {
    print('${i + 1}) ${saved[i].title}');
  }
  stdout.write('View recipe # (or press Enter to cancel): ');
  final input = stdin.readLineSync();
  final index = int.tryParse(input ?? '');
  if (index != null && index > 0 && index <= saved.length) {
    showRecipeDetails(saved[index - 1]);
  }
  clearConsole();
}

Future<void> addRecipe() async {
  clearConsole();
  stdout.write('Recipe Title: ');
  final title = stdin.readLineSync();

  stdout.write('Tags (comma-separated): ');
  final tagInput = stdin.readLineSync();
  final tags = tagInput?.split(',').map((t) => t.trim()).toSet() ?? {};

  stdout.write('URL (optional): ');
  final url = stdin.readLineSync() ?? '';

  if (title == null || title.trim().isEmpty) {
    print('Title required.');
    return;
  }
  clearConsole();

  manager.addRecipe(title.trim(), tags, url.trim());
  await saveDatabase(manager);
  print('Recipe added and saved!');
}

void showRecipeDetails(Recipe recipe) {
  clearConsole();
  print('\n=== ${recipe.title} ===');
  print('Tags: ${recipe.tags.join(', ')}');
  print('URL: ${recipe.url}');

  if (manager.loggedInUser != null) {
    final isSaved = manager.loggedInUser!.savedRecipeIds.contains(recipe.id);
    stdout.write(isSaved ? 'Remove from favorites? (y/n): ' : 'Save to favorites? (y/n): ');
    final input = stdin.readLineSync()?.toLowerCase();
    clearConsole();
    if (input == 'y') {
      if (isSaved) {
        manager.loggedInUser!.removeRecipe(recipe.id);
        print('Removed from favorites.');
      } else {
        manager.loggedInUser!.saveRecipe(recipe.id);
        print('Saved to favorites.');
      }
    }
  }
}

Future<void> quit() async {
  clearConsole();
  manager.logout();
  print('Saving data...');
  await saveDatabase(manager);
  print('Goodbye!');
}