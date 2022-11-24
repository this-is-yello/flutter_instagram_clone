import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instagram_clone/style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flutter/rendering.dart'; // 스크롤 관련 함수

void main() {
  runApp(
    MaterialApp(
      theme: style.theme,
      home: MyApp()
    )
  );
}

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
    print(data);
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
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) { return Text('New Page');})
              );
            },
          )
        ],
      ),

      body: [InstaHome(data: data, addData: addData), InstaShop()][tab],
      // body: [
      //   Center(child: Text('인스타그램 홈', style: Theme.of(context).textTheme.bodyText1)),
      //   Center(child: Text('인스타그램 샵', style: Theme.of(context).textTheme.bodyText1))
      // ][tab],
      
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

// -------------------------instagram_home------------------------------ //
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
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent && yes == true) {
        print(scroll.position.maxScrollExtent);
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
    

    // return Scaffold(
    //   body: ListView(
    //     children: [
    //       Container(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Center(
    //               child: Image.asset('lib/images/bykak.jpg', width: 600)
    //             ),
    //             Center(
    //               child: Container(
    //                 padding: EdgeInsets.all(8),
    //                 width: 600,
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text('좋아요 100', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
    //                     Text('글쓴이'),
    //                     Text('글 내용')
    //                   ]
    //                 )
    //               ),
    //             ),
    //           ]
    //         )
    //       ),
    //     ]
    //   ),
    // );
  }
}

// -------------------------instagram_shop------------------------------ //
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