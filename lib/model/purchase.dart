class Purchase {
  int id;
  String title;
  String place;
//  String author;
  DateTime deadline;
  DateTime createdDate;
  DateTime modifiedDate;
  bool isComplete;

  Purchase({
    this.id,
    this.title,
    this.place,
//    this.author,
    this.deadline,
    this.createdDate,
    this.modifiedDate,
    this.isComplete
  });

  factory Purchase.fromJson(Map<String, dynamic> json)
  => Purchase(
    id: json['id'],
    title: json['title'],
    place: json['place'],
//    author: json['account']['name'],
    deadline: DateTime.parse(json['deadline']),
    isComplete: json['complete'],
    createdDate: DateTime.parse(json['createdDate']),
    modifiedDate: DateTime.parse(json['modifiedDate']),
  );

  @override
  String toString() {
    return 'Purchase{id: $id, title: $title, place: $place, isComplete: $isComplete}';
  }

  Purchase copyWith({bool complete, String title, String place, DateTime deadline}) {
    return Purchase(
      id: this.id,
      title: title ?? this.title,
      place: place ?? this.place,
//      author: this.author,
      isComplete: complete ?? this.isComplete,
      deadline: deadline ?? this.deadline,
      createdDate: this.createdDate,
      modifiedDate: this.modifiedDate,
    );
  }

}