part of 'login_cubit.dart';

class LoginState{}

class LoginStateLoading extends LoginState{}
class LoginStateError extends LoginState{
  final String message;
  LoginStateError({required this.message});
}

class LoginStateComplated extends LoginState{}