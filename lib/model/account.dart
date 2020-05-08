
class Account {

  int id;
  String email;
  String name;
  String photoUrl;
  String nickname;

  Account({
    this.id,
    this.email,
    this.name,
    this.photoUrl,
    this.nickname
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      nickname: json['nickname'],
    );
  }

  Account copyWith({
    String name,
    String photoUrl,
    String nickname,
  }) {
    return Account(
      id: this.id,
      email: this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      nickname: nickname ?? this.nickname,
    );
  }

  @override
  String toString() {
    return 'Account{email: $email, name: $name, photoUrl: $photoUrl, nickname: $nickname}';
  }
}