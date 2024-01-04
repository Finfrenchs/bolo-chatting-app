// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/datasources/firebase_datasource.dart';
import '../data/models/chanel_model.dart';
import '../data/models/message_model.dart';
import '../data/models/user_model.dart';
import 'widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final UserModel partnerUser;
  const ChatPage({
    Key? key,
    required this.partnerUser,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }
    //channel not created yet

    //buat channel dulu ketika send == membuat room chat dengan partner chat
    final channel = Channel(
      id: channelId(currentUser!.uid, widget.partnerUser.id),
      memberIds: [currentUser!.uid, widget.partnerUser.id],
      lastMessage: _messageController.text.trim(),
      lastTime: Timestamp.now(),
      unRead: {
        currentUser!.uid: false,
        widget.partnerUser.id: true,
      },
      members: [UserModel.fromFirebaseUser(currentUser!), widget.partnerUser],
      sendBy: currentUser!.uid,
    );

    //update ke channel nya atau room chatnya
    await FirebaseDatasource.instance
        .updateChannel(channel.id, channel.toMap());

    var docRef = FirebaseFirestore.instance
        .collection('messages')
        .doc(); //membuat pesan nya dan dimasukan ke dalam data message
    var message = Message(
      id: docRef.id,
      textMessage: _messageController.text.trim(),
      senderId: currentUser!.uid,
      sendAt: Timestamp.now(),
      channelId: channel.id,
    );
    FirebaseDatasource.instance.addMessage(message); //add message nya

    //update channel
    var channelUpdateData = {
      'lastMessage': message.textMessage,
      'sendBy': currentUser!.uid,
      'lastTime': message.sendAt,
      'unRead': {
        currentUser!.uid: false,
        widget.partnerUser.id: true,
      },
    };
    FirebaseDatasource.instance.updateChannel(channel.id, channelUpdateData);

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.partnerUser.userName,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade900,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
                stream: FirebaseDatasource.instance.messageStream(channelId(
                  widget.partnerUser.id,
                  currentUser!.uid,
                )),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final List<Message> messages = snapshot.data ?? [];
                  //message null
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text('No message found'),
                    );
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    reverse: true,
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      // Chat room messages here
                      return ChatBubble(
                        direction: message.senderId == currentUser!.uid
                            ? Direction.right
                            : Direction.left,
                        message: message.textMessage,
                        //photoUrl: message.photo.toUpperCase(),

                        type: BubbleType.top,
                      );
                    },
                  );
                }),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.red.shade900,
                  ),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
