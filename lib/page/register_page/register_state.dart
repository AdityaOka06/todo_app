part of 'register_cubit.dart';

class RegisterState{}

class RegisterStateLoading extends RegisterState{}
class RegisterStateError extends RegisterState{
  final String message;
  RegisterStateError({required this.message});
}
class RegisterStateComplated extends RegisterState{}