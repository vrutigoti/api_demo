import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:api_demo/view_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


void main()
{
  runApp(MaterialApp(
    home: first(),
    debugShowCheckedModeBanner: false,
  ));
}
class first extends StatefulWidget {
final l;
 first([this.l]);


  @override
  State<first> createState() => _firstState();
}
//hello word
class _firstState extends State<first> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  TextEditingController t3=TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? photo;

  bool t=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.l!=null)
    {
      t1.text=widget.l!['name'];
      t2.text=widget.l!['contact'];
      t3.text=widget.l!['city'];
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(controller: t1,decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter Name"),),
          TextField(controller: t2,decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter Contact"),),
          TextField(controller: t3,decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter City"),),

          ElevatedButton(onPressed: () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text("Choose any one"),
                actions: [
                  Row(
                    children: [

                      TextButton(onPressed: () async {
                        photo = await picker.pickImage(source: ImageSource.camera);
                        t=true;
                        Navigator.pop(context);
                        setState(() {

                        });
                      }, child: Text("Camera")),
                      TextButton(onPressed: () async {
                        photo = await picker.pickImage(source: ImageSource.gallery);
                        t=true;
                        Navigator.pop(context);
                        setState(() {

                        });
                      }, child: Text("Gallary"))
                    ],
                  )
                ],
              );
            },);
          }, child: Text("Choose")),
          Row(
            children: [
              Container(
                  height: 50,
                  width: 50,
                  //color: Colors.pinkAccent,

                child: (t)?Image.file(File(photo!.path)):null
              ),
            ],

          ),
          ElevatedButton(onPressed: () async {
            String name=t1.text;
            String contact=t2.text;
            String city=t3.text;
            String image;
            image=base64Encode(await photo!.readAsBytes());

            var url;
            if(widget.l!=null)

              {
                 url = Uri.parse('https://syflutter.000webhostapp.com/add_api.php?name=$name&contact=$contact&city=$city&image=$image&id=${widget.l['id']}');
              }else
                {
                  url = Uri.parse('https://syflutter.000webhostapp.com/add_api.php');
                  //url = Uri.parse('https://syflutter.000webhostapp.com/add_api.php?name=$name&contact=$contact&city=$city');

                }

            var response = await http.post(url,body: {
              'name':'$name',
              'contact':'$contact',
              'city':'$city',
              'image':'$image',
              'image_name':'${photo!.name}',


            });
            print('Response status: ${response.statusCode}');
            print('Response body: ${response.body}');
            Map m=jsonDecode(response.body);
            print(m);

          }, child: Text("Submit")),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return view_data();
            },));
          }, child: Text("viewdata")),

        ],
      ),
    );
  }
}




