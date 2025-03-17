class UserData{
  final String uuid;
  final String email;

  UserData(this.uuid, this.email);

  Map<String, dynamic> toMap(){
    return {
      'uuid' : uuid,
      'email' : email
    };
  }
}
