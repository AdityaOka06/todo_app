import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_services.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState>{
  RegisterCubit(): super(RegisterState());

  Future<void> registerPost(String email, String password) async{
    AuthService service = AuthService();
    emit(RegisterStateLoading());

    try{
      var response = await service.registerUser(email, password);
      print('response = $response');
      if(response.runtimeType == UserCredential){
        emit(RegisterStateComplated());
      } else if(response.runtimeType == FirebaseAuthException){
        response as FirebaseAuthException;
        emit(RegisterStateError(message: '${response.message}'));
      }
    }catch(e){
      emit(RegisterStateError(message: '$e'));
    }

  }
}
