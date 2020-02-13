class Account {

  int id;
  String email;
  String name;
  String photoUrl;

  Account({
    this.id,
    this.email,
    this.name,
    this.photoUrl,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
    );
  }

  @override
  String toString() {
    return 'Account{email: $email, name: $name, photoUrl: $photoUrl}';
  }


}