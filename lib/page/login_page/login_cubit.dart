import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_services.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState>{
  LoginCubit() : super(LoginState());

  AuthService service = AuthService();

  Future<void> loginPost(String email, String password) async{
    emit(LoginStateLoading());  
    try{
      var response = await service.logInUser(email, password);
      if(response.runtimeType == UserCredential){
        emit(LoginStateComplated());
      } else if(response.runtimeType == FirebaseAuthException){
        response as FirebaseAuthException;
        String message = '';
        switch (response.code) {
          case 'invalid-email':
            message = 'Invalid email input';
            break;
          case 'user-not-found':
          case 'wrong-password':
            message = 'You have enter an invalid email or password';
            break;
          default:
            message = '${response.message}';
          break;
        }
        emit(LoginStateError(message: message));
      }
    }catch(e){
      emit(LoginStateError(message: 'error \n$e'));
    }
  }
}