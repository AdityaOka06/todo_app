import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/todo_services.dart';
import '../../services/auth_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit() : super(HomeState());

  TodoService service = TodoService();

  Future<void> homeInit() async{
    emit(HomeStateLoading());
    try{
      Query<Object?> result = await service.streamTodo();
      emit(HomeStateComplated(data: result));
    }catch(e){
      emit(HomeStateError(message: '$e'));
    }
  }

  Future<void> changeStatusTodo(String id, bool value) async{
    await service.changeStatusTodo(id, value)
    .then((value) => print('done'))
    .onError((error, stackTrace) => emit(HomeStateError(message: '$error')));
  }

  Future<void> deleteTodo(String id) async{
    await service.deleteTodo(id)
      .then((value) => print('done'),)
      .onError((error, stackTrace) => emit(HomeStateError(message: '$error')));
  }

  Future<void> addTodo(String todo) async{
    DateTime date = DateTime.now();
    await service.createTodo(todo, date)
      .then((value) => print('done'))
      .onError((error, stackTrace) => emit(HomeStateError(message: '$error')));
  }

  Future<void> logOut() async{
    AuthService auth = AuthService();
    await auth.logOutUser();
  }
}