import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/widget/loading_widget.dart';

import 'home_page.dart';
import 'register_page.dart';
import '../util/size_config.dart';
import '../widget/error_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObsecure = true;
  DateTime backPressed = DateTime.now();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final timeGap = DateTime.now().difference(backPressed);
        final cantExit = timeGap >= const Duration(seconds: 2);
        backPressed = DateTime.now();
        if(cantExit){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press once again to exit')),
          );
          return false;
        }else {
          exit(0);
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.circleCheck,
              color: Theme.of(context).primaryColor,
              size: SizeConfig.sizeVertical(15),
            ),
            SizedBox(
              height: SizeConfig.sizeVertical(2),
            ),
            Text(
              'TO DO',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: SizeConfig.sizeVertical(6)
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.sizeVertical(2),
                right: SizeConfig.sizeHorizontal(5),
                left: SizeConfig.sizeHorizontal(5),
                bottom: SizeConfig.sizeVertical(1),
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      icon: FaIcon(
                        FontAwesomeIcons.solidEnvelope,
                        color: Theme.of(context).primaryColor,
                      ),
                      hintText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: isObsecure,
                    decoration: InputDecoration(
                      icon: FaIcon( 
                        FontAwesomeIcons.lock,
                        color: Theme.of(context).primaryColor,
                      ),
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            isObsecure = !isObsecure;
                          });
                        },
                        icon: (isObsecure)
                        ? const FaIcon(FontAwesomeIcons.eyeSlash, color: Color(0xffc0c2c5))
                        : FaIcon(FontAwesomeIcons.eye, color: Theme.of(context).primaryColor,),
                      )
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.sizeHorizontal(3),
              ),
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const RegisterPage())
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(color: Color(0xffb7bbc3)),
                ),
              ),
            ),
            SizedBox(
              width: SizeConfig.sizeHorizontal(95),
              child: ElevatedButton(
                onPressed: () async{
                  showDialog(
                    barrierDismissible: false,
                    context: context, builder: (context) => loadingWidget(context)
                  );
                  final String finalEmail = emailController.text.trim();
                  final String finalPassword = passwordController.text.trim();

                  if(finalEmail == '' || finalPassword == ''){
                    Navigator.pop(context);
                    errorAlert('Email and/or password is empty', context);
                  } else {
                    try{
                      await auth.signInWithEmailAndPassword(email: finalEmail, password: finalPassword);
                      Future.delayed( const Duration(seconds: 1), () => 
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()))
                      );
                    }on FirebaseAuthException catch(e){
                      //invalid-email
                      //user-not-found
                      //wrong-password
                      String message = '';
                      switch (e.code) {
                        case 'invalid-email':
                          message = 'Invalid email input';
                          break;
                        case 'user-not-found':
                          message = 'Account with this email does not exist';
                        break;
                        case 'wrong-password':
                          message = 'Email and password does not match';
                        break;
                        default:
                          print('error code = ${e.code}');
                          message = '${e.message}';
                        break;
                      }
                      Navigator.pop(context);
                      errorAlert(message, context);
                      // print('error code = ${e.code}');
                      // Navigator.pop(context);
                      // errorAlert('${e.message}', context);
                    }catch(e){
                      Navigator.pop(context);
                      errorAlert('on catch \n $e', context);
                    }
                  }
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
