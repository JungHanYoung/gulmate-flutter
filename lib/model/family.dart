class Family {
  String inviteUrl;
  String name;

  Family({
    this.inviteUrl,
    this.name,
  });

  factory Family.fromJSON(Map<String, dynamic> json) {
    return Family(
      inviteUrl: json['invite_url'],
      name: json['name'],
    );
  }
}