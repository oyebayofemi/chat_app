import 'package:chat_app/services.dart/auth_service.dart';
import 'package:chat_app/shared/toast.dart';
import 'package:chat_app/shared/validate_email.dart';
import 'package:chat_app/shared/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isloading = false;
  String? email;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.red,
                      size: 300.sp,
                    ),
                    SizedBox(
                      height: 70.h,
                    ),
                    Text(
                      'Reset Password',
                      style: authHeadersText(),
                    ),
                    SizedBox(height: 150.h),
                    TextFormField(
                      onChanged: (value) => this.email = value,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty
                          ? 'Email Field cant be empty'
                          : validateEmail(value, context),
                      textInputAction: TextInputAction.next,
                      decoration:
                          textFormFieldDecoration().copyWith(hintText: 'Email'),
                    ),
                    SizedBox(
                      height: 70.h,
                    ),
                    ButtonTheme(
                      buttonColor: Colors.white,
                      minWidth: MediaQuery.of(context).size.width,
                      height: 150.h,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(70.r))),
                      child: FlatButton(
                        color: Colors.green,
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              _isloading = true;
                            });
                            try {
                              await AuthService()
                                  .resetPasswordLink(email!, context);

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
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
