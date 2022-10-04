import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home_page.dart';
import '../util/size_config.dart';
import '../widget/error_alert.dart';
import '../widget/loading_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  bool password1Obsecure = true;
  bool password2Obsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
              onPressed: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context, builder: (context) => loadingWidget(context)
                );

                final finalEmail = emailController.text.trim();
                final finalPassword1 = password1Controller.text.trim();
                final finalPassword2 = password2Controller.text.trim();

                if(finalEmail == '' || finalPassword1 == '' || finalPassword2 == ''){
                  errorAlert('Pleass fill all require field', context);
                } else if(finalPassword1 != finalPassword2){
                  errorAlert('Password that you input does not match', context);
                } else{
                  try{
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: finalEmail, password: finalPassword1);
                    Future.delayed(const Duration(seconds: 1),() => 
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()))
                    );
                  }on FirebaseAuthException catch(e){
                    Navigator.pop(context);
                    errorAlert('${e.message}', context);
                  }catch(e){
                    Navigator.pop(context);
                    errorAlert('on catch \n $e', context);
                  }
                }
              },
              child: const Text('Register'),
            ),
          ),
        ],
      ),
    );
  }
}
