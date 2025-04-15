class Recipe {

  static int nextId = 1;

  /// The id of the recipe
  int id = -1;
  
  /// The title of the recipe
  String title = '';
  
  /// The tags associated with the recipe
  Set<String> tags = Set();
  
  /// The url to the recipe
  String url = '';

  /// Creates a recipe object with the give [title], [tags], and [url] with an unique id automatically assigned
  Recipe(String title, Set<String> tags, String url){

    this.id = nextId;
    nextId += 1;

    this.title = title;
    this.tags = tags;
    this.url = url;

  }
  
}