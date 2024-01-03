import 'package:app_tracking/data/model/body/user.dart';

class Notifications {
  String? body;
  String? date;
  int? id;
  String? title;
  String? type;
  User? user;
  Notifications(
      {this.body, this.date, this.id, this.title, this.type, this.user});

  Notifications.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    date = json['date'];
    id = json['id'];
    title = json['title'];
    type = json['type'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['date'] = this.date;
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
