import 'dart:convert';
import 'dart:typed_data';
import 'package:chat_app/base/imageshow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_app/base/card.dart';
import 'package:chat_app/service/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;

class ChatUI extends StatefulWidget {
  String name;
  String email;
   
  ChatUI({super.key, required this.name, required this.email});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  List<dynamic>msg=[];
    String? image;
    String? textmsg;
    
  @override
  void initState() {
    chatBloc.add(InitialMsgConnectEvent());
    super.initState();
    textmsg =controller.text;
    
  }  
final ImagePicker _picker =ImagePicker();
 
 Uint8List? pickedImage ;
  ChatBloc chatBloc = ChatBloc();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat YourSelf"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
                child: BlocConsumer(
                    bloc: chatBloc,
                    listenWhen: (previous, current) =>
                        current is ChatActionState,
                    buildWhen: (previous, current) =>
                        current is! ChatActionState,
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is ConnectionSuccessState) {
                        return Container(
                            child: ListView.builder(
                                itemCount: state.msg.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTapUp: (details) {
                                      showContextMenu(context,details,index,state.msg);
                                    },
                                    child: 
                                    Column(
                                      children: [
                                        state.msg[index]['text']!=null?  MyCard(
                                            sendname: widget.name,
                                            recievename: state.msg[index]['name'],
                                            msg: state.msg[index]['text'],):const SizedBox(height: 1,),
                                       state.msg[index]['image']!=null ? MyImage(sendname: widget.name,
                                            recievename: state.msg[index]['name'],image: state.msg[index]["image"]):const SizedBox(height: 1,),
                                      ],
                                    ),
                                        
                                  );
                                }));
                      } else {
                        return const SizedBox(
                          height: 8,
                        );
                      }
                    })),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:  InputDecoration(
                      hintText: "Message...",
                      hintStyle: const TextStyle(color: Colors.blue),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      suffixIcon:   IconButton(
                                            icon: const Icon(Icons.attach_file),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (builder) =>
                                                       bottomSheet());
                                            },
                                          )
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      textmsg =controller.text;
                      chatBloc.add(MsgSendEvent(
                          name: widget.name, text: textmsg.toString(),image:image.toString()));
                          image = null;
                           textmsg=null;
                           controller.clear();
                    },
                    icon: const Icon(Icons.send))
              ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    chatBloc.add(InitialChannelCloseEvent());
    super.dispose();
  }
  void showContextMenu(BuildContext context,TapUpDetails details,int index,List<dynamic>msg) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
       details.globalPosition & overlay.size,
        Offset.zero & overlay.size,
      ),
      items: <PopupMenuEntry>[
         PopupMenuItem(
          child: TextButton(onPressed: (){
            controller.text=msg[index]['text'];
          }, child:const Text("Edit")),
        ),
         PopupMenuItem(
          child: TextButton(onPressed: (){
            // SocketMethods.deleteMsg(index:index ,msg: msg);
            chatBloc.add(DeleteMsgEvent(index: index, msg: msg));
            Navigator.pop(context);
          }, child:const Text("Delete")),
        ),
      ],
    );
  }
  Widget bottomSheet(){
    return
  Container(
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
                    Navigator.pop(context);
                       XFile? file  =await _picker.pickImage(source: ImageSource.gallery);

                       if(file!=null){
                        var filepicked = await file.readAsBytes();
                             pickedImage=filepicked;
                             if(pickedImage!=null){
                            Uint8List?  imgfile =resizeAndCompressImage(pickedImage!, 40,40, 720);
                             
                              image = base64Encode(imgfile);
                              
                             }
                             else{
                              print('the file is null');
                             }
                             
                              
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
}
