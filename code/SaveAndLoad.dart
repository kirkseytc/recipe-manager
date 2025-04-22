import 'dart:convert';
import 'dart:io';

import 'RecipeManager.dart';
import 'User.dart';
import 'Recipe.dart';

var schemaDir = Directory('./recipe_manager_data');
var userDBFile = File(schemaDir.path + '/users.json');
var recipeDBFile = File(schemaDir.path + '/recipes.json');

Future<RecipeManager> loadDatabase() async {

  RecipeManager manager = RecipeManager();
  

  // creating files if the don't exist already

  /// checks for directory
  /// 
  /// if it doesn't exits create it and sub files and return manager
  /// because there is no data to load in.
  if(!(await schemaDir.exists())){
    print('The directory "./recipe_manager_data" was not found. Creating required directory and sub files.');
    await schemaDir.create();
    await userDBFile.create();
    await recipeDBFile.create();
    return manager;
  }

  /// checks for users.json in the data directory
  /// 
  /// if it doesn't exit, create it
  /// otherwise, load in data
  if(!(await userDBFile.exists())){
    print('The file "./recipe_manager_data/users.json" was not found. Creating file.');
    await userDBFile.create();
  } else {
    manager = await loadUsers(manager);
  }  

  /// checks for recipes.json in the data directory
  /// 
  /// if it doesn't exit, create it
  /// otherwise, load in data
  if(!(await recipeDBFile.exists())){
    print('The file "./recipe_manager_data/recipes.json" was not found. Creating file.');
    await recipeDBFile.create();
  } else {
    manager = await loadRecipes(manager);
  }  

  return manager;

}

Future<RecipeManager> loadRecipes(RecipeManager manager) async {

  var recipeObjs;

  try {
    recipeObjs = jsonDecode(await recipeDBFile.readAsString());
  } catch(FormatExeception){
    print('Recipe database is not formated correctly. Failed to load in recipes');
    return manager;
  } 

  for(Map recipeJson in recipeObjs){

    String title = recipeJson['title'];
    String url = recipeJson['url'];
    Set<String> tags = Set<String>.from(recipeJson['tags'].toSet());

    manager.addRecipe(title, tags, url);

  }

  return manager;
}

Future<RecipeManager> loadUsers(RecipeManager manager) async {

  var userObjs;

  try {
    userObjs = jsonDecode(await userDBFile.readAsString());
  } catch(FormatExeception){
    print('User database is not formated correctly. Failed to load in users');
    return manager;
  }

  for(Map userJson in userObjs){

    String username = userJson['username'];
    int password = userJson['password'];
    Set<int> savedRecipeIds = Set<int>.from(userJson['saved_recipe_ids'].toSet());

    manager.addUser(username, password, savedRecipeIds);

  }

  return manager;
}

Future<void> saveDatabase(RecipeManager manager) async {

  String json = '';

  if(manager.users.isNotEmpty){

    json += '[';

    for(User u in manager.users){
      json += u.toJSON() + ",";
    }

    // removes last comma
    json = json.substring(0, json.length - 1);

    json += ']';

  }

  await userDBFile.writeAsString(json);

  json = '';

  if(manager.recipes.isNotEmpty){

    json += '[';

    for(Recipe r in manager.recipes){

      json += r.toJSON() + ',';

    }

    // removes last comma
    json = json.substring(0, json.length - 1);

    json += ']';

  }

  await recipeDBFile.writeAsString(json);

}
