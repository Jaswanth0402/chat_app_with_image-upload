import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:chat_app/service/bloc/chat_bloc.dart';
import 'package:chat_app/service/function/socket.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class bottomSheet extends StatelessWidget {
  final String name;
  final String msg;
  Uint8List resizeAndCompressImage(Uint8List imageFile, int maxWidth, int maxHeight, int quality){
  final image = img.decodeImage(imageFile)!;

  final resizedImage = img.copyResize(
    image,
    width: maxWidth,
    height: maxHeight,
  );
  final compressedImageBytes = img.encodeJpg(resizedImage, quality: quality);


  return compressedImageBytes;
}
  ChatBloc chatBloc =ChatBloc();
   bottomSheet({super.key,required this.name,required this.msg});
 final ImagePicker _picker =ImagePicker();
 
 Uint8List pickedImage =Uint8List(8);
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document",(){}),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera",(){print("clicked camera");}),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery", ()async{
                       XFile? file  =await _picker.pickImage(source: ImageSource.gallery);

                       if(file!=null){
                        var filepicked = await file.readAsBytes();
                             pickedImage=filepicked;
                            Uint8List?  imgfile =  resizeAndCompressImage(pickedImage, 40,40, 720);
                             
                             String image = base64Encode(imgfile);
                             chatBloc.add(MsgSendEvent( name: name,image: image,text: msg));
                       }else{
                            print("some thing went wrong");
                       }
                      
                           
                      // print(response);
                  }),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio",(){}),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location",(){}),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact",(){}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 Widget iconCreation(IconData icons, Color color, String text,Function() onshow ) {
    return InkWell(
      onTap: onshow,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }