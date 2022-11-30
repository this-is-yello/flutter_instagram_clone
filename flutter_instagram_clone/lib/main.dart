import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instagram_clone/style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart'; // 스크롤 관련 함수
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter_instagram_clone/notification.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (c) => Store()),
    ChangeNotifierProvider(create: (c) => Store2())
  ], child: MaterialApp(theme: style.theme, home: MyApp())));
}

// Provider
class Store extends ChangeNotifier {
  var follow = 0;
  var flwBtn = '팔로우';

  bool friend = false;

  follower() {
    if (friend == false) {
      follow++;
      flwBtn = '언팔로우';
      friend = true;
    } else {
      follow--;
      flwBtn = '팔로우';
      friend = false;
    }
    notifyListeners(); //스테이트가 바뀐 걸 알려줄 때 (setState)
  }
}

class Store2 extends ChangeNotifier {
  var tab = 0;

  var profileImg = [];

  getProfile() async {
    var result5 = await http
        .get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result6 = jsonDecode(result5.body);
    profileImg = result6;
    print(result6);
    notifyListeners();
  }
}

// ------------------------------ MyApp ----------------------------------- //
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var data = [];

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
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
    initNotification(context);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('알림'),
        onPressed: (() {
          showNotification();
        }),
      ),
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) {
                return Center(child: NotiPage());
              }));
            },
          ),
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () async {
              // var picker = ImagePicker();
              // var image = await picker.pickImage(source: ImageSource.gallery);
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => UploadPage()));
            },
          )
        ],
      ),
      body: [
        InstaHome(data: data, addData: addData),
        InstaShop()
      ][context.watch<Store2>().tab],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          print(i);
          setState(() {
            context.watch<Store2>().tab = i;
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
    var result3 = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result4 = jsonDecode(result3.body);
    widget.addData(result4);
    // print(result4);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent &&
          yes == true) {
        // print(scroll.position.maxScrollExtent);
        moreData();
        yes = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
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
                        child: Text(
                          widget.data[i]['user'],
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) =>
                                      ProfilePage(data: widget.data[i])));
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
          });
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
          children: [Text('샵입니다'), Text('${j}')],
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
      appBar: AppBar(actions: [
        TextButton(
            child: Text('완료',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600)),
            onPressed: () {
              Navigator.pop(context);
            })
      ], iconTheme: IconThemeData(color: Colors.black)),
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
              child: Text('모두삭제',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.pop(context);
              })
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

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<Store2>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.data['user'])),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                (c, i) => Container(
                    // margin: EdgeInsets.all(8),
                    child:
                        Image.network(context.watch<Store2>().profileImg[i])),
                childCount: context.watch<Store2>().profileImg.length),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          )
        ],
      ),
      // body: GridView.builder(
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      //   itemBuilder:(c, i) {
      //     return Container(
      //       color: Colors.grey
      //     );
      //   },
      // ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: ListTile(
        leading: CircleAvatar(
          //동그란 이미지를 넣을 때
          // radius: 50,
          // backgroundColor: Colors.black,
          backgroundImage: AssetImage('lib/images/bykak.jpg'),
        ),
        title: Text('팔로워 ${context.watch<Store>().follow} 명'),
        trailing: ElevatedButton(
          child: Text(context.watch<Store>().flwBtn),
          onPressed: (() {
            context.read<Store>().follower();
          }),
        ),
      ),
    );
  }
}
