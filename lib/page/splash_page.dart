import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';
import 'login_page.dart';
import '../util/size_config.dart';
import '../widget/loading_widget.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    var result = FirebaseAuth.instance.currentUser;
    if(result == null){
      Future((){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      });
    }else{
      Future((){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: loadingWidget(context),
    );
  }
}