import 'package:bloc/bloc.dart';

import '../../services/auth_services.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState>{
  SplashCubit() : super(SplashState());

  AuthService service = AuthService();

  Future<void> splashCheck() async{
    var response = await service.getUser();
    print('response = $response');
    if(response == null){
      emit(SplashStateLogin());
    } else{
      emit(SplashStateHome());
    }
  }
}