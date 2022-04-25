import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/shared/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();

    var userData = userProvider.currentUserData;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: userData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(userData.pictureModel!),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'Name: ',
                        style: profileHeader(),
                      ),
                      Text(
                        '${userData.name}',
                        style: profileText(),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'Email: ',
                        style: profileHeader(),
                      ),
                      Text(
                        '${userData.email}',
                        style: profileText(),
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
    ));
  }
}
