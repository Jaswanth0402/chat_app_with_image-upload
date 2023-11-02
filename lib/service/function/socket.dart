import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketMethods{

  static sendData({required String name,required String text, WebSocketChannel? channel, required String image }) {   
    print(image);
    print(text);
    if(text.isEmpty){
      text=text.toString();
    }
    if (text.isNotEmpty || image.isNotEmpty) {   
     final Map<String, dynamic>  jsonmsg = {
        "name": name,
        "text": text,
        "image":image,
      };    
      channel?.sink.add(json.encode(jsonmsg));
       
    }
  }

  static deleteMsg({required int index,required List<dynamic> msg}){
     msg.removeAt(index);

     return msg;    
 }
 static editMsg({required int index,required List<dynamic> msg,required String text,}){
      msg[index]['text'] = text;
  
      return msg;
 }
}