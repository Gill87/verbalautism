class AppUser {

  final String uid;
  final String email;
  final String name;

  AppUser(
    {
      required this.uid,
      required this.email,
      required this.name
    }
  );

  // Converting app user to json
  Map <String, dynamic> toJson(){
    return {
      "username": uid,
      "email": email,
      "name": name,
    };
  }
  
  // convert json to app user
  factory AppUser.fromJson(Map<String, dynamic> jsonUser){
    return AppUser(
      uid: jsonUser["username"],
      email: jsonUser["email"],
      name: jsonUser["name"],
      
    );
  }

}