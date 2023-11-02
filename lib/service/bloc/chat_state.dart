part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

 class ChatActionState extends ChatState {}

final class ChatInitial extends ChatState {}

class ConnectionLoadingState extends ChatState{}

// ignore: must_be_immutable
class ConnectionSuccessState extends ChatState{
final List<dynamic> msg;
  ConnectionSuccessState({required this.msg});
}

class SendDataLoadingState extends ChatActionState{}

class SendDataSuccessState extends ChatActionState{}
