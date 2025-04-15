import '../code/RecipeManager.dart';

void main(){

  // sign up and login tests
  RecipeManager manager = RecipeManager();

  print(manager.signupAndLogin('admin', 'password'));
  print(manager.signupAndLogin('admin', 'password'));

  print(manager.whoami());

  // logout test
  // manager.logout();
  // print(manager.whoami());

  // manager.signupAndLogin('test', '1234');

  // print(manager.loggedInUser?.toJSON());

  manager.addRecipe('cookies', {'yummy', 'sweet'}, 'url');
  manager.addRecipe('pizza', {'italian', 'savory'}, 'www.dominos.com');

  var results = manager.search('pizza');

  manager.saveRecipe(results.first);
  // print(manager.loggedInUser?.toJSON());
  print(manager.getFavorites());
  manager.logout();
  manager.login('admin', 'password');
  print(manager.whoami());
  print(manager.getFavorites());


}