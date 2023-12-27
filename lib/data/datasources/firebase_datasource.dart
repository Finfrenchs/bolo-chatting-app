import 'package:chat_app_firebase/data/models/chanel_model.dart';
import 'package:chat_app_firebase/data/models/message_model.dart';
import 'package:chat_app_firebase/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String channelId(String id1, String id2) {
  if (id1.hashCode < id2.hashCode) {
    return '$id1-$id2';
  } else {
    return '$id2-$id1';
  }
}

class FirebaseDatasource {
  FirebaseDatasource._init();

  static final FirebaseDatasource instance = FirebaseDatasource._init();

  //Get All user
  Stream<List<UserModel>> allUser() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((event) {
      List<UserModel> rs = [];

      for (var element in event.docs) {
        rs.add(UserModel.fromDocumentSnapshot(element));
      }

      return rs;
    });
  }

  //List chat
  Stream<List<Channel>> channelStream(String userId) {
    return FirebaseFirestore.instance
        .collection('channels')
        .where('memberIds', arrayContains: userId)
        .orderBy('lastTime', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<Channel> rs = [];
      for (var element in querySnapshot.docs) {
        rs.add(Channel.fromDocumentSnapshot(element));
      }
      return rs;
    });
  }

  Future<void> updateChannel(
      String channelId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(channelId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> addMessage(Message message) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .add(message.toMap());
  }

  //list data baru message di channel yang sama
  Stream<List<Message>> messageStream(String channelId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('channelId', isEqualTo: channelId)
        .orderBy('sendAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<Message> rs = [];
      for (var element in querySnapshot.docs) {
        rs.add(Message.fromDocumentSnapshot(element));
      }
      return rs;
    });
  }
}