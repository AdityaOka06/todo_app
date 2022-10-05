part of 'home_cubit.dart';

class HomeState{}

class HomeStateLoading extends HomeState{}
class HomeStateError extends HomeState{
  final String message;
  HomeStateError({required this.message});
}
class HomeStateComplated extends HomeState{
  Query<Object?> data;
  HomeStateComplated({required this.data});
}