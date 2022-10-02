import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDbService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List> getDocs() async {
    QuerySnapshot snapshot = await _firestore.collection('highest-scores').orderBy('score', descending: true).get();
    return snapshot.docs;
  }

  Future<void> setNewScore(Map<String, dynamic> data) async {
    await _firestore.collection('highest-scores').doc().set(data);
  }

  Future<void> deleteLowestScore(int lowestScore) async {
    await _firestore.collection('highest-scores').where('score', isEqualTo: lowestScore).get().then((value) {
      for (var element in value.docs) {
        _firestore.collection('highest-scores').doc(element.id).delete();
      }
    });
  }
}
