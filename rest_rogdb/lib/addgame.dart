import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rest_rogdb/account.dart';

import 'connection.dart';


class AddPage extends StatefulWidget{
  const AddPage({super.key, });
  @override
  State<StatefulWidget> createState() {
    return AddPageState();
  }
}

class AddPageState extends State<AddPage>{
  
  
  TextEditingController controllerN = TextEditingController();
  TextEditingController controllerDe = TextEditingController();
  TextEditingController controllerPr = TextEditingController();
  TextEditingController controllerD = TextEditingController();
  TextEditingController controllerSc = TextEditingController();
  TextStyle textStyle =const TextStyle(
    height: 2,
    fontSize: 18
  );
  File? image;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 234, 236),
        title: const Text("Game")
      ),

      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: controllerN,
              decoration: const InputDecoration(
                  hintText: "name",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: controllerDe,
              maxLines: 10,
              decoration: const InputDecoration(
                  hintText: "descrizione",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)),)
                ),
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                SizedBox(width: 150, child:TextField(
                keyboardType: TextInputType.number,
                controller: controllerPr,
                decoration: const InputDecoration(
                    
                    hintText: "prezzo",
                    contentPadding: EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                  ),
                ),),
                const SizedBox(height: 30,),
                SizedBox(width: 150, child: TextField(
                  keyboardType: TextInputType.number,
                  controller: controllerSc,
                  decoration: const InputDecoration(
                      hintText: "sconto",
                      contentPadding: EdgeInsets.only(left: 30),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                    ),
                  ),)
              ],
            ),
            const SizedBox(height: 30,),
            
            TextField(
              keyboardType: TextInputType.datetime,
              controller: controllerD,
              readOnly: true,
              onTap: () {showDateaPicker();},
              decoration: const InputDecoration(
                  hintText: "data",
                  
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            const SizedBox(height: 30,),
            uploadedImage(),
            TextButton(onPressed: upload, child: const Text("Upload"))
          ],
        )
      ),
    );
  }

  Widget uploadedImage(){
    if(image != null){
      return Row(
        children: [
          Image.file(image!,width: 100,fit: BoxFit.fitWidth,),
          IconButton(onPressed: (){image = null; setState(() {});}, icon: const Icon(Icons.delete))
        ],
      );
    }else{
      return TextButton(onPressed: pickImage, child: const Text("image"));
    }
  }

  void upload() async{
    String? mail = Account().getEmail();
    if(mail == null){
      showError("not logged");
      return;
    }
    if(image!=null){
      Connection().uploadImg(File(image!.path));
    }
    bool res = await Connection().uploadGame(controllerN.text, controllerDe.text, controllerPr.text, controllerSc.text, mail, (image==null?"x":image!.path.split("/").last), controllerD.text);
    showError(res?"added":"not added");
  }

  void showDateaPicker() async{
    DateTime? date = await showDatePicker(context: context,
      initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.utc(DateTime.now().year+5)
    );
    if(date != null){
      controllerD.text = date.toString().split(" ")[0];
    }else if(controllerD.text == ""){
      controllerD.text = DateTime.now().toString().split(" ")[0];
    }
  }
  Future pickImage() async{
    final imageRaw = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(imageRaw == null){
      return;
    }
    image = File(imageRaw.path);
    setState(() {});
    //Connection().uploadImg(File(image!.path));
  }
  

  void showError(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 200, 99, 92),
        content: Text(msg),
      )
    );
  }
}