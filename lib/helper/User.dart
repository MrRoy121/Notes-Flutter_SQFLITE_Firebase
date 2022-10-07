class User{
  int id;
  String name, email, pass;

  User(this.name, this.email, this.pass);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': id,
      'user_name': name,
      'user_email': email,
      'user_pass': pass
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map){
    id = map['user_id'];
    name = map['user_name'];
    email = map['user_email'];
    pass = map['user_pass'];
  }
}