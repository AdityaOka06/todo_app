import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getUser() async{
    return auth.currentUser;
  }

  Future<dynamic> registerUser(String email, String password) async{
    try{
      var response = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return response;
    }on FirebaseAuthException catch(e){
      return e;
    }catch(e){
      throw Exception('catch = $e');
    }
  }

  Future<dynamic> logInUser(String email, String password) async{
    try{
      var response = await auth.signInWithEmailAndPassword(email: email, password: password);
      return response;
    } on FirebaseAuthException catch(e){
      return  e;
    } catch(e){
      throw Exception(e);
    }
  }

  Future<void> logOutUser()async{
    await auth.signOut();
  }
}