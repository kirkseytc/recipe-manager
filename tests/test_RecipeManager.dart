import '../code/RecipeManager.dart';

void main(){

  // sign up and login tests
  RecipeManager rcpmgr = RecipeManager();

  print(rcpmgr.signupAndLogin('admin', 'password'));
  print(rcpmgr.signupAndLogin('admin', 'password'));

  print(rcpmgr.whoami());

  // logout test
  rcpmgr.logout();
  print(rcpmgr.whoami());

  rcpmgr.signupAndLogin('test', '1234');

  print(rcpmgr.loggedInUser?.toJSON());

}