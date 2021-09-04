class User {
  int userId=0;
  String? name;
  String? email;
  String? phone;
  String? type;
  String? token;
  String? renewalToken;

  User({this.userId=0, this.name,  this.email, this.phone, this.type,  this.token,  this.renewalToken});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['id'],
        name: responseData['name'],
        email: responseData['email'],
        phone: responseData['phone'],
        type: responseData['type'],
        token: responseData['access_token'],
        renewalToken: responseData['renewal_token']
    );
  }
}
