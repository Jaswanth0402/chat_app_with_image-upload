 import 'package:flutter/foundation.dart';

class Message {
	
	final String name;
	final String? text;
  final Uint8List? image;
	

	Message({
	
		required this.name,
		required this.text,
		required this.image
	});

	factory Message.fromJson(Map<String, dynamic> json){
    return Message(name:json['name'], text:json['text'],image: json['image']);
  } 
		
	Map<String, dynamic> toJson(){
   return{
    
    'name':name,
    'text':text,
    'image':image
   };
   
  } 
}