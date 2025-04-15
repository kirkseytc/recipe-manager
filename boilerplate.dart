import 'dart:convert';
import 'dart:io';

import 'RecipeManager.dart';

Future<RecipeManager> boilerplate_load() async {

  RecipeManager rcgmgr = RecipeManager();

  var schemaDir = Directory('recipe-manager-schema');
  var userDBFile = File(schemaDir.path + '/user.db');
  var recipeDBFile = File(schemaDir.path + '/recipe.db');

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



}
