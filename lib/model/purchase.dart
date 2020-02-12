class Purchase {
  int id;
  String title;
  String place;
  String creator;
  String checker;
  DateTime deadline;
  DateTime checkedDateTime;

//  DateTime createdDate;
//  DateTime modifiedDate;
  bool complete;

  Purchase({
    this.id,
    this.title,
    this.place,
//    this.author,
    this.deadline,
    this.creator,
    this.checker,
    this.checkedDateTime,
//    this.createdDate,
//    this.modifiedDate,
    this.complete,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        id: json['id'],
        title: json['title'],
        place: json['place'],
        creator: json['creator'],
        checker: json['checker'],
        deadline:
            json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
        complete: json['complete'],
        checkedDateTime: json['checkedDateTime'] != null
            ? DateTime.parse(json['checkedDateTime'])
            : null,
//    createdDate: DateTime.parse(json['createdDate']),
//    modifiedDate: DateTime.parse(json['modifiedDate']),
      );

  @override
  String toString() {
    return 'Purchase{id: $id, title: $title, place: $place, complete: $complete, checker: $checker, creator: $creator}';
  }

  Purchase copyWith({
    int id,
    bool complete,
    String title,
    String place,
    DateTime deadline,
    String creator,
    String checker,
    DateTime checkedDateTime,
  }) {
    return Purchase(
      id: id ?? this.id,
      title: title ?? this.title,
      place: place ?? this.place,
      creator: creator ?? this.creator,
      complete: complete ?? this.complete,
      deadline: deadline ?? this.deadline,
      checker: checker ?? this.checker,
      checkedDateTime: checkedDateTime ?? this.checkedDateTime,
//      createdDate: this.createdDate,
//      modifiedDate: this.modifiedDate,
    );
  }
}
