import 'Recipe.dart';
import 'User.dart';

class RecipeManager {

  /// The list of all users registered to the database
  List<User> users = List.empty(growable: true);

  /// The list of recipes registered to the database
  List<Recipe> recipes = List.empty(growable: true);

  /// The id of the currently logged in user
  User? loggedInUser;

  ///
  /// Logs in the user to the system with the provided [username] and [password].
  /// 
  /// Returns an [int] with one of the following values:
  /// 0 upon success
  /// 1 upon incorrect [password]
  /// 2 upon no user with that [username] found
  /// 
  int login(String username, String password){

    for(User usr in this.users){
      
      if(usr.username.compareTo(username) != 0){
        continue;
      }

      if(usr.password != password.hashCode){
        return 1;
      }

      loggedInUser = usr;
      return 0;
    
    }

    return 2;

  }

  /// Signs up a user to the system with the provided [username] and [password]
  /// 
  /// Returns an [int] with one of the following values:
  /// 0 for success
  /// 1 for username already taken
  int signup(String username, String password){

    for(User usr in this.users){
      if(usr.username.compareTo(username) == 0){
        return 1;
      }
    }

    this.users.add(User(username, password.hashCode));
    return 0;
  }

  /// Signs up and logs in a user with the provided [username] and [password]
  /// 
  /// Returns an [int] with one of the following values:
  /// 0 for success
  /// 1 for username already taken
  int signupAndLogin(String username, String password){
    
    if(this.signup(username, password) == 1){
      return 1;
    }

    this.login(username, password);
    return 0;
  }

  /// Returns the username of the logged in user, else returns null
  String? whoami(){
    return this.loggedInUser?.username;
  }

  /// logs out the current user
  void logout(){
    this.loggedInUser = null;
  }

  /// adds a recipe to the database
  void addRecipe(String title, Set<String> tags, String url){
    this.recipes.add(Recipe(title, tags, url));
  }

  /// adds the recipe to the logged in users recipe list
  /// 
  /// if no user is logged in it does nothing.
  void saveRecipe(Recipe rcp){
      loggedInUser?.savedRecipeIds.add(rcp.id);
  }

  /// DO NOT USE THIS FOR 
  /// THE LOVE OF GOD!
  /// ITS ONLY FOR THE BACKEND!
  /// 
  /// -Tristan :)
  /// 
  void addUser(String username, int password, Set<int> savedRecipeIds){
    this.users.add(User.raw(username, password, savedRecipeIds));
  }

}