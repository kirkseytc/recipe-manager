class User {

  static int nextId = 1;

  /// The id of the user
  int id = -1;
  
  /// The username of the user
  String username = '';
  
  /// The password of the user
  String password = '';

  /// The set of Ids of recipes that the user has saved
  Set<int> savedRecipeIds = Set();

  /// Creates a user with the given [username] and [password] and automatically assigns a unique id.
  User(String username, String password){
    this.id = nextId;
    nextId += 1;

    this.username = username;
    this.password = password;
  }

  void saveRecipe(int recipeId){
    this.savedRecipeIds.add(recipeId);
  }

}