import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/widget/loading_widget.dart';

import 'login_cubit.dart';
import '../home_page/home_page.dart';
import '../../util/size_config.dart';
import '../../widget/error_alert.dart';
import '../register_page/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObsecure = true;
  DateTime backPressed = DateTime.now();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final cantExit = DateTime.now().difference(backPressed) >= const Duration(seconds: 2);
        backPressed = DateTime.now();
        if(cantExit){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press once again to exit')),
          );
          return false;
        } else {
          exit(0);
        }
      },
      child: BlocProvider(
        create: (context) => LoginCubit(),
        child: Scaffold(
          body: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state){
              if(state is LoginStateLoading){
                showDialog(context: context, builder: (context) => loadingWidget(context));
              } else if(state is LoginStateError){
                Navigator.pop(context);
                errorAlert(state.message, context);
              } else if(state is LoginStateComplated){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              }
              else {
                print('state is $state');
              }
            },
            builder: (context, state){
              return Column(
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
                  // Container(
                  //   margin: EdgeInsets.symmetric(
                  //     horizontal: SizeConfig.sizeHorizontal(3),
                  //   ),
                  //   alignment: Alignment.bottomRight,
                  //   child: TextButton(
                  //     onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                  //     child: const Text(
                  //       'Register',
                  //       style: TextStyle(color: Color(0xffb7bbc3)),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: SizeConfig.sizeVertical(2),
                  ),
                  SizedBox(
                    width: SizeConfig.sizeHorizontal(95),
                    child: ElevatedButton(
                      onPressed: (){
                        String finalEmail = emailController.text.trim();
                        String finalPassword = passwordController.text.trim();
                        if(finalEmail == '' || finalPassword == ''){
                          errorAlert('Email and/or password is empty', context);
                        } else{
                          context.read<LoginCubit>().loginPost(finalEmail, finalPassword);
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.sizeHorizontal(3),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                      child: Text(
                        "DON'T HAVE AN ACCOUNT ?",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      )
    );
  }
}