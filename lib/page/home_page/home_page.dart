import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../util/size_config.dart';
import '../login_page/login_page.dart';
import '../../widget/error_alert.dart';
import '../../widget/loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String user = FirebaseAuth.instance.currentUser!.uid;
  late CollectionReference ref;
  late Stream<QuerySnapshot> todoStream;
  DateTime backPressed = DateTime.now();
  @override
  void initState(){
    ref = FirebaseFirestore.instance.collection('todo').doc(user).collection('my_todo');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
         final timeGap = DateTime.now().difference(backPressed);
        final cantExit = timeGap >= const Duration(seconds: 2);
        backPressed = DateTime.now();
        if(cantExit){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press once again to exit')),
          );
          return false;
        }else {
          exit(0);
        }
      },
      child: Scaffold(  
        appBar: AppBar(
          leading: Container(),
          title: Text(
            'TO DO',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.sizeHorizontal(2),
              ),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.rightFromBracket,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.solidCircleQuestion,
                          color: Color(0xffEBCB8B),
                          size: 80,
                        ),
                      ),
                      content: const Text(
                        'Are you sure want to sign out ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xffdee5ee)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async{
                            FirebaseAuth.instance.signOut();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: ref.orderBy('created_at', descending: false).snapshots(),
          // stream: ref.snapshots(),
          builder: ((context, snapshot){
            print('snapshot =${snapshot.connectionState}');
            if(snapshot.connectionState == ConnectionState.waiting){
              return loadingWidget(context);
            } else{
              if(snapshot.hasError){
                return Center(
                  child: Text('some error \n ${snapshot.error}'),
                );
              } else if(snapshot.hasData){
                if(snapshot.data!.size == 0){
                  return const Center(
                    child: Text('No Todo'),
                  );
                } else{
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document){
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.sizeVertical(1),
                          horizontal: SizeConfig.sizeHorizontal(1),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).appBarTheme.backgroundColor
                        ),
                        child: ListTile(
                          leading: InkWell(
                            onTap: (){
                              // print('document id = ${document.id}');
                              todoFinish(document.id, data['finish']);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: SizeConfig.sizeVertical(4),
                              width: SizeConfig.sizeVertical(4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (data['finish'])
                                    ? Theme.of(context).primaryColor
                                    : const Color(0xff4C566A),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: (data['finish'])
                                ? Theme.of(context).primaryColor
                                : const Color(0xff4C566A),
                              ),
                            ),
                          ),
                          title: Text("${data['todo']}"),
                          trailing: IconButton(
                            onPressed: () => deleteTodo(document.id),
                            icon: const FaIcon(
                              FontAwesomeIcons.trash,
                              color: Color(0xffBF616A),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              }else{
                return Center(
                  child: Text('snapsot = $snapshot'),
                );
              }
            }
          }),
        ),
        floatingActionButton: FloatingActionButton(
          elevation:1,
          onPressed: () => addTodo(),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  void todoFinish(String id, bool value)async{
    await ref.doc(id).update({
      'finish': !value
    }).then((value) => print('done')).onError((error, stackTrace) => errorAlert('$error', context));
  }
  void deleteTodo(String id) async{
    await ref.doc(id).delete()
      .then((value) => print('done'))
      .onError((error, stackTrace) => errorAlert('$error', context));
  }

  void addTodo() async{
    TextEditingController todoController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        alignment: Alignment.center,
        insetPadding: EdgeInsets.symmetric(
          vertical: SizeConfig.sizeVertical(2),
          horizontal: SizeConfig.sizeHorizontal(5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.sizeVertical(2),
              ),
              child: Text(
                'TO DO',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20
                ),
              ),
            ),
            SizedBox( 
              width: SizeConfig.sizeHorizontal(80),
              child: TextFormField(
                controller: todoController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xffD8DEE9),
                      width: SizeConfig.sizeVertical(0.2)
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xffD8DEE9),
                      width: SizeConfig.sizeVertical(0.2),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: ''
                ),
                minLines: 1,
                maxLines: 5,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: SizeConfig.sizeVertical(2),
                horizontal: SizeConfig.sizeHorizontal(6),
              ),
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(onPressed: () async{
                    final String finalTodo = todoController.text.trim();
                    print("${finalTodo != ''}");
                    if(finalTodo != ''){
                      DateTime time = DateTime.now();
                      showDialog(context: context, builder: (context) => loadingWidget(context));
                      await ref.add({
                        'todo': finalTodo,
                        'finish' : false,
                        'created_at': time,
                      }).then((value){
                        print('done =${value}');
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }).onError((error, stackTrace){
                        Navigator.pop(context);
                        errorAlert('$error', context);
                      });
                    }else{
                      errorAlert('Todo cannot be empty', context);
                    }
                  }, child: const Text('Save')),
                  TextButton(
                    onPressed: () => Navigator.pop(context), 
                    child: Text('Cancel', style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600
                    ),)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

