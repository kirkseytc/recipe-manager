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
  
  String toJSON(){

    String json = '{"id":"$id","title":"$title","url":"$url","tags":[';

    if(this.tags.isNotEmpty){

      for(String s in this.tags){

        json += '"$s",';

      }

      // removes last comma
      json = json.substring(0, json.length - 1);

    }

    json += ']}';

    return json;

  }

}