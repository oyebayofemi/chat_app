import 'package:chat_app/screens/authentication/signup.dart';
import 'package:chat_app/services.dart/auth_service.dart';
import 'package:chat_app/shared/validate_email.dart';
import 'package:chat_app/shared/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SigninPage extends StatefulWidget {
  SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final formkey = GlobalKey<FormState>();
  String? email, password;
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formkey,
          child: _isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              image: DecorationImage(
                                image: AssetImage("assets/chat_logo.png"),
                                fit: BoxFit.fitWidth,
                              )),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'SIGN IN',
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
                                  onChanged: (value) => this.email = value,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) => value!.isEmpty
                                      ? 'Email Field cant be empty'
                                      : validateEmail(value, context),
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
                                  height: 20.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 15.w, top: 10.h),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Forgot Password?',
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
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
                                          await AuthService().signin(
                                              email!, password!, context);
                                          setState(() {
                                            _isloading = false;
                                          });
                                        } catch (e) {
                                          setState(() {
                                            _isloading = false;
                                          });
                                          print(e.toString());
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Sign In',
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
                                    Text('Dont have an account?'),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignUpPage(),
                                          )),
                                      child: Text(
                                        'Register Now',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                )
                              ],
                            ),
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
    );
  }
}
