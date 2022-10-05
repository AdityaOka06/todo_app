import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_services.dart';

class TodoService{

  Future<CollectionReference> getCollection() async{
    User? user = await AuthService().getUser();
    return FirebaseFirestore.instance.collection('todo').doc(user!.uid).collection('my_todo');
  }

  Future<Query<Object?>> streamTodo() async{
    try{
      CollectionReference ref = await getCollection();
      return ref.orderBy('created_at', descending: false);
    }catch(e){
      throw Exception('error = $e');
    }
  }

  Future<void> changeStatusTodo(String id, bool value) async{
    CollectionReference ref = await getCollection();
    await ref.doc(id).update({'finish' : !value,})
      .then((value) => print('done'))
      .onError((error, stackTrace) => throw Exception('error update todo = $error'));
  }

  Future<void> deleteTodo(String id) async{
    CollectionReference ref = await getCollection();
    await ref.doc(id).delete().then((value) => print('done')).onError((error, stackTrace) => throw Exception('error = $error'));
  }

  Future<void> createTodo(String todo, DateTime date) async{
    CollectionReference ref = await getCollection();
    ref.add({
      'todo' : todo,
      'finish' : false,
      'created_at' : date,
    }).then((value) => print('done')).onError((error, stackTrace) => throw Exception('error $error'));
  }
}
