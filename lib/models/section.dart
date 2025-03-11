class Section {
  int id;
  String title;
  String time;
  bool completed;

  Section(
      {required this.id, required this.title, required this.time, this.completed = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'completed': completed ? 1 : 0,
    };
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      id: map['id'],
      title: map['title'],
      time: map['time'],
      completed: map['completed'] == 1,
    );
  }
}
