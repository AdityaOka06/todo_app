import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_cubit.dart';
import '../../util/size_config.dart';
import '../home_page/home_page.dart';
import '../login_page/login_page.dart';
import '../../widget/loading_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => SplashCubit()..splashCheck(),
      child: Scaffold(
        body: BlocListener<SplashCubit, SplashState>(
          listener: (context, state){
            if(state is SplashStateLogin){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            } else if(state is SplashStateHome){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            }
          },
          child: loadingWidget(context),
        ),
      ),
    );
  }
}