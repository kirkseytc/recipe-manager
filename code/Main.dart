import 'dart:io';
import 'Recipe.dart';
import 'RecipeManager.dart';
import 'SaveAndLoad.dart';

late RecipeManager manager;
String? message;

void clearConsole() => stdout.write('\x1B[2J\x1B[0;0H');

void drawBox(String title, List<String> contentLines) {
  const width = 60;
  print('+' + '-' * width + '+');
  print('| ' + title.padRight(width - 1) + '|');
  print('+' + '-' * width + '+');
  for (var line in contentLines) {
    print('| ' + line.padRight(width - 1) + '|');
  }
  print('+' + '-' * width + '+');
}

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
    await saveDatabase(manager);
  }

  while (true) {
    clearConsole();
    
    if(message != null){
      print('[$message]');
      message = null;
    }

    final isLoggedIn = manager.loggedInUser != null;
    final username = manager.whoami() ?? '';
    final menuLines = isLoggedIn
        ? [
            'Welcome, $username!',
            '',
            '1) Search Recipes',
            '2) Browse Recipes',
            '3) View Saved Recipes',
            '4) Add Recipe',
            '',
            '5) Logout',
            '6) Save & Quit'
          ]
        : [
            '1) Login',
            '2) Signup',
            '',
            '3) Save & Quit'
          ];
    drawBox('Recipe Manager', menuLines);
    stdout.write('Choose an option: ');
    final input = stdin.readLineSync();
    if (!isLoggedIn) {
      switch (input) {
        case '1': 
          handleLogin(); 
          break;
        case '2': 
          handleSignup(); 
          break;
        case '3': 
          await quit(); 
          return;
        default: 
          print('Invalid option.');
      }
    } else {
      switch (input) {
        case '1': 
          searchRecipes(); 
          break;
        case '2': 
          browseRecipes(); 
          break;
        case '3': 
          viewSavedRecipes(); 
          break;
        case '4': 
          addRecipe(); 
          break;
        case '5': 
          manager.logout(); 
          message = 'You have been Logged Out!'; 
          break;
        case '6': 
          await quit(); 
          return;
        default: 
          print('Invalid option.');
      }
    }
  }
}

void handleLogin() {
  clearConsole();
  stdout.write('Username: ');
  final username = stdin.readLineSync();
  stdout.write('Password: ');
  stdout.write('\x1B[8m');
  final password = stdin.readLineSync();
  stdout.write('\x1B[28m');
  clearConsole();

  if (username != null && password != null) {
    final result = manager.login(username, password);
    
    switch(result){
      case 0:
        break;
      case 1:
        message = 'Login Failed: Invalid Password';
        break;
      case 2:
        message = 'Login Failed: Username Not Found';
        break;
    }

  } else {
    message = 'Invalid input.';
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
    
    switch(result){
      case 0:
        break;
      case 1:
        message = 'Signup Failed: Username Already Taken';
        break;
    }

  } else {
    print('Invalid input.');
  }
}

void searchRecipes() {
  clearConsole();
  stdout.write('Enter a keyword to search: ');
  final query = stdin.readLineSync();

  if (query == null || query.isEmpty) {
    message = 'Search Canceled.';
    return;
  }

  final ids = manager.search(query);
  final results = manager.recipes.where((r) => ids.contains(r.id)).toList();

  if (results.isEmpty) {
    message = 'No Recipes Found.';
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
}

void browseRecipes() {
  clearConsole();
  if (manager.recipes.isEmpty) {
    message = 'No Recipes Available.';
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
}

void viewSavedRecipes() {
  clearConsole();
  
  final savedIds = manager.loggedInUser!.savedRecipeIds;
  final saved = manager.recipes.where((r) => savedIds.contains(r.id)).toList();

  if (saved.isEmpty) {
    message = 'No Saved Recipes.';
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

void addRecipe() {
  clearConsole();
  final lines = <String>[];

  stdout.write('Recipe Title: ');
  final title = stdin.readLineSync();
  lines.add('Title: ${title ?? ''}');

  stdout.write('Tags (comma-separated): ');
  final tagInput = stdin.readLineSync();
  final tags = tagInput?.split(',').map((t) => t.trim()).toSet() ?? {};
  lines.add('Tags: ${tags.join(', ')}');

  stdout.write('URL (optional): ');
  final url = stdin.readLineSync() ?? '';
  lines.add('URL: $url');

  if (title == null || title.trim().isEmpty) {
    message = 'Add Failed: Title Required.';
    return;
  }

  clearConsole();
  drawBox('New Recipe Added', lines);
  manager.addRecipe(title.trim(), tags, url.trim());
  message = 'Recipe Saved!';
}

void showRecipeDetails(Recipe recipe) {
  clearConsole();
  const boxWidth = 75;
  final displayUrl = recipe.url.length > boxWidth
      ? recipe.url.substring(0, boxWidth - 2)
      : recipe.url;

  print('\n+${'-' * boxWidth}+');
  print('| ${recipe.title.padRight(boxWidth - 1)}|');
  print('| ${'Tags: ${recipe.tags.join(', ')}'.padRight(boxWidth - 1)}|');
  print('| ${'URL:'.padRight(boxWidth - 1)}|');
  print('| ${displayUrl.padRight(boxWidth - 1)}|');
  print('+${'-' * boxWidth}+\n');

  if (manager.loggedInUser != null) {
    final isSaved = manager.loggedInUser!.savedRecipeIds.contains(recipe.id);
    stdout.write(isSaved
        ? 'Remove from favorites? (y/[n]): '
        : 'Save to favorites? (y/[n]): ');
    final input = stdin.readLineSync()?.toLowerCase();
    clearConsole();
    if (input == 'y') {
      if (isSaved) {
        manager.loggedInUser!.removeRecipe(recipe.id);
        message = 'Removed from favorites.';
      } else {
        manager.loggedInUser!.saveRecipe(recipe.id);
        message = 'Saved to favorites.';
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
