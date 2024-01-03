class User {
  bool? active;
  String? birthPlace;
  bool? changePass;
  String? confirmPassword;
  int? countDayCheckin;
  int? countDayTracking;
  String? displayName;
  String? dob;
  String? email;
  String? firstName;
  String? gender;
  bool? hasPhoto;
  int? id;
  String? image;
  String? lastName;
  String? password;
  List<Roles>? roles;
  bool? setPassword;
  String? tokenDevice;
  String? university;
  String? username;
  int? year;

  User(
      {this.active,
        this.birthPlace,
        this.changePass,
        this.confirmPassword,
        this.countDayCheckin,
        this.countDayTracking,
        this.displayName,
        this.dob,
        this.email,
        this.firstName,
        this.gender,
        this.hasPhoto,
        this.id,
        this.image,
        this.lastName,
        this.password,
        this.roles,
        this.setPassword,
        this.tokenDevice,
        this.university,
        this.username,
        this.year});

  User.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    birthPlace = json['birthPlace'];
    changePass = json['changePass'];
    confirmPassword = json['confirmPassword'];
    countDayCheckin = json['countDayCheckin'];
    countDayTracking = json['countDayTracking'];
    displayName = json['displayName'];
    dob = json['dob'];
    email = json['email'];
    firstName = json['firstName'];
    gender = json['gender'];
    hasPhoto = json['hasPhoto'];
    id = json['id'];
    image = json['image'];
    lastName = json['lastName'];
    password = json['password'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    setPassword = json['setPassword'];
    tokenDevice = json['tokenDevice'];
    university = json['university'];
    username = json['username'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['birthPlace'] = this.birthPlace;
    data['changePass'] = this.changePass;
    data['confirmPassword'] = this.confirmPassword;
    data['countDayCheckin'] = this.countDayCheckin;
    data['countDayTracking'] = this.countDayTracking;
    data['displayName'] = this.displayName;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['gender'] = this.gender;
    data['hasPhoto'] = this.hasPhoto;
    data['id'] = this.id;
    data['image'] = this.image;
    data['lastName'] = this.lastName;
    data['password'] = this.password;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    data['setPassword'] = this.setPassword;
    data['tokenDevice'] = this.tokenDevice;
    data['university'] = this.university;
    data['username'] = this.username;
    data['year'] = this.year;
    return data;
  }
}

class Roles {
  String? description;
  int? id;
  String? name;

  Roles({this.description, this.id, this.name});

  Roles.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}