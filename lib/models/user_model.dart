class UserModel {
  String? uid;
  String? adSoyad;
  String? numara;
  String? email;
  String? isAdmin;

  UserModel({this.uid, this.adSoyad, this.email, this.numara, this.isAdmin});

  //serverdan data çekme
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        adSoyad: map['adSoyad'],
        email: map['email'],
        numara: map['numara'],
        isAdmin: map['isAdmin']);
  }

  //servera data puşing
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'adSoyad': adSoyad,
      'email': email,
      'numara': numara,
      'isAdmin': isAdmin
    };
  }
}
