import 'dart:convert';
import 'dart:io';

import 'RecipeManager.dart';
import 'User.dart';
import 'Recipe.dart';

var schemaDir = Directory('recipe_manager_data');
var userDBFile = File(schemaDir.path + '/users.json');
var recipeDBFile = File(schemaDir.path + '/recipes.json');

Future<RecipeManager> boilerplate_load() async {

  RecipeManager rcgmgr = RecipeManager();

  // creating files if the don't exist already

  if(!(await Directory('.').list().contains(schemaDir))){
    await schemaDir.create();
  }

  if(!(await schemaDir.list().contains(userDBFile))){
    await userDBFile.create();
  }   

  if(!(await schemaDir.list().contains(recipeDBFile))){
    await recipeDBFile.create();
  }   

  return rcgmgr;

}

Future<void> boilerplate_save(RecipeManager rcpmgr) async {

  String json = '';

  if(rcpmgr.users.isNotEmpty){

    json += '[';

    for(User u in rcpmgr.users){
      json += u.toJSON() + ",";
    }

    // removes last comma
    json = json.substring(0, json.length - 1);

    json += ']';

  }

  await userDBFile.writeAsString(json);

  json = '';

  if(rcpmgr.recipes.isNotEmpty){

    json += '[';

    for(Recipe r in rcpmgr.recipes){

      json += r.toJSON() + ',';

    }

    // removes last comma
    json = json.substring(0, json.length - 1);

    json += ']';

  }

  await recipeDBFile.writeAsString(json);

}
