import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    print(result2);
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
            onPressed: () {},
          )
        ],
      ),

      body: [InstaHome(getData: getData)][0],
      // body: [
      //   Center(child: Text('인스타그램 홈', style: Theme.of(context).textTheme.bodyText1)),
      //   Center(child: Text('인스타그램 샵', style: Theme.of(context).textTheme.bodyText1))
      // ][tab],
      
      bottomNavigationBar: BottomNavigationBar(
        // onTap: (i) {
        //   print(i);
        //   setState(() {
        //     tab = i;
        //   });
        // },
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
class InstaHome extends StatelessWidget {
  const InstaHome({super.key, this.getData});

  final getData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, i) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/images/bykak.jpg'),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(getData[i]['likes']),
                  Text('글쓴이'),
                  Text('글내용'),
                ],
              ),
            )
          ],
        );
      } 
    );

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