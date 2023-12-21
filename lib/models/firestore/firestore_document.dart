import 'package:weather_app/models/globals.dart';

class FirestoreDocument {
  String id;
  String? path;
  Map<String, dynamic> data = {};

  FirestoreDocument({
    this.id = "",
    Map<String, dynamic>? data,
    this.path,
  }) {
    this.data = data ?? this.data;
  }

  // this fetches the document from firestore
  Future<void> fetch() async {
    print("Fetch Firestore Doc: $path$id");
    assert(path != null);
    assert(id.isNotEmpty);
    path = path!.replaceAll(' ', '');
    if (!path!.endsWith('/')) {
      path = '${path!}/';
    }
    final value = await firestore.doc(path! + id).get();
    if (!value.exists) {
      print("Error: Firestore Document $path$id doesn't exists!");
      throw "Document doesn't exists.";
    }
    data = value.data() ?? {};
  }

  // this updates/creates the document on firestore
  Future<void> update() async {
    print("Update Firestore Doc: $path/$id");
    assert(path != null);
    assert(id.isNotEmpty);
    path = path!.replaceAll(' ', '');
    if (!path!.endsWith('/')) {
      path = '${path!}/';
    }
    await firestore.doc(path! + id).set(data);
  }
}
