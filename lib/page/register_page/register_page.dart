import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'register_cubit.dart';
import '../../util/size_config.dart';
import '../../widget/error_alert.dart';
import '../login_page/login_page.dart';
import '../../widget/loading_widget.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool password1Obsecure = true;
  bool password2Obsecure = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Scaffold(
       body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state){
          if(state is RegisterStateLoading){
            showDialog(context: context, builder: (context) => loadingWidget(context));
          } else if(state is RegisterStateError){
            Navigator.pop(context);
            errorAlert(state.message, context);
          } else if(state is RegisterStateComplated){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
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
              Text(
                'TO DO',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: SizeConfig.sizeVertical(6),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.sizeVertical(1),
                  horizontal: SizeConfig.sizeHorizontal(5),
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
                      controller: password1Controller,
                      obscureText: password1Obsecure,
                      decoration: InputDecoration(
                        icon: FaIcon(
                          FontAwesomeIcons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              password1Obsecure = !password1Obsecure;
                            });
                          },
                          icon: (password1Obsecure)
                          ? const FaIcon(FontAwesomeIcons.eyeSlash, color: Color(0xffc0c2c5),) 
                          : FaIcon(FontAwesomeIcons.eye, color: Theme.of(context).primaryColor,),
                        )
                      ),
                    ),
                    TextFormField(
                      controller: password2Controller,
                      obscureText: password2Obsecure,
                      decoration: InputDecoration(
                        icon: FaIcon(
                          FontAwesomeIcons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: 'Input password again',
                        suffixIcon: IconButton(
                          onPressed: (){
                            print("obsecure 2 = $password2Obsecure");
                            setState(() {
                              password2Obsecure = !password2Obsecure;
                            });
                          },
                          icon: (password2Obsecure)
                          ? const FaIcon(FontAwesomeIcons.eyeSlash, color: Color(0xffc0c2c5),) 
                          : FaIcon(FontAwesomeIcons.eye, color: Theme.of(context).primaryColor,),
                        )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.sizeVertical(2),
              ),
              SizedBox(
                width: SizeConfig.sizeHorizontal(95),
                child: ElevatedButton(
                  onPressed: (){
                    String finalEmail = emailController.text.trim();
                    String finalPassword1 = password1Controller.text.trim();
                    String finalPassword2 = password2Controller.text.trim();

                    if(finalEmail == '' || finalPassword1 == '' || finalPassword2 == ''){
                      errorAlert('Please fill all reuire field', context);
                    } else if(finalPassword1 != finalPassword2){
                      errorAlert('Password that you input does not match', context);
                    } else{
                      context.read<RegisterCubit>().registerPost(finalEmail, finalPassword1);
                    }
                  },
                  child: const Text('Register'),
                ),
              )
            ],
          );
        },
       )
      ),
    );
  }
}