class Account {

  int id;
  String email;
  String name;
  String photoUrl;
  String _token;

  Account({
    this.id,
    this.email,
    this.name,
    this.photoUrl,
    String token,
  }) : _token = token;

//  String get provider;
  String get token => _token;

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }

}