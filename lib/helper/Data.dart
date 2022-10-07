class Data{
  String id, email, location, data, time;

  Data(this.email, this.location, this.data, this.time);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'data_id': id,
      'data_email': email,
      'data_location': location,
      'data': data,
      'data_time': time
    };
    return map;
  }


  Data.fromMap(Map<String, dynamic> map){
    id = map['user_id'];
    email = map['data_email'];
    location = map['data_location'];
    data = map['data'];
    time = map['data_time'];

  }
}