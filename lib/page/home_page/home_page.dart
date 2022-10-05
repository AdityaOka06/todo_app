import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home_cubit.dart';
import '../../util/size_config.dart';
import '../login_page/login_page.dart';
import '../../widget/error_alert.dart';
import '../../widget/loading_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..homeInit(),     
      child: Scaffold(
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state){
            if(state is HomeStateError){
              errorAlert(state.message, context);
            }
          },
          builder: (context, state){
            if(state is HomeStateLoading){
              return Center(
                child: loadingWidget(context),
              );
            }else if(state is HomeStateComplated){
              return Scaffold(
                appBar: AppBar(
                  leading: Container(),
                  title: Text(
                    'TO DO',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  actions: [Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.sizeHorizontal(2),
                    ),
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.rightFromBracket,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () => logOut(context),
                    ),
                  )],
                ),
                body: StreamBuilder(
                  stream: state.data.snapshots(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: loadingWidget(context),
                      );
                    } else{
                      if(snapshot.hasError){
                        return Center(
                          child: Text('snapshot error = ${snapshot.error}'),
                        );
                      }else if(snapshot.hasData){
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
                                  color: Theme.of(context).appBarTheme.backgroundColor,
                                ),
                                child: ListTile(
                                  leading: InkWell(
                                    onTap: () =>context.read<HomeCubit>().changeStatusTodo(
                                      document.id, data['finish']
                                    ),
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
                                    onPressed: () => context.read<HomeCubit>().deleteTodo(document.id),
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
                      }else {
                        return Center(
                          child: Text('snapshot = $snapshot'),
                        );
                      }
                    }
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  elevation: 1,
                  onPressed: () => addTodo(context),
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.plus,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              );
            }else{
              return Container();
            }
          },
        ),
      ),
    );
  }
}

void logOut(BuildContext context) async{
  showDialog(context: context, builder: (context) => BlocProvider(
    create: (context) => HomeCubit(),
    child: BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state){
        return AlertDialog(
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
                context.read<HomeCubit>().logOut();
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
        );
      },
    ),
  ));
}

void addTodo(BuildContext context) async{
  TextEditingController todoController = TextEditingController();
  showDialog(context: context, builder: (context){
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state){
          return Dialog(
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
                      fontSize: 20,
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
                      ElevatedButton(
                        onPressed: (){
                          String finalTodo = todoController.text.trim();
                          if(finalTodo != ''){
                            context.read<HomeCubit>().addTodo(finalTodo);
                            Navigator.pop(context);
                          }
                        }, 
                        child: const Text('Save')
                      ),
                      TextButton(onPressed: ()=> Navigator.pop(context), 
                        child: Text(
                          'Cancle', style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  });
}