import 'package:chat_app/services.dart/auth_service.dart';
import 'package:chat_app/shared/validate_email.dart';
import 'package:chat_app/shared/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formkey = GlobalKey<FormState>();
  String? email, password, username;
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isloading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                      fontSize: 80.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green,
                                      letterSpacing: 1),
                                ),
                                SizedBox(
                                  height: 70.h,
                                ),
                                TextFormField(
                                  onChanged: (value) => this.username = value,
                                  validator: (value) {
                                    if (value!.length < 6) {
                                      return 'Username must be more than 6 characters';
                                    } else if (value.isEmpty) {
                                      return 'Username Field cant be empty';
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: textFormFieldDecoration()
                                      .copyWith(hintText: 'Username'),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                TextFormField(
                                  onChanged: (value) => this.email = value,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) => value!.isEmpty
                                      ? 'Email Field cant be empty'
                                      : validateEmail(value, context),
                                  textInputAction: TextInputAction.next,
                                  decoration: textFormFieldDecoration()
                                      .copyWith(hintText: 'Email'),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                TextFormField(
                                  onChanged: (value) => this.password = value,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.length < 6) {
                                      return 'Password must be more than 6 characters';
                                    } else if (value.isEmpty) {
                                      return 'Password Field cant be empty';
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.go,
                                  decoration: textFormFieldDecoration()
                                      .copyWith(hintText: 'Password'),
                                ),
                                SizedBox(
                                  height: 90.h,
                                ),
                                ButtonTheme(
                                  buttonColor: Colors.white,
                                  minWidth: MediaQuery.of(context).size.width,
                                  height: 150.h,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(70.r))),
                                  child: FlatButton(
                                    color: Colors.green,
                                    onPressed: () async {
                                      if (formkey.currentState!.validate()) {
                                        setState(() {
                                          _isloading = true;
                                        });
                                        try {
                                          await AuthService().signUp(
                                              email!, password!, context);
                                          setState(() {
                                            _isloading = false;
                                          });
                                        } catch (e) {
                                          print(e.toString());
                                          setState(() {
                                            _isloading = false;
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 40.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 35.h,
                                ),
                                ButtonTheme(
                                  //buttonColor: Colors.white,
                                  minWidth: MediaQuery.of(context).size.width,
                                  height: 150.h,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(70.r))),
                                  child: SignInButton(
                                    Buttons.Google,
                                    // elevation: 0,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    onPressed: () async {
                                      // final provider =
                                      //     Provider.of<AuthServiceControllerProvider>(
                                      //         context,
                                      //         listen: false);

                                      // provider.signInWithGoogle();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 60.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    Text('Already have an account?'),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      'SignIn Now',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
