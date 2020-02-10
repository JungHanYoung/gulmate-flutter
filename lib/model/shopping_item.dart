class ShoppingItem {
  int id;
  String title;
  String place;
  String author;
  DateTime deadline;
  DateTime createdDate;
  DateTime modifiedDate;
  bool isComplete;

  ShoppingItem({
    this.id,
    this.title,
    this.place,
    this.author,
    this.deadline,
    this.createdDate,
    this.modifiedDate,
    this.isComplete
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json)
    => ShoppingItem(
      id: json['id'],
      title: json['title'],
      place: json['place'],
      author: json['account']['name'],
      deadline: DateTime.parse(json['deadline']),
      isComplete: json['isComplete'],
      createdDate: DateTime.parse(json['createdDate']),
      modifiedDate: DateTime.parse(json['modifiedDate']),
    );
}