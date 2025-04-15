import 'dart:io';

import 'SaveAndLoad.dart';
import 'RecipeManager.dart';
import 'User.dart';
import 'Recipe.dart';

void main() async {
  
  // load the manager
  RecipeManager rcpmgr = await boilerplate_load();

  // do things

  // save the manager
  await boilerplate_save(rcpmgr);
  
  // exit program

}