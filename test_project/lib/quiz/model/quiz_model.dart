class QuizItems {
  List<QuizItem>? items;

  QuizItems({this.items});

  QuizItems.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <QuizItem>[];
      json['items'].forEach((v) {
        items!.add(QuizItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuizItem {
  String? title;
  int? index;
  List<String>? types;

  QuizItem({this.title, this.index, this.types});

  QuizItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    index = json['index'];
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    data['index'] = index;
    data['types'] = types;
    return data;
  }
}
