class User {
  
  /// The username of the user
  String username = '';
  
  /// The password of the user
  int password = -1;

  /// The set of Ids of recipes that the user has saved
  Set<int> savedRecipeIds = Set();

  /// Creates a user with the given [username] and [password] and automatically assigns a unique id.
  User(this.username, this.password);

  void saveRecipe(int recipeId){
    this.savedRecipeIds.add(recipeId);
  }

  User.raw(String username, int password, Set<int> savedRecipeIds){
    this.username = username;
    this.password = password;
    this.savedRecipeIds = savedRecipeIds;
  }

  String toJSON(){

    String json = '{"username":"$username","password":$password,"saved_recipe_ids":[';

    if(this.savedRecipeIds.isNotEmpty){
      
      for(int i in savedRecipeIds){
        json = json + '"$i",';
      }

      // removes last comma
      json = json.substring(0, json.length - 1);

    }

    json = json + ']}';

    return json;

  }

}