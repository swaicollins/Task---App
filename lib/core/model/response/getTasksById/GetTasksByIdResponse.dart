class GetTasksByIdResponse {
  int? id;
  String? title;
  String? description;
  bool? completed;

  GetTasksByIdResponse({this.id, this.title, this.description, this.completed});

  GetTasksByIdResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['completed'] = this.completed;
    return data;
  }
}