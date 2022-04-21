import 'package:chat_app/model/userModel.dart';
import 'package:chat_app/services.dart/auth_service.dart';
import 'package:chat_app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        StreamProvider<UserModel?>(
          catchError: (User, UserModel) => null,
          create: (context) => context.read<AuthService>().onAuthStateChanged,
          initialData: null,
        )
      ],
      child: ScreenUtilInit(
        designSize: Size(1080, 2340),
        builder: (BuildContext c) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: Wrapper(),
        ),
      ),
    );
  }
}
