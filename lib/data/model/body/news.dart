import 'package:app_tracking/data/model/body/user.dart';

class News {
  List<Comments>? comments;
  String? content;
  dynamic date;
  int? id;
  List<Likes>? likes;
  List<Media>? media;
  User? user;

  News(
      {this.comments,
      this.content,
      this.date,
      this.id,
      this.likes,
      this.media,
      this.user});

  News.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
    content = json['content'];
    date = json['date'];
    id = json['id'];
    if (json['likes'] != null) {
      likes = <Likes>[];
      json['likes'].forEach((v) {
        likes!.add(Likes.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    data['content'] = content;
    data['date'] = date;
    data['id'] = id;
    if (likes != null) {
      data['likes'] = likes!.map((v) => v.toJson()).toList();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Comments {
  String? content;
  dynamic date;
  int? id;
  User? user;

  Comments({this.content, this.date, this.id, this.user});

  Comments.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    date = json['date'];
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['date'] = date;
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
class Likes {
  dynamic date;
  int? id;
  int? type;
  User? user;

  Likes({this.date, this.id, this.type, this.user});

  Likes.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    id = json['id'];
    type = json['type'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['id'] = id;
    data['type'] = type;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Media {
  int? contentSize;
  String? contentType;
  String? extension;
  String? filePath;
  int? id;
  bool? isVideo;
  String? name;

  Media(
      {this.contentSize,
      this.contentType,
      this.extension,
      this.filePath,
      this.id,
      this.isVideo,
      this.name});

  Media.fromJson(Map<String, dynamic> json) {
    contentSize = json['contentSize'];
    contentType = json['contentType'];
    extension = json['extension'];
    filePath = json['filePath'];
    id = json['id'];
    isVideo = json['isVideo'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contentSize'] = contentSize;
    data['contentType'] = contentType;
    data['extension'] = extension;
    data['filePath'] = filePath;
    data['id'] = id;
    data['isVideo'] = isVideo;
    data['name'] = name;
    return data;
  }
}
