import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instagram_clone/style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart'; // 스크롤 관련 함수
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (c) => Store(),
      child: MaterialApp(
        theme: style.theme,
        home: MyApp()
      )
    )
  );
}

class Store extends ChangeNotifier {
  
}


// ------------------------------ MyApp ----------------------------------- //
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2;
    });
    // print(data);
  }

  addData(a) {
    setState(() {
      data.add(a);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) { return Center(child: NotiPage());})
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () async{
              // var picker = ImagePicker();
              // var image = await picker.pickImage(source: ImageSource.gallery);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => UploadPage())
              );
            },
          )
        ],
      ),

      body: [InstaHome(data: data, addData: addData), InstaShop()][tab],
      
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          print(i);
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 30),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined, size: 30),
            label: 'shop',
          )
        ],
      ),
    );
  }
}


// ------------------------------ instagram_home ----------------------------------- //
class InstaHome extends StatefulWidget {
  const InstaHome({super.key, this.getData, this.data, this.addData});

  final getData;
  final data;
  final addData;

  @override
  State<InstaHome> createState() => _InstaHomeState();
}

class _InstaHomeState extends State<InstaHome> {

  var scroll = ScrollController();
  bool yes = true;

  moreData() async {
    var result3 = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result4 = jsonDecode(result3.body);
    widget.addData(result4);
    // print(result4);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent && yes == true) {
        // print(scroll.position.maxScrollExtent);
        moreData();
        yes = false; 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty) {
      return ListView.builder(
        controller: scroll,
        itemCount: widget.data.length,
        itemBuilder: (context, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.data[i]['image']),
              Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Text(widget.data[i]['user'], style: TextStyle(fontWeight: FontWeight.w600),),
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (c) => ProfilePage(data: widget.data[i]))
                        );
                      },
                    ),
                    Text('좋아요 ${widget.data[i]['likes']}'),
                    Text(widget.data[i]['content']),
                    Text(widget.data[i]['date']),
                  ],
                ),
              )
            ],
          );
        } 
      );
    } else {
      return Text('Loading');
    }
  }
}


// ------------------------------ instagram_shop ----------------------------------- //
class InstaShop extends StatelessWidget {
  const InstaShop({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, j) {
        return Column(
          children: [
            Text('샵입니다'),
            Text('${j}')
          ],
        );
      },
    );
  }
}


// ------------------------------ upload_page ----------------------------------- //
class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text('완료', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
            onPressed: () {
              Navigator.pop(context);
            }
          )
        ],
        iconTheme: IconThemeData(color: Colors.black)
      ),
    );
  }
}


// ------------------------------ notification_page ----------------------------------- //
class NotiPage extends StatelessWidget {
  const NotiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text('모두삭제', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
            onPressed: () {
              Navigator.pop(context);
            }
          )
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}


// ------------------------------ profile_page ----------------------------------- //
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.data});

  final data;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
  var follow = 0;
  var flwBtn = '팔로우';

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.data['user'])),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            }
          )
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(25)),
          ),
          title: Text('팔로워' + ' ' + '${follow}' + '명'),
          trailing: ElevatedButton(
            child: Text(flwBtn),
            onPressed: (() {
              if(follow == 1) {
                setState(() {
                  follow --;
                  flwBtn = "팔로우";
                });
              } else {
                setState(() {
                  follow ++;
                  flwBtn = '언팔로우';
                });
              }
            }),
          ),
        ),
      ),
    );
  }
}