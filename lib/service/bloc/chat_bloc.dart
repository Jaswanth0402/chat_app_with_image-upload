import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:chat_app/service/function/socket.dart';
import 'package:chat_app/service/modal/msg_modal.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(
        "wss://free.blr2.piesocket.com/v3/1?api_key=up3vboHjvHwv2ls80sySsnN5FZv1qtUSlI5zA9Xe&notify_self=1"));

  ChatBloc() : super(ChatInitial()) {
   on<InitialMsgConnectEvent>(initialMsgConnectEvent);
   on<InitialChannelCloseEvent>(initialChannelCloseEvent);
   on<MsgSendEvent>(msgSendEvent);
   on<DeleteMsgEvent>(deleteMsgEvent);
   on<EditMsgEvent>(editMsgEvent);
  }


  FutureOr<void> initialMsgConnectEvent(InitialMsgConnectEvent event, Emitter<ChatState> emit)async{
   
      List<dynamic> msgis=[];
     await for (final data in channel.stream) {
      print(data);
     try {
    var msg = json.decode(data);
    
     msgis.add(msg);
      print("msgis:$msgis");
    emit(ConnectionSuccessState(msg: msgis));
  } catch (e) {
    // Handle the error, e.g., print an error message or log it.
    print('Error decoding JSON: $e');
  }
    }
  }


  FutureOr<void> msgSendEvent(MsgSendEvent event, Emitter<ChatState> emit){
    emit(SendDataLoadingState());

     SocketMethods.sendData(name:event.name ,channel: channel,text: event.text,image:event.image);
    
    
    //  print('data sent');
     emit(SendDataSuccessState());
      
  }

  FutureOr<void> initialChannelCloseEvent(InitialChannelCloseEvent event, Emitter<ChatState> emit) {  
    
 channel.sink.close();
  }
 

  FutureOr<void> deleteMsgEvent(DeleteMsgEvent event, Emitter<ChatState> emit) {

   var response  = SocketMethods.deleteMsg(index:event.index, msg: event.msg);
    emit(ConnectionSuccessState(msg:response));
    // add(InitialMsgConnectEvent());
  }

  FutureOr<void> editMsgEvent(EditMsgEvent event, Emitter<ChatState> emit) {
     var response =SocketMethods.editMsg(index: event.index, msg: event.msg, text: event.text);
     emit(ConnectionSuccessState(msg:response));
  }
}



