import 'dart:io';
import 'package:dart_console/dart_console.dart';

import 'Recipe.dart';
import 'RecipeManager.dart';
import 'SaveAndLoad.dart';

final console = Console();
late RecipeManager manager;

void main() async {
  manager = await loadDatabase();
  manager.recipes.clear();
  await saveDatabase(manager);
  print('All recipes cleared!');

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
    print('Sample recipes added!');
  }

  while (true) {
    //final isLoggedIn = manager.loggedInUser != null;
    final options = manager.loggedInUser != null
      ? ['Search Recipes', 'Browse Recipes', 'View Saved Recipes', 'Add Recipe','', 'Logout', 'Quit']
      : ['Login', 'Signup', 'Quit'];

    int selection = showMenu(options, 'Recipe Manager');

    final choice = options[selection];

    if (choice == 'Login') {
      handleLogin();
    } else if (choice == 'Signup') {
      handleSignup();
    } else if (choice == 'Search Recipes') {
      searchRecipes();
    } else if (choice == 'Browse Recipes') {
      browseRecipes();
    } else if (choice == 'View Saved Recipes') {
      viewSavedRecipes();
    } else if (choice == 'Add Recipe') {
      await addRecipe();
    } else if (choice == 'Logout') {
      manager.loggedInUser = null;
    } else if (choice == 'Quit') {
      await quit();
      return;
    }
  }
}

//~~~~~~~~~~~~~~~Menu UI~~~~~~~~~~~~~~~~~
int showMenu(List<String> options, String title) {
  int selected = 0;
  const boxWidth = 50;
  const leftPad = 2;

  while (true) {
    console.clearScreen();

    final paddedWidth = boxWidth - 2;

    // Top border
    console.cursorPosition = Coordinate(2, leftPad);
    console.setForegroundColor(ConsoleColor.yellow);
    console.writeLine('╔' + '═' * paddedWidth + '╗');
    console.resetColorAttributes();

    // Title
    final titleLine = title.padLeft((paddedWidth + title.length) ~/ 2).padRight(paddedWidth);
    console.cursorPosition = Coordinate(3, leftPad);
    console.writeLine('║' + titleLine + '║');

    // Divider
    console.cursorPosition = Coordinate(4, leftPad);
    console.setForegroundColor(ConsoleColor.yellow);
    console.writeLine('╟' + '─' * paddedWidth + '╢');
    console.resetColorAttributes();

    int row = 5;

    // Welcome
    if (manager.loggedInUser != null) {
      final welcome = 'Welcome, ${manager.loggedInUser!.username}!';
      final padded = welcome.padLeft((paddedWidth + welcome.length) ~/ 2).padRight(paddedWidth);
      console.cursorPosition = Coordinate(row++, leftPad);
      console.writeLine('║' + padded + '║');
      console.cursorPosition = Coordinate(row++, leftPad);
      console.writeLine('╟' + '─' * paddedWidth + '╢');
    }

    // Spacer before account actions
    final spacerIndex = options.indexWhere((o) => o == 'Logout' || o == 'Quit');

    for (int i = 0; i < options.length; i++) {
      if (i == spacerIndex && i != 0) {
        console.cursorPosition = Coordinate(row++, leftPad);
        console.writeLine('║' + ' ' * paddedWidth + '║');
      }

      final isSelected = i == selected;
      final prefix = isSelected ? '▶ ' : '  ';
      final line = prefix + options[i];
      final paddedLine = line.padRight(paddedWidth);

      console.cursorPosition = Coordinate(row++, leftPad);
      if (isSelected) console.setForegroundColor(ConsoleColor.cyan);
      console.writeLine('║' + paddedLine + '║');
      if (isSelected) console.resetColorAttributes();
    }

    // Bottom border
    console.cursorPosition = Coordinate(row++, leftPad);
    console.setForegroundColor(ConsoleColor.yellow);
    console.writeLine('╚' + '═' * paddedWidth + '╝');
    console.resetColorAttributes();

    // Input handling
    final key = console.readKey();

    if (key.controlChar == ControlCharacter.arrowUp) {
      do {
        selected = (selected - 1 + options.length) % options.length;
      } while (options[selected].isEmpty);
    } else if (key.controlChar == ControlCharacter.arrowDown) {
      do {
        selected = (selected + 1) % options.length;
      } while (options[selected].isEmpty);
    } else if (key.controlChar == ControlCharacter.enter) {
      return selected;
    }
  }
}

//~~~~~~~~~~~~Login~~~~~~~~~~~~~~
void handleLogin() {
  const boxWidth = 50;
  const leftPad = 2;
  final paddedWidth = boxWidth - 2;

  console.clearScreen();

  // Top border
  console.cursorPosition = Coordinate(2, leftPad);
  console.setForegroundColor(ConsoleColor.yellow);
  console.writeLine('╔' + '═' * paddedWidth + '╗');
  console.resetColorAttributes();

  // Title
  final title = 'Login';
  final titleLine = title.padLeft((paddedWidth + title.length) ~/ 2).padRight(paddedWidth);
  console.cursorPosition = Coordinate(3, leftPad);
  console.writeLine('║' + titleLine + '║');

  // Divider
  console.cursorPosition = Coordinate(4, leftPad);
  console.setForegroundColor(ConsoleColor.yellow);
  console.writeLine('╟' + '─' * paddedWidth + '╢');
  console.resetColorAttributes();

  // Username
  console.cursorPosition = Coordinate(6, leftPad + 2);
  stdout.write('Username: ');
  final username = stdin.readLineSync();

  // Password
  console.cursorPosition = Coordinate(8, leftPad + 2);
  stdout.write('Password: ');
  final password = stdin.readLineSync();

  int messageRow = 10;

  console.cursorPosition = Coordinate(messageRow++, leftPad);
  if (username != null && password != null) {
    final result = manager.login(username, password);
    if (result == 0) {
      console.setForegroundColor(ConsoleColor.green);
      console.writeLine('Login successful!'.padRight(paddedWidth));
    } else {
      console.setForegroundColor(ConsoleColor.red);
      console.writeLine('Incorrect username or password.'.padRight(paddedWidth));
    }
  } else {
    console.setForegroundColor(ConsoleColor.red);
    console.writeLine('Invalid input.'.padRight(paddedWidth));
  }
  console.resetColorAttributes();

  console.cursorPosition = Coordinate(messageRow + 1, leftPad + 2);
}

//~~~~~~~~~~~~~~SignUp~~~~~~~~~~~~~~
void handleSignup() {
  const boxWidth = 50;
  const leftPad = 2;
  final paddedWidth = boxWidth - 2;

  console.clearScreen();

  // Top border
  console.cursorPosition = Coordinate(2, leftPad);
  console.setForegroundColor(ConsoleColor.yellow);
  console.writeLine('╔' + '═' * paddedWidth + '╗');
  console.resetColorAttributes();

  // Title
  final title = 'Signup';
  final titleLine = title.padLeft((paddedWidth + title.length) ~/ 2).padRight(paddedWidth);
  console.cursorPosition = Coordinate(3, leftPad);
  console.writeLine('║' + titleLine + '║');

  // Divider
  console.cursorPosition = Coordinate(4, leftPad);
  console.setForegroundColor(ConsoleColor.yellow);
  console.writeLine('╟' + '─' * paddedWidth + '╢');
  console.resetColorAttributes();

  // Username
  console.cursorPosition = Coordinate(6, leftPad + 2);
  stdout.write('Choose a username: ');
  final username = stdin.readLineSync();

  // Password
  console.cursorPosition = Coordinate(8, leftPad + 2);
  stdout.write('Choose a password: ');
  final password = stdin.readLineSync();

  int messageRow = 10;

  console.cursorPosition = Coordinate(messageRow++, leftPad);
  if (username != null && password != null) {
    final result = manager.signup(username, password);
    if (result == 0) {
      console.setForegroundColor(ConsoleColor.green);
      console.writeLine('Signup successful!'.padRight(paddedWidth));
    } else {
      console.setForegroundColor(ConsoleColor.red);
      console.writeLine('Username already taken.'.padRight(paddedWidth));
    }
  } else {
    console.setForegroundColor(ConsoleColor.red);
    console.writeLine('Invalid input.'.padRight(paddedWidth));
  }
  console.resetColorAttributes();

  console.cursorPosition = Coordinate(messageRow + 1, leftPad + 2);
  pause();
}

//~~~~~~~~~~~~~RecipeDetails~~~~~~~~~~~~~~
void showRecipeDetails(Recipe recipe) {
  const boxWidth = 50;
  const leftPad = 2;
  final paddedWidth = boxWidth - 2;

  console.clearScreen();

  // Top border
  console.cursorPosition = Coordinate(2, leftPad);
  console.setForegroundColor(ConsoleColor.yellow);
  console.writeLine('╔' + '═' * paddedWidth + '╗');
  console.resetColorAttributes();

  // Title (centered)
  final titleLine = recipe.title.padLeft((paddedWidth + recipe.title.length) ~/ 2).padRight(paddedWidth);
  console.cursorPosition = Coordinate(3, leftPad);
  console.writeLine('║' + titleLine + '║');

  // Divider
  console.cursorPosition = Coordinate(4, leftPad);
  console.setForegroundColor(ConsoleColor.yellow);
  console.writeLine('╟' + '─' * paddedWidth + '╢');
  console.resetColorAttributes();

  int row = 5;

  // Tags
  final tagsLine = 'Tags: ${recipe.tags.join(', ')}';
  console.cursorPosition = Coordinate(row++, leftPad);
  console.writeLine('║ ' + tagsLine.padRight(paddedWidth - 1) + '║');

  // URL
  final fullUrl = recipe.url;
  final maxUrlLength = paddedWidth - 7;

  final clippedUrl = fullUrl.length > maxUrlLength
    ? fullUrl.substring(0, maxUrlLength)
    : fullUrl;

  console.cursorPosition = Coordinate(row++, leftPad);
  console.writeLine('║ URL: ' + clippedUrl.padRight(paddedWidth - 6) + '║');

  if (fullUrl.length > maxUrlLength) {
    console.cursorPosition = Coordinate(row++, leftPad);
  }

  // Spacer
  console.cursorPosition = Coordinate(row++, leftPad);
  console.writeLine('║' + ' ' * paddedWidth + '║');

  // Save/Unsave Logic
  if (manager.loggedInUser != null) {
    final isSaved = manager.loggedInUser!.savedRecipeIds.contains(recipe.id);

    final prompt = isSaved
        ? 'Remove from favorites? (y/n): '
        : 'Save to favorites? (y/n): ';

    console.cursorPosition = Coordinate(row++, leftPad + 2);
    stdout.write(prompt);
    final input = stdin.readLineSync()?.toLowerCase();

    console.cursorPosition = Coordinate(row++, leftPad);
    if (input == 'y') {
      if (isSaved) {
        manager.loggedInUser!.removeRecipe(recipe.id);
        console.setForegroundColor(ConsoleColor.red);
        console.writeLine('Recipe removed from favorites.'.padRight(paddedWidth));
      } else {
        manager.loggedInUser!.saveRecipe(recipe.id);
        console.setForegroundColor(ConsoleColor.green);
        console.writeLine('Recipe saved to favorites!'.padRight(paddedWidth));
      }
      console.resetColorAttributes();
    }
  }

  console.cursorPosition = Coordinate(row + 1, leftPad + 2);
  pause();
}

//~~~~~~~~~~~~~~SearchRecipe~~~~~~~~~~~~~~~~~
void searchRecipes() {
  console.clearScreen();
  console.cursorPosition = Coordinate(2, 2);
  stdout.write('Enter a search keyword: ');
  final query = stdin.readLineSync();

  if (query == null || query.trim().isEmpty) {
    print('Search canceled.');
    pause();
    return;
  }

  final recipeIds = manager.search(query.trim());
  final results = manager.recipes
      .where((recipe) => recipeIds.contains(recipe.id))
      .toList();

  if (results.isEmpty) {
    print('\nNo recipes found matching "$query".');
    pause();
    return;
  }

  int selected = 0;
  while (true) {
    console.clearScreen();
    console.cursorPosition = Coordinate(2, 2);
    console.writeLine('=== Search Results for "$query" ===\n');

    for (int i = 0; i < results.length; i++) {
      if (i == selected) {
        console.setForegroundColor(ConsoleColor.magenta);
        console.writeLine('▶ ${results[i].title}');
      } else {
        console.resetColorAttributes();
        console.writeLine('  ${results[i].title}');
      }
    }

    console.writeLine('\n(Use arrow keys, Enter to view, Esc to go back)');
    final key = console.readKey();

    if (key.controlChar == ControlCharacter.arrowUp) {
      selected = (selected - 1 + results.length) % results.length;
    } else if (key.controlChar == ControlCharacter.arrowDown) {
      selected = (selected + 1) % results.length;
    } else if (key.controlChar == ControlCharacter.enter) {
      showRecipeDetails(results[selected]);
    } else if (key.controlChar == ControlCharacter.escape) {
      return;
    }
  }
}


//~~~~~~~~~~~~~~BrowseRecipe~~~~~~~~~~~~~~
void browseRecipes() {
  if (manager.recipes.isEmpty) {
    console.clearScreen();
    console.cursorPosition = Coordinate(2, 2);
    console.writeLine('No recipes found.');
    pause();
    return;
  }

  List<String> titles = manager.recipes.map((r) => r.title).toList();
  int selected = 0;

  while (true) {
    console.clearScreen();
    console.cursorPosition = Coordinate(2, 2);
    console.writeLine('=== Browse Recipes ===\n');

    for (int i = 0; i < titles.length; i++) {
      if (i == selected) {
        console.setForegroundColor(ConsoleColor.cyan);
        console.writeLine('▶ ${titles[i]}');
      } else {
        console.resetColorAttributes();
        console.writeLine('  ${titles[i]}');
      }
    }

    console.writeLine('\n(Use arrow keys, Enter to view, Esc to go back)');
    final key = console.readKey();

    if (key.controlChar == ControlCharacter.arrowUp) {
      selected = (selected - 1 + titles.length) % titles.length;
    } else if (key.controlChar == ControlCharacter.arrowDown) {
      selected = (selected + 1) % titles.length;
    } else if (key.controlChar == ControlCharacter.enter) {
      showRecipeDetails(manager.recipes[selected]);
    } else if (key.controlChar == ControlCharacter.escape) {
      return;
    }
  }
}

//~~~~~~~~~~~~~AddRecipe~~~~~~~~~~~~~
Future<void> addRecipe() async {
  const boxWidth = 50;
  const leftPad = 2;
  final paddedWidth = boxWidth - 2;

  console.clearScreen();

  // Top border
  console.cursorPosition = Coordinate(2, leftPad);
  console.setForegroundColor(ConsoleColor.yellow);
  console.writeLine('╔' + '═' * paddedWidth + '╗');
  console.resetColorAttributes();

  // Title
  final title = 'Add a New Recipe';
  final titleLine = title.padLeft((paddedWidth + title.length) ~/ 2).padRight(paddedWidth);
  console.cursorPosition = Coordinate(3, leftPad);
  console.writeLine('║' + titleLine + '║');

  // Divider
  console.cursorPosition = Coordinate(4, leftPad);
  console.setForegroundColor(ConsoleColor.yellow);
  console.writeLine('╟' + '─' * paddedWidth + '╢');
  console.resetColorAttributes();

  int row = 6;

  // Recipe Title
  console.cursorPosition = Coordinate(row++, leftPad + 2);
  stdout.write('Recipe Title: ');
  final titleInput = stdin.readLineSync();

  // Tags
  console.cursorPosition = Coordinate(row++, leftPad + 2);
  stdout.write('Tags (comma-separated): ');
  final tagInput = stdin.readLineSync();
  final tags = tagInput != null
      ? tagInput.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toSet()
      : <String>{};

  // URL
  console.cursorPosition = Coordinate(row++, leftPad + 2);
  stdout.write('URL (optional): ');
  final url = stdin.readLineSync() ?? '';

  // Validation + Save
  row += 1;
  console.cursorPosition = Coordinate(row++, leftPad);

  if (titleInput == null || titleInput.trim().isEmpty) {
    console.setForegroundColor(ConsoleColor.red);
    console.writeLine('Title is required.'.padRight(paddedWidth));
    console.resetColorAttributes();
    console.cursorPosition = Coordinate(row++, leftPad + 2);
    pause();
    return;
  }

  manager.addRecipe(titleInput.trim(), tags, url.trim());
  await saveDatabase(manager);

  console.setForegroundColor(ConsoleColor.green);
  console.writeLine('Recipe added successfully and saved!'.padRight(paddedWidth));
  console.resetColorAttributes();

  console.cursorPosition = Coordinate(row + 1, leftPad + 2);
  pause();
}

//~~~~~~~~~~~~~ViewSaved~~~~~~~~~~~~~
void viewSavedRecipes() {
  if (manager.loggedInUser == null) {
    console.clearScreen();
    console.cursorPosition = Coordinate(2, 2);
    console.writeLine('You must be logged in to view saved recipes.');
    pause();
    return;
  }

  final savedIds = manager.loggedInUser!.savedRecipeIds;
  final savedRecipes = manager.recipes.where((r) => savedIds.contains(r.id)).toList();

  if (savedRecipes.isEmpty) {
    console.clearScreen();
    console.cursorPosition = Coordinate(2, 2);
    console.writeLine('No saved recipes yet.');
    pause();
    return;
  }

  int selected = 0;

  while (true) {
    console.clearScreen();
    console.cursorPosition = Coordinate(2, 2);
    console.writeLine('=== Saved Recipes ===\n');

    for (int i = 0; i < savedRecipes.length; i++) {
      final recipe = savedRecipes[i];
      if (i == selected) {
        console.setForegroundColor(ConsoleColor.green);
        console.writeLine('▶ ${recipe.title}');
      } else {
        console.resetColorAttributes();
        console.writeLine('  ${recipe.title}');
      }
    }

    console.writeLine('\n(Use arrow keys, Enter to view, Esc to go back)');
    final key = console.readKey();

    if (key.controlChar == ControlCharacter.arrowUp) {
      selected = (selected - 1 + savedRecipes.length) % savedRecipes.length;
    } else if (key.controlChar == ControlCharacter.arrowDown) {
      selected = (selected + 1) % savedRecipes.length;
    } else if (key.controlChar == ControlCharacter.enter) {
      showRecipeDetails(savedRecipes[selected]);
    } else if (key.controlChar == ControlCharacter.escape) {
      return;
    }
  }
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

void pause() {
  stdout.write('\nPress Enter to continue...');
  stdin.readLineSync();
}

Future<void> quit() async {
  print('\nSaving data...');
  await saveDatabase(manager);
  print('Goodbye!');
}