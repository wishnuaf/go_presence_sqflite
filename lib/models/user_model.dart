class UserModel {
  int? id;
  String? fullName;
  String? email;
  String? password;
  String? position;

  UserModel({this.id, this.fullName, this.email, this.password, this.position});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'position': position,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      password: map['password'],
      position: map['position'],
    );
  }
}
