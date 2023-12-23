import 'package:weather_app/models/firestore_document.dart';

class UserData extends FirestoreDocument {
  // The email and firestore id are the same for any user
  String get email {
    return super.id;
  }

  String? name;
  int? gender;
  DateTime? dob;
  String? phoneNumber;
  String? address;
  String? imgUrl;
  String? audioFile;

  UserData({
    super.id,
    this.name,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.address,
    this.imgUrl,
    this.audioFile,
  }) : super(path: "users");

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      "dob": dob?.millisecondsSinceEpoch,
      'imgUrl': imgUrl,
      'audioFile': audioFile,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData()..loadFromJson(json);
  }

  void loadFromJson(Map<String, dynamic> json) {
    id = json['email'] ?? json['id'] ?? id;
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    imgUrl = json['imgUrl'];
    audioFile = json['audioFile'];
    dob = json['dob'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['dob']);
  }

  @override
  Future<void> fetch() async {
    await super.fetch();
    loadFromJson(super.data);
  }

  @override
  Future<void> update() async {
    super.data = toJson();
    return super.update();
  }
}
