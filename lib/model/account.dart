abstract class Account {

  String id;
  String email;
  String name;
  String photoUrl;

  Account({
    this.id,
    this.email,
    this.name,
    this.photoUrl,
  });

  String get getProvider;

}