import 'dart:convert';
import 'dart:io';

Future<void> boilerplate_start() async {

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

    // this block will not be present in the final code.
    // this is just to show the imports working
    {
        print('Files in ${schemaDir.path}:');
        await schemaDir.list().forEach((file) {
            print('  ' + file.path);
        });
        print('');

        print('Users found in ${userDBFile.path}:');
        var usernames = await readUsernames(userDBFile);
        usernames.forEach((username) {
            print('  ' + username);
        });
        print('');

        print('Recipes found in ${recipeDBFile.path}:');
        var recipeNames = await readRecipeNames(recipeDBFile);
        recipeNames.forEach((name) {
            print('  ' + name);
        });
    }

}

Future<List<String>> readUsernames(File userDBFile) async {

    var userObjs = jsonDecode(await userDBFile.readAsString());
    assert(userObjs is List);
    assert(userObjs[0] is Map);

    var usernames = List<String>.empty(growable: true);
    for(Map m in userObjs){
        usernames.add(m['username']);
    }

    return usernames;
}

Future<List<String>> readRecipeNames(File recipeDBFile) async {

    var recipeObjs = jsonDecode(await recipeDBFile.readAsString());
    assert(recipeObjs is List);
    assert(recipeObjs[0] is Map);

    var recipeNames = List<String>.empty(growable: true);

    for(Map m in recipeObjs){
        recipeNames.add(m['name']);
    }

    return recipeNames;

}

