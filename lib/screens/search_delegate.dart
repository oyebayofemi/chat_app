import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class searchDelegate extends SearchDelegate {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  var currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          primaryTextTheme:
              Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.white),
          appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.green),
        );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();

    var userData = userProvider.currentUserData;
    return StreamBuilder<QuerySnapshot>(
      stream: collectionReference
          .orderBy('id', descending: false)
          .where('id', isNotEqualTo: currentUser)
          .snapshots()
          .asBroadcastStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: [
              ...snapshot.data!.docs
                  .where((QueryDocumentSnapshot<Object?> element) =>
                      element['name']
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String username = data.get('name');
                final String email = data.get('email');
                final String url = data.get('pictureModel');

                return url == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(backgroundImage: NetworkImage(url)),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 8, 0, 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('$username'),
                                      Text('$email')
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (userData!.email == email) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfilePage(),
                                        ));
                                  } else {}
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  // color: Colors.green,
                                  child: Text('Message'),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              })
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search for user'),
    );
  }
}
