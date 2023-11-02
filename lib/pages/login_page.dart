import 'package:chat_app/pages/chat_ui.dart';
import 'package:flutter/material.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  
  final GlobalKey<FormState>key =GlobalKey();
  TextEditingController name =TextEditingController();
  TextEditingController email =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:const Text('Login Here'),
      ),
      body:Form(
        key: key,
        child: Column(
          children:[
            TextFormField(
             controller:name ,
             decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)
              ),
              
             ),
             validator: (value) {
              if(value!.isEmpty){
                 return "Name field must be filled" ;
              }
              else{
                return null;              }
             },
            ),
            TextFormField(
             controller:email ,
             decoration: const InputDecoration(
              labelText: 'email',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)
              ),
              
             ),
             validator: (value) {
              if(value!.isEmpty){
                 return "email field must be filled" ;
              }
              else{
                return null;              }
             },
            ),
            ElevatedButton(onPressed: (){
              if(key.currentState!.validate()){
                  key.currentState!.save();
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>ChatUI(name:name.text,email:email.text)));
              }

            }, child: const Text('submit'))

          ]
        ),
      ),
    );
  }
}