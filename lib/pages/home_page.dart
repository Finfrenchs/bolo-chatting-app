import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/datasources/firebase_datasource.dart';
import '../data/models/user_model.dart';
import 'chat_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void _logout() async {
    try {
      await auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout Success'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const LoginPage();
      }), (route) => false);
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Logout Failed'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Image.asset('assets/images/logo-chat2.png')),
        centerTitle: false,
        backgroundColor: Colors.red.shade900,
        actions: [
          IconButton(
              onPressed: () {
                _logout();
                //FirebaseAuth.instance.signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
          stream: FirebaseDatasource.instance.allUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<UserModel> users = (snapshot.data ?? [])
                .where((element) => element.id != auth.currentUser!.uid)
                .toList();
            //if user is null
            if (users.isEmpty) {
              return const Center(
                child: Text('No user found'),
              );
            }
            return ListView.separated(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      radius: 25,
                      child: Text(users[index].userName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(users[index].userName),
                    subtitle: const Text('Last message'),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ChatPage(
                          partnerUser: users[index],
                        );
                      }));
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                });
          }),
    );
  }
}
