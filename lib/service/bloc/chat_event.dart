part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class InitialMsgConnectEvent extends ChatEvent{
}
class InitialChannelCloseEvent extends ChatEvent{
}

class MsgSendEvent extends ChatEvent{
final String name;
final String text;
final String image;


  MsgSendEvent({required this.text,required this.name, required this.image});
}

class DeleteMsgEvent extends ChatEvent{
  final int index;
  final List<dynamic>msg;

  DeleteMsgEvent({required this.index, required this.msg}); 
}

class EditMsgEvent extends ChatEvent{
  final int index;
  final List<dynamic>msg;
  final String text;

  EditMsgEvent({required this.index, required this.msg, required this.text});

}
